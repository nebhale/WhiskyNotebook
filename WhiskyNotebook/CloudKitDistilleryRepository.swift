// Copyright 2014-2015 Ben Hale. All Rights Reserved

import CloudKit
import Foundation
import ReactiveCocoa


public final class CloudKitDistilleryRepository: DistilleryRepository {

    private let content: MutableProperty<[Distillery : CKRecord]> = MutableProperty([:])

    private let database = CKContainer.defaultContainer().publicCloudDatabase

    public let distilleries: SignalProducer<Set<Distillery>, NoError>

    private let logger = Logger()

    public init() {
        self.distilleries = self.content.producer
            |> map { Set($0.keys) }

        fetchRecords()
            |> map(mapRecords)
            |> observe { self.content.value = $0}
    }

    public func delete(distillery: Distillery) {
        Signal<CKRecordID, NSError> { sink in
            self.logger.info("Deleting: \(distillery)")
            self.database.deleteRecordWithID(self.getRecord(distillery).recordID, completionHandler: signalingCompletionHandler(sink))
            return nil
            }
            |> observeOn(QueueScheduler())
            |> observe(
                error: { error in self.logger.error("Error deleting: \(error)") }, // TODO: Handle CloudKit errors better than this
                next: { _ in self.content.value[distillery] = nil }
        )
    }

    public func save(distillery: Distillery) {
        Signal<CKRecord, NSError> { sink in
            self.logger.info("Saving: \(distillery)")
            self.database.saveRecord(self.getRecord(distillery).updateWith(distillery), completionHandler: signalingCompletionHandler(sink))
            return nil
            }
            |> observeOn(QueueScheduler())
            |> observe(
                error: { error in self.logger.error("Error saving: \(error)") }, // TODO: Handle CloudKit errors better than this
                next: { record in
                    self.logger.info("Saved: \(record)")
                    var mutableDistillery = distillery
                    self.content.value[mutableDistillery.updateWith(record)] = record
            })
    }

    private func fetchRecords() -> Signal<[CKRecord], NSError> {
        let (operationSignal, operationSink) = Signal<CKQueryOperation, NSError>.pipe()
        let (recordSignal, recordSink) = Signal<CKRecord, NSError>.pipe()

        operationSignal
            |> observeOn(QueueScheduler())
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

        sendNext(operationSink, CKQueryOperation(query: CKQuery(recordType: "Distillery", predicate: NSPredicate(format: "TRUEPREDICATE"))))

        return recordSignal
            |> collect
    }

    private func getRecord(distillery: Distillery) -> CKRecord {
        return self.content.value[distillery] ?? CKRecord(recordType: "Distillery")
    }

    private func mapRecords(records: [CKRecord]) -> [Distillery : CKRecord] {
        var content: [Distillery : CKRecord] = [:]

        for record in records {
            var distillery = Distillery()
            content[distillery.updateWith(record)] = record
        }

        return content
    }
}

// MARK: - Updates
extension Distillery {
    private mutating func updateWith(record: CKRecord) -> Distillery {
        self.id = record.objectForKey("Id") as? String
        self.location = record.objectForKey("Location") as? CLLocation
        self.name = record.objectForKey("Name") as? String

        if let rawValue = record.objectForKey("Region") as? String {
            self.region = Region(rawValue: rawValue)
        }

        return self
    }
}

extension CKRecord {
    private func updateWith(distillery: Distillery) -> CKRecord {
        self.setObject(distillery.id, forKey: "Id")
        self.setObject(distillery.location, forKey: "Location")
        self.setObject(distillery.name, forKey: "Name")
        self.setObject(distillery.region?.rawValue, forKey: "Region")
        return self
    }
}