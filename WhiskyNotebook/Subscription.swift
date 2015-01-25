// Copyright 2014-2015 Ben Hale. All Rights Reserved

import CloudKit
import UIKit


final class Subscription {
    
    typealias NotificationHandler = () -> Void
    
    typealias SubscriptionSavedHandler = CKSubscription -> Void
    
    private let logger = Logger(name: "Subscription")
    
    private let notificationHandler: NotificationHandler
    
    private let subscriptionId: String
    
    init(recordType: String, database: CKDatabase, predicate: NSPredicate? = NSPredicate(format: "TRUEPREDICATE"), notificationHandler: NotificationHandler) {
        self.notificationHandler = notificationHandler
        self.subscriptionId = "\(recordType)|\(UIDevice.currentDevice().identifierForVendor.UUIDString)"
        
        RemoteNotificationBroker.instance.subscribe(didReceiveRemoteNotification)
        
        saveSubscription(subscriptionForRecordType(recordType, subscriptionId: self.subscriptionId, predicate: predicate), database: database) { subscription in
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: subscription.subscriptionID)
            self.notificationHandler()
        }
    }
    
    private func didReceiveRemoteNotification(userInfo: [NSObject : AnyObject]) -> UIBackgroundFetchResult {
        let notification = CKNotification(fromRemoteNotificationDictionary: userInfo)
        
        if notification.alertBody == self.subscriptionId {
            self.logger.debug { "Received notification: \(notification)" }
            
            self.notificationHandler()
            return UIBackgroundFetchResult.NewData
        } else {
            return UIBackgroundFetchResult.NoData
        }
    }
    
    private func saveSubscription(subscription: CKSubscription, database: CKDatabase, subscriptionSavedHandler: SubscriptionSavedHandler? = nil) {
        self.logger.debug { "Saving subscription \(subscription)" }
        
        database.saveSubscription(subscription) { subscription, error in
            if error != nil {
                // TODO:
                self.logger.error { "Error saving subscription: \(error)"}
                return
            }
            
            subscriptionSavedHandler?(subscription)
            self.logger.info { "Saved subscription: \(subscription)" }
        }
    }
    
    private func subscriptionForRecordType(recordType: String, subscriptionId: String, predicate: NSPredicate?) -> CKSubscription {
        let notificationInfo = CKNotificationInfo()
        notificationInfo.alertBody = subscriptionId
        notificationInfo.shouldSendContentAvailable = true
        
        let subscription = CKSubscription(recordType: recordType, predicate: predicate, subscriptionID: subscriptionId, options: CKSubscriptionOptions.FiresOnRecordCreation | CKSubscriptionOptions.FiresOnRecordUpdate | CKSubscriptionOptions.FiresOnRecordDeletion)
        subscription.notificationInfo = notificationInfo
        
        return subscription
    }
}