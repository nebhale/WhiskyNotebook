// Copyright 2014-2015 Ben Hale. All Rights Reserved

import CloudKit
import Foundation


final class UserRepository {

    static let instance = UserRepository()

    typealias Listener = User? -> Void

    private let cacheURL = URLForCached("User")

    private let database = CKContainer.defaultContainer().publicCloudDatabase

    private var listeners: [Memento : Listener] = [:]

    private let logger = Logger(name: "UserRepository")

    private let monitor = Monitor()

    private var user: User? {
        didSet {
            synchronized(self.monitor) {
                for listener in self.listeners.values {
                    listener(self.user)
                }
            }
        }
    }

    private init() {
        self.user = fetchFromCache()
        Subscription(recordType: CKRecordTypeUserRecord, database: self.database, subscriptionOptions: CKSubscriptionOptions.FiresOnRecordUpdate, notificationHandler: fetchFromCloudKit)
    }

    func save(user: User?) {
        if let user = user {
            self.logger.debug { "Saving user \(user)" }

            self.database.saveRecord(user.toRecord()) { record, error in
                if error != nil {
                    // TODO: Handle error saving record
                    self.logger.error { "Error saving user: \(error)"}
                    return
                }

                self.user = User(record: record)
                self.saveToCache(self.user)
                self.logger.info { "Saved user: \(self.user)" }
            }
        }
    }

    func subscribe(listener: Listener) -> Memento {
        return synchronized(self.monitor) {
            let memento = Memento()
            self.listeners[memento] = listener
            listener(self.user)
            return memento
        }
    }

    func unsubscribe(memento: Memento?) {
        if let memento = memento {
            synchronized(self.monitor) {
                self.listeners[memento] = nil
            }
        }
    }

    private func fetchFromCache() -> User? {
        if let cacheURL = self.cacheURL {
            self.logger.debug { "Fetching cached user" }

            if let data = NSData(contentsOfURL: cacheURL) {
                let user = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? User
                self.logger.debug { "Fetched cached user: \(user)" }
                return user
            } else {
                self.logger.debug { "No cached user to fetch" }
                return nil
            }
        } else {
            self.logger.warn { "Unable to fetch cached user" }
            return nil
        }
    }

    private func fetchFromCloudKit() {
        self.logger.debug { "Fetching user" }

        let operation = CKFetchRecordsOperation.fetchCurrentUserRecordOperation()
        operation.perRecordCompletionBlock = { record, recordId, error in
            if error != nil {
                //TODO: Handle error fetching record
                self.logger.error { "Error fetching user: \(error)" }
                return
            }

            let user = User(record: record)
            self.saveToCache(user)

            self.logger.info { "Fetched user: \(user)" }
            self.user = user
        }

        self.database.addOperation(operation)
    }

    private func saveToCache(user: User?) {
        switch (user, self.cacheURL) {
        case (.Some(let user), .Some(let cacheURL)):
            NSKeyedArchiver.archivedDataWithRootObject(user).writeToURL(cacheURL, atomically: true)
            self.logger.debug { "Saved cached user: \(user)" }
        case (.None, .Some(let cacheURL)):
            NSFileManager.defaultManager().removeItemAtURL(cacheURL, error: nil)
            self.logger.debug { "Removed cached user" }
        default:
            self.logger.warn { "Unable to save cached user" }
        }
    }

}
