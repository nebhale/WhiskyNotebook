// Copyright 2014-2015 Ben Hale. All Rights Reserved

import CloudKit


final class Distillery: RecordBased, Comparable, Equatable, Hashable, Printable {
    
    private let record: CKRecord
    
    var description: String { return "<Distillery: \(self.id); name=\(self.name), region=\(self.region), location=\(self.location)>" }
    
    var hashValue: Int {
        if let id = self.id {
            return id.hashValue
        } else {
            return 0
        }
    }
    
    var id: String? {
        get { return self.record.objectForKey("Id") as? String }
        set { self.record.setObject(newValue, forKey: "Id") }
    }
    
    var name: String? {
        get { return self.record.objectForKey("Name") as? String }
        set { self.record.setObject(newValue, forKey: "Name") }
    }
    
    var region: String? {
        get { return self.record.objectForKey("Region") as? String }
        set { self.record.setObject(newValue, forKey: "Region") }
    }
    
    var location: CLLocation? {
        get { return self.record.objectForKey("Location") as? CLLocation }
        set { self.record.setObject(newValue, forKey: "Location") }
    }
    
    init(record: CKRecord) {
        self.record = record
    }
    
    convenience init() {
        self.init(record: CKRecord(recordType: "Distillery"))
    }
    
    func toRecord() -> CKRecord {
        return self.record
    }
}

func ==(x: Distillery, y: Distillery) -> Bool {
    return x.id == y.id
}

func <(x: Distillery, y: Distillery) -> Bool {
    let parseId: String -> Int = { $0.substringFromIndex(advance($0.startIndex, 1)).toInt()! }
    
    let comparisonValue: String? -> Int = { candidateId in
        let id = candidateId != nil ? candidateId! : "0"
        
        switch(id[0]) {
        case "B":
            return 2000 + parseId(id)
        case "G":
            return 7000 + parseId(id)
        case "R":
            return 18000 + parseId(id)
        default:
            return id.toInt()!
        }
    }
    
    return comparisonValue(x.id) < comparisonValue(y.id)
}
