// Copyright 2014-2015 Ben Hale.  All Rights Reserved.

import CacheCache
import CloudKit
import Foundation
import LoggerLogger
import ReactiveCocoa


final class CKProfileRepository: ProfileRepository {

    private let database = CKContainer.defaultContainer().publicCloudDatabase

    private let logger = Logger()

    private let _profile: MutableProperty<CKProfile>

    let profile: PropertyOf<Profile>

    private let key = "profile"

    // MARK: -

    init<T: Cache where T.PayloadType == CKProfile>(cache: T) {
        let initialValue = cache.retrieve(deserializer: CKProfileRepository.deserialize) ?? CKProfile()
        self._profile = MutableProperty(initialValue)

        let typeConverter = MutableProperty<Profile>(CKProfile() as Profile)
        typeConverter <~ self._profile.producer
            .map { $0 as Profile }

        self.profile = PropertyOf(typeConverter)
        self._profile.producer
            .skip(1)
            .skipRepeats { $0 == $1 }
            .start { cache.persist($0, serializer: CKProfileRepository.serialize) }

        subscribe()
    }

    // MARK: - Cache

    private static func deserialize(value: Any) -> CKProfile? {
        guard let data = value as? NSData else {
            return nil
        }

        let coder = NSKeyedUnarchiver(forReadingWithData: data)
        let record = CKRecord(coder: coder)
        return CKProfile(record: record)
    }

    private static func serialize(profile: CKProfile) -> Any {
        let data = NSMutableData()

        let coder = NSKeyedArchiver(forWritingWithMutableData: data)
        profile.record.encodeWithCoder(coder)
        coder.finishEncoding()

        return data
    }

    // MARK: Subscribe

    private func subscribe() {
        self.logger.info("Subscribing for profile changes")
        modifySubscriptions(subscriptionsToSave: [subscription()], database: self.database)
            .observe(
                error: { error in // TODO Improve error handling
                    switch CKErrorCode(rawValue: error.code) {
                    case .Some(.PartialFailure):
                        self.deleteExistingSubscription()
                    default:
                        self.logger.error("Error encountered subscribing for profile changes: \(error)")
                    }
                },
                completed: {
                    self.logger.debug("Subscribed for profile changes")
                    self.fetch()
            })
    }

    private func subscription() -> CKSubscription {
        let notificationInfo = CKNotificationInfo()
        notificationInfo.alertBody = self.key
        notificationInfo.shouldSendContentAvailable = true

        let subscription = CKSubscription(recordType: CKProfile.recordType, predicate: NSPredicate(value: true), options: [.FiresOnRecordCreation, .FiresOnRecordDeletion, .FiresOnRecordUpdate])
        subscription.notificationInfo = notificationInfo

        return subscription
    }

    private func deleteExistingSubscription() {
        self.logger.info("Deleting existing profile subscription")
        fetchAllSubscriptions(database: self.database)
            .filter { _, subscription in subscription.recordType == CKProfile.recordType }
            .map { subscriptionId, _ in subscriptionId }
            .observe(
                error: { self.logger.error("Error encountered deleting profile subscription: \($0)") }, // TODO Improve error handling
                next: { self.deleteExistingSubscription($0) })
    }

    private func deleteExistingSubscription(subscriptionId: String) {
        modifySubscriptions(subscriptionIDsToDelete: [subscriptionId], database: self.database)
            .observe(
                error: { self.logger.error("Error encountered deleting profile subscription: \($0)") }, // TODO Improve error handling
                completed: {
                    self.logger.debug("Deleted exsting profile subscription")
                    self.subscribe()
            })
    }

    // MARK: Fetch

    private func fetch() {
        self.logger.info("Fetching profile")
        query(CKQuery(recordType: CKProfile.recordType, predicate: NSPredicate(value: true)), database: self.database)
            .map { CKProfile(record: $0) }
            .observe(
                error: { self.logger.error("Error encountered fetching profile: \($0)") }, // TODO Improve error handling
                next: { self._profile.value = $0 },
                completed: { self.logger.debug("Fetched profile") })
    }
    
}