// Copyright 2014-2015 Ben Hale. All Rights Reserved


import CloudKit
import ReactiveCocoa

final class CloudKitDramRepository: DramRepository {

    let drams: PropertyOf<Set<Dram>>

    private let delegate: CloudKitRepository<Dram>

    init(scheduler: SchedulerType) {
        self.delegate = CloudKitRepository(
            database: CKContainer.defaultContainer().privateCloudDatabase,
            recordType: "Dram",
            scheduler: scheduler,
            updateItem: CloudKitDramRepository.updateItem,
            updateRecord: CloudKitDramRepository.updateRecord
        )
        self.drams = self.delegate.items
    }

    convenience init() {
        self.init(scheduler: QueueScheduler())
    }

    func delete(dram: Dram) {
        self.delegate.delete(dram)
    }

    func save(dram: Dram) {
        self.delegate.save(dram)
    }

    // MARK: -
    private static func updateItem(dram: Dram?, record: CKRecord) -> Dram {
        var _dram = dram ?? Dram()

        _dram.id = record.objectForKey("Id") as? String
        _dram.date = record.objectForKey("Date") as? NSDate

        if let rawValue = record.objectForKey("Rating") as? Int {
            _dram.rating = Rating(rawValue: rawValue)
        }

        return _dram
    }

    private static func updateRecord(record: CKRecord, dram: Dram) -> CKRecord {
        record.setObject(dram.id, forKey: "Id")
        record.setObject(dram.date, forKey: "Date")
        record.setObject(dram.rating?.rawValue, forKey: "Rating")
        
        return record
    }
}
