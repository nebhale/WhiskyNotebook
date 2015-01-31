// Copyright 2014-2015 Ben Hale. All Rights Reserved

import CloudKit


class Distillery: NSObject, Comparable, Equatable, Hashable, NSCoding, Printable, RecordBased {
    
    private let logger = Logger(name: "Distillery")
    
    private let record: CKRecord
    
    override var description: String { return "<Distillery: \(self.id); name=\(self.name), region=\(self.region), location=\(self.location)>" }
    
    override var hashValue: Int {
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
    
    required init(coder: NSCoder) {
        self.record = CKRecord(coder: coder)
    }
    
    required init(record: CKRecord) {
        self.record = record
    }
    
    convenience override init() {
        self.init(record: CKRecord(recordType: "Distillery"))
    }
    
    convenience init(data: [String]) {
        self.init(record: CKRecord(recordType: "Distillery"))
        
        self.id = data[0]
        self.name = data[1]
        self.region = data[2]
        self.location = CLLocation(latitude: data[3].toDouble()!, longitude: data[4].toDouble()!)
    }
    
    func encodeWithCoder(coder: NSCoder) {
        self.record.encodeWithCoder(coder)
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
