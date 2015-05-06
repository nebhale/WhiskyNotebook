// Copyright 2014-2015 Ben Hale. All Rights Reserved


import CloudKit
import CoreLocation
import ReactiveCocoa

final class CloudKitDistilleryRepository: DistilleryRepository {

    let distilleries: PropertyOf<Set<Distillery>>

    private let delegate: CloudKitRepository<Distillery>

    init(scheduler: SchedulerType) {
        self.delegate = CloudKitRepository(
            database: CKContainer.defaultContainer().publicCloudDatabase,
            recordType: "Distillery",
            scheduler: scheduler,
            updateItem: CloudKitDistilleryRepository.updateItem,
            updateRecord: CloudKitDistilleryRepository.updateRecord
        )
        self.distilleries = self.delegate.items
    }

    convenience init() {
        self.init(scheduler: QueueScheduler())
    }

    func delete(distillery: Distillery) {
        self.delegate.delete(distillery)
    }

    func save(distillery: Distillery) {
        self.delegate.save(distillery)
    }

    // MARK: -
    private static func updateItem(distillery: Distillery?, record: CKRecord) -> Distillery {
        var _distillery = distillery ?? Distillery()

        _distillery.id = record.objectForKey("Id") as? String
        _distillery.location = record.objectForKey("Location") as? CLLocation
        _distillery.name = record.objectForKey("Name") as? String

        if let rawValue = record.objectForKey("Region") as? String {
            _distillery.region = Region(rawValue: rawValue)
        }

        return _distillery
    }

    private static func updateRecord(record: CKRecord, distillery: Distillery) -> CKRecord {
        record.setObject(distillery.id, forKey: "Id")
        record.setObject(distillery.location, forKey: "Location")
        record.setObject(distillery.name, forKey: "Name")
        record.setObject(distillery.region?.rawValue, forKey: "Region")

        return record
    }
}
