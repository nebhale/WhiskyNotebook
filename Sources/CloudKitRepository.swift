// Copyright 2014-2015 Ben Hale. All Rights Reserved

import CloudKit
import LoggerLogger
import ReactiveCocoa

final class CloudKitRepository<T: Hashable> {

    typealias UpdateItem = (T?, CKRecord) -> T

    typealias UpdateRecord = (CKRecord, T) -> CKRecord

    let items: PropertyOf<Set<T>>

    private let _items: MutableProperty<Set<T>>

    private let database: CKDatabase

    private let logger = Logger()

    private let records = MutableProperty([T : CKRecord]())

    private let recordType: String

    private let scheduler: SchedulerType

    private let updateItem: UpdateItem

    private let updateRecord: UpdateRecord

    init(database: CKDatabase, recordType: String, scheduler: SchedulerType, updateItem: UpdateItem, updateRecord: UpdateRecord) {
        self._items = MutableProperty(Set())
        self._items <~ self.records.producer
            |> map { Set($0.keys) }

        self.database = database
        self.items = PropertyOf(self._items)
        self.recordType = recordType
        self.scheduler = scheduler
        self.updateItem = updateItem
        self.updateRecord = updateRecord

        fetch()
    }

    func delete(item: T) {
        Signal<CKRecordID, NSError> { sink in
            return self.scheduler.schedule {
                self.logger.info("Deleting \(self.recordType) item: \(item)")

                let recordId = self.getRecord(item).recordID
                self.database.deleteRecordWithID(recordId, completionHandler: self.signalingCompletionHandler(sink))
            }}
            |> observe(
                error: { error in self.logger.error("Error deleting \(self.recordType) item: \(error)") }, // TODO: Handle CloudKit errors better than this
                next: { _ in
                    self.records.value[item] = nil
                    self.logger.debug("Deleted \(self.recordType) item: \(item)")
                }
        )
    }

    func save(item: T) {
        Signal<CKRecord, NSError> { sink in
            return self.scheduler.schedule {
                self.logger.info("Saving \(self.recordType) item: \(item)")

                let record = self.updateRecord(self.getRecord(item), item)
                self.database.saveRecord(record, completionHandler: self.signalingCompletionHandler(sink))
            }}
            |> observe(
                error: { error in self.logger.error("Error saving \(self.recordType) item: \(error)") }, // TODO: Handle CloudKit errors better than this
                next: { record in
                    let item = self.updateItem(item, record)
                    self.records.value[item] = record

                    self.logger.debug("Saved \(self.recordType) item: \(record)")
            })
    }

    private func fetch() {
        let (recordSignal, recordSink) = Signal<CKRecord, NSError>.pipe()
        recordSignal
            |> collect
            |> map { $0.toDictionary { self.updateItem(nil, $0) } }
            |> observe(
                error: { error in self.logger.error("Error fetching \(self.recordType) items: \(error)") }, // TODO: Handle CloudKit errors better than this
                next: { records in
                    self.records.value = records
                    self.logger.debug("Fetched \(self.recordType) items")
                }
        )

        let (operationSignal, operationSink) = Signal<CKQueryOperation, NSError>.pipe()
        operationSignal
            |> observeOn(self.scheduler)
            |> observe { operation in
                if operation.query != nil {
                    self.logger.info("Fetching \(self.recordType) items")
                } else {
                    self.logger.debug("Fetching \(self.recordType) items (continued)")
                }

                operation.recordFetchedBlock = { sendNext(recordSink, $0) }
                operation.queryCompletionBlock = { cursor, error in
                    if error != nil {
                        sendError(recordSink, error)
                    } else if cursor != nil {
                        sendNext(operationSink, CKQueryOperation(cursor: cursor))
                    } else {
                        sendCompleted(recordSink)
                    }
                }

                self.database.addOperation(operation)
        }

        sendNext(operationSink, CKQueryOperation(query: CKQuery(recordType: self.recordType, predicate: NSPredicate(format: "TRUEPREDICATE"))))
    }

    private func getRecord(item: T) -> CKRecord {
        return self.records.value[item] ?? CKRecord(recordType: self.recordType)
    }

    private func signalingCompletionHandler<U>(sink: SinkOf<Event<U, NSError>>)(value: U!, error: NSError!) {
        if error != nil {
            sendError(sink, error)
        } else {
            sendNext(sink, value)
        }
    }
}