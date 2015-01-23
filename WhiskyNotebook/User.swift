// Copyright 2014-2015 Ben Hale. All Rights Reserved

import CloudKit

final class User: RecordBased, Equatable, Hashable, Printable {
    
    private let record: CKRecord
    
    var description: String { return "<User: \(self.id); name=\(self.name), membership=\(self.membership)>" }
    
    var hashValue: Int { return self.id.hashValue }
    
    var id: String {
        get { return self.record.recordID.recordName }
    }
    
    var name: String? {
        get { return self.record.objectForKey("Name") as? String }
        set { self.record.setObject(newValue, forKey: "Name") }
    }
    
    var membership: String? {
        get { return self.record.objectForKey("Membership") as? String }
        set { self.record.setObject(newValue, forKey: "Membership") }
    }
    
    init(record: CKRecord) {
        self.record = record
    }
    
    func toRecord() -> CKRecord {
        return self.record
    }
    
}

func ==(x: User, y: User) -> Bool {
    return x.id == y.id
}