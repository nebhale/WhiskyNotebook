// Copyright 2014-2015 Ben Hale. All Rights Reserved

import CloudKit


class User: NSObject, Equatable, Hashable, NSCoding, Printable, RecordBased {
    
    private let logger = Logger(name: "User")
    
    private let record: CKRecord
    
    override var description: String { return "<User: \(self.id); name=\(self.name), membership=\(self.membership), administrator=\(self.administrator)>" }
    
    override var hashValue: Int { return self.id.hashValue }
    
    var administrator: Bool? {
        get { return (self.record.objectForKey("Administrator") as? String)?.toBool() }
    }
    
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
    
    required init(coder: NSCoder) {
        self.record = CKRecord(coder: coder)
    }
    
    required init(record: CKRecord) {
        self.record = record
    }
    
    func encodeWithCoder(coder: NSCoder) {
        self.record.encodeWithCoder(coder)
    }
    
    func toRecord() -> CKRecord {
        return self.record
    }
    
}

func ==(x: User, y: User) -> Bool {
    return x.id == y.id
}