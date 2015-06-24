// Copyright 2014-2015 Ben Hale.  All Rights Reserved.

import CloudKit


struct CKProfile: Profile {

    static let recordType = CKRecordTypeUserRecord

    var administrator: Bool? {
        get { return (self.record["Administrator"] as? String)?.toBool() }
        set { self.record["Administrator"] = newValue?.description }
    }

    var membership: String? {
        get { return self.record["Membership"] as? String }
        set { self.record["Membership"] = newValue }
    }

    let record: CKRecord

    // MARK: -

    init(record: CKRecord? = nil) {
        self.record = record ?? CKRecord(recordType: CKProfile.recordType)
    }

    init(administrator: Bool?, membership: String?) {
        self.init()

        self.administrator = administrator
        self.membership = membership
    }
}

// MARK: - Equatable
extension CKProfile: Equatable {}
func ==(x: CKProfile, y: CKProfile) -> Bool {
    return x.record.recordID == y.record.recordID
}

// MARK: CustomStringConvertible
extension CKProfile: CustomStringConvertible {
    var description: String { return "<CKProfile: \(self.record.recordID.recordName); administrator=\(self.administrator), membership=\(self.membership)>" }
}

// MARK: -

extension String {
    func toBool() -> Bool {
        return self == true.description
    }
}
