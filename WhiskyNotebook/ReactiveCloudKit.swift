// Copyright 2014-2015 Ben Hale.  All Rights Reserved.

import CloudKit
import ReactiveCocoa


func accountStatus() -> Signal<CKAccountStatus, NSError> {
    return Signal<CKAccountStatus, NSError> { observer in
        CKContainer.defaultContainer().accountStatusWithCompletionHandler { status, error in
            if let error = error {
                sendError(observer, error)
                return
            }

            sendNext(observer, status)
            sendCompleted(observer)
        }

        return nil
    }
}

func fetchCurrentUserRecord(database database: CKDatabase, qualityOfService: NSQualityOfService = .Utility) -> Signal<CKRecord, NSError> {
    return fetchRecords(CKFetchRecordsOperation.fetchCurrentUserRecordOperation(), database: database, qualityOfService: qualityOfService)
        .map { record, _ in record }
}

private func fetchRecords(operation: CKFetchRecordsOperation, database: CKDatabase, qualityOfService: NSQualityOfService = .Utility) -> Signal<(CKRecord, CKRecordID), NSError> {
    return Signal { observer in
        operation.qualityOfService = .Utility

        operation.perRecordCompletionBlock = { record, recordID, error in
            if let error = error {
                sendError(observer, error)
            } else if let record = record, let recordID = recordID {
                sendNext(observer, (record, recordID))
            }
        }

        operation.fetchRecordsCompletionBlock = { _, _ in
            sendCompleted(observer)
        }

        CKContainer.defaultContainer().publicCloudDatabase.addOperation(operation)
        return nil
    }
}

func fetchAllSubscriptions(database database: CKDatabase, qualityOfService: NSQualityOfService = .Utility) -> Signal<(String, CKSubscription), NSError> {
    return fetchSubscriptions(CKFetchSubscriptionsOperation.fetchAllSubscriptionsOperation(), database: database, qualityOfService: qualityOfService)
}

private func fetchSubscriptions(operation: CKFetchSubscriptionsOperation, database: CKDatabase, qualityOfService: NSQualityOfService = .Utility) -> Signal<(String, CKSubscription), NSError> {
    return Signal { observer in
        operation.qualityOfService = qualityOfService

        operation.fetchSubscriptionCompletionBlock = { subscriptionsBySubscriptionID, error in
            if let error = error {
                sendError(observer, error)
                return
            } else if let subscriptionsBySubscriptionID = subscriptionsBySubscriptionID {
                for entry in subscriptionsBySubscriptionID {
                    sendNext(observer, entry)
                }
            }

            sendCompleted(observer)
        }

        database.addOperation(operation)
        return nil
    }
}

func modifySubscriptions(subscriptionsToSave subscriptionsToSave: [CKSubscription]? = nil, subscriptionIDsToDelete: [String]? = nil, database: CKDatabase, qualityOfService: NSQualityOfService = .Utility) -> Signal<([CKSubscription]?, [String]?), NSError> {
    return Signal { observer in
        let operation = CKModifySubscriptionsOperation(subscriptionsToSave: subscriptionsToSave, subscriptionIDsToDelete: subscriptionIDsToDelete)
        operation.qualityOfService = qualityOfService

        operation.modifySubscriptionsCompletionBlock = { savedRecords, deletedRecordIds, error in
            if let error = error {
                sendError(observer, error)
                return
            }

            sendNext(observer, (savedRecords, deletedRecordIds))
            sendCompleted(observer)
        }

        database.addOperation(operation)
        return nil
    }
}

func query(query: CKQuery, database: CKDatabase, qualityOfService: NSQualityOfService = .Utility) -> Signal<CKRecord, NSError> {
    let (recordSignal, recordObserver) = Signal<CKRecord, NSError>.pipe()
    let (operationSignal, operationObserver) = Signal<CKQueryOperation, NSError>.pipe()

    operationSignal
        .observe(next: { operation in
            operation.qualityOfService = qualityOfService

            operation.recordFetchedBlock = { record in
                sendNext(recordObserver, record)
            }

            operation.queryCompletionBlock = { cursor, error in
                if let error = error {
                    sendError(recordObserver, error)
                } else if let cursor = cursor {
                    sendNext(operationObserver, CKQueryOperation(cursor: cursor))
                } else {
                    sendCompleted(recordObserver)
                }
            }

            database.addOperation(operation)
        })
    
    sendNext(operationObserver, CKQueryOperation(query: query))
    return recordSignal
}
