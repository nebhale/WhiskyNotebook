// Copyright 2014-2015 Ben Hale. All Rights Reserved

import CloudKit
import Foundation
import ReactiveCocoa


public final class CloudKitDramRepository: DramRepository {

    private let content: MutableProperty<[Dram : CKRecord]> = MutableProperty([:])

    private let database = CKContainer.defaultContainer().privateCloudDatabase

    public let drams: SignalProducer<Set<Dram>, NoError>

    private let logger = Logger()

    private let scheduler: SchedulerType = QueueScheduler()

    public init() {
        self.drams = self.content.producer
            |> map { Set($0.keys) }

        fetchRecords()
            |> map(mapRecords)
            |> observe { self.content.value = $0 }
    }

    public func delete(dram: Dram) {
        Signal<CKRecordID, NSError> { sink in
            return self.scheduler.schedule {
                self.logger.info("Deleting: \(dram)")
                self.database.deleteRecordWithID(self.getRecord(dram).recordID, completionHandler: signalingCompletionHandler(sink))
            }}
            |> observe(
                error: { error in self.logger.error("Error deleting: \(error)") }, // TODO: Handle CloudKit errors better than this
                next: { _ in self.content.value[dram] = nil }
        )
    }

    public func save(dram: Dram) {
        Signal<CKRecord, NSError> { sink in
            return self.scheduler.schedule {
                self.logger.info("Saving: \(dram)")
                self.database.saveRecord(self.getRecord(dram).updateWith(dram), completionHandler: signalingCompletionHandler(sink))
            }}
            |> observe(
                error: { error in self.logger.error("Error saving: \(error)") }, // TODO: Handle CloudKit errors better than this
                next: { record in
                    self.logger.info("Saved: \(record)")
                    var mutableDram = dram
                    self.content.value[mutableDram.updateWith(record)] = record
            })
    }

    private func fetchRecords() -> Signal<[CKRecord], NSError> {
        let (operationSignal, operationSink) = Signal<CKQueryOperation, NSError>.pipe()
        let (recordSignal, recordSink) = Signal<CKRecord, NSError>.pipe()

        operationSignal
            |> observeOn(self.scheduler)
            |> observe { operation in
                self.logger.info("Fetching")

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

        sendNext(operationSink, CKQueryOperation(query: CKQuery(recordType: "Dram", predicate: NSPredicate(format: "TRUEPREDICATE"))))

        return recordSignal
            |> collect
    }

    private func getRecord(dram: Dram) -> CKRecord {
        return self.content.value[dram] ?? CKRecord(recordType: "Dram")
    }

    private func mapRecords(records: [CKRecord]) -> [Dram : CKRecord] {
        var content: [Dram : CKRecord] = [:]

        for record in records {
            var dram = Dram()
            content[dram.updateWith(record)] = record
        }

        return content
    }
}

// MARK: - Updates
extension Dram {
    private mutating func updateWith(record: CKRecord) -> Dram {
        self.id = record.objectForKey("Id") as? String
        self.date = record.objectForKey("Date") as? NSDate

        if let rawValue = record.objectForKey("Rating") as? Int {
            self.rating = Rating(rawValue: rawValue)
        }

        return self
    }
}

extension CKRecord {
    private func updateWith(dram: Dram) -> CKRecord {
        self.setObject(dram.id, forKey: "Id")
        self.setObject(dram.date, forKey: "Date")
        self.setObject(dram.rating?.rawValue, forKey: "Rating")
        return self
    }
}