// Copyright 2014-2015 Ben Hale.  All Rights Reserved.

import CacheCache
import CloudKit
import Foundation
import LoggerLogger
import ReactiveCocoa


final class CKDistilleryRepository: DistilleryRepository {

    private let database = CKContainer.defaultContainer().publicCloudDatabase

    private let _distilleries: MutableProperty<[CKDistillery]>

    let distilleries: PropertyOf<[Distillery]>

    private let key = "distillery"

    private let logger = Logger()

    // MARK: -

    init<T: Cache where T.PayloadType == [CKDistillery]>(cache: T) {
        let initialValue = cache.retrieve(deserializer: CKDistilleryRepository.deserialize) ?? []
        self._distilleries = MutableProperty(initialValue)

        let typeConverter = MutableProperty<[Distillery]>([])
        typeConverter <~ self._distilleries.producer
            .map { $0.map { $0 as Distillery } }

        self.distilleries = PropertyOf(typeConverter)
        self._distilleries.producer
            .skip(1)
            .skipRepeats { $0 == $1 }
            .start { cache.persist($0, serializer: CKDistilleryRepository.serialize) }

        subscribe()
    }

    // MARK: - Cache

    private static func deserialize(value: Any) -> [CKDistillery]? {
        guard let datas = value as? [NSData] else {
            return nil
        }

        return datas.map { data in
            let coder = NSKeyedUnarchiver(forReadingWithData: data)
            let record = CKRecord(coder: coder)
            return CKDistillery(record: record)
        }
    }

    private static func serialize(distilleries: [CKDistillery]) -> Any {
        return distilleries.map { distillery in
            let data = NSMutableData()

            let coder = NSKeyedArchiver(forWritingWithMutableData: data)
            distillery.record.encodeWithCoder(coder)
            coder.finishEncoding()

            return data
            } as [NSData]
    }

    // MARK: Subscribe

    private func subscribe() {
        self.logger.info("Subscribing for distillery changes")
        modifySubscriptions(subscriptionsToSave: [subscription()], database: self.database)
            .observe(
                error: { error in // TODO Improve error handling
                    switch CKErrorCode(rawValue: error.code) {
                    case .Some(.PartialFailure):
                        self.deleteExistingSubscription()
                    default:
                        self.logger.error("Error encountered subscribing for distillery changes: \(error)")
                    }
                },
                completed: {
                    self.logger.debug("Subscribed for distillery changes")
                    self.fetch()
            })
    }

    private func subscription() -> CKSubscription {
        let notificationInfo = CKNotificationInfo()
        notificationInfo.alertBody = self.key
        notificationInfo.shouldSendContentAvailable = true

        let subscription = CKSubscription(recordType: CKDistillery.recordType, predicate: NSPredicate(value: true), options: [.FiresOnRecordCreation, .FiresOnRecordDeletion, .FiresOnRecordUpdate])
        subscription.notificationInfo = notificationInfo

        return subscription
    }

    private func deleteExistingSubscription() {
        self.logger.info("Deleting existing distillery subscription")
        fetchAllSubscriptions(database: self.database)
            .filter { _, subscription in subscription.recordType == CKDistillery.recordType }
            .map { subscriptionId, _ in subscriptionId }
            .observe(
                error: { self.logger.error("Error encountered deleting distillery subscription: \($0)") }, // TODO Improve error handling
                next: { self.deleteExistingSubscription($0) })
    }

    private func deleteExistingSubscription(subscriptionId: String) {
        modifySubscriptions(subscriptionIDsToDelete: [subscriptionId], database: self.database)
            .observe(
                error: { self.logger.error("Error encountered deleting distillery subscription: \($0)") }, // TODO Improve error handling
                completed: {
                    self.logger.debug("Deleted exsting distillery subscription")
                    self.subscribe()
            })
    }

    // MARK: Fetch

    private func fetch() {
        self.logger.info("Fetching distilleries")
        query(CKQuery(recordType: CKDistillery.recordType, predicate: NSPredicate(value: true)), database: self.database)
            .map { CKDistillery(record: $0) }
            .collect()
            .map { $0.sort() }
            .observe(
                error: { self.logger.error("Error encountered fetching distilleries: \($0)") }, // TODO Improve error handling
                next: { self._distilleries.value = $0 },
                completed: { self.logger.debug("Fetched distilleries") })
    }
    
}