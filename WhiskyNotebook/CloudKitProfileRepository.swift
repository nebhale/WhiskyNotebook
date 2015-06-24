// Copyright 2014-2015 Ben Hale.  All Rights Reserved.

import CloudKit
import LoggerLogger
import ReactiveCocoa


// TODO: Unfinished
final class CloudKitProfileRepository: ProfileRepository {

    private let logger = Logger()

    private let _profile: MutableProperty<Profile>

    let profile: PropertyOf<Profile>

    init() {
        self._profile = MutableProperty(RecordBasedProfile())
        self.profile = PropertyOf(self._profile)

        fetch()
    }

    private func fetch() {
        fetchCurrentUserRecord()
            |> observe(
                error: { error in
                    switch CKErrorCode(rawValue: error.code) {
                    case .Some(.NotAuthenticated):
                        self.logger.debug("User is not authenticated")
                        self._profile.value = RecordBasedProfile()
                    default:
                        self.logger.error(error)
                    }
                },
                next: { recordID in
                    self.logger.info("RecordID: \(recordID)")
            })
    }

    private func fetchCurrentUserRecord() -> Signal<CKRecord, NSError> {
        return Signal<CKRecord, NSError> { observer in
            self.logger.debug("Fetching current user record")

            let operation = CKFetchRecordsOperation.fetchCurrentUserRecordOperation()
            operation.qualityOfService = .Utility

            operation.perRecordCompletionBlock = { record, _, error in
                if let error = error {
                    sendError(observer, error)
                } else if let record = record {
                    sendNext(observer, record)
                }
            }

            operation.fetchRecordsCompletionBlock = { _, _ in
                sendCompleted(observer)
            }

            CKContainer.defaultContainer().publicCloudDatabase.addOperation(operation)
            return nil
        }
    }
}