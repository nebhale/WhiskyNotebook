// Copyright 2014-2015 Ben Hale.  All Rights Reserved.

import CloudKit
import CoreLocation
import Foundation


struct CKDistillery: Distillery {

    static let recordType = "Distillery"

    var id: String? {
        get { return self.record["Id"] as? String }
        set { self.record["Id"] = newValue }
    }

    var location: CLLocation? {
        get { return self.record["Location"] as? CLLocation }
        set { self.record["Location"] = newValue }
    }

    var name: String? {
        get { return self.record["Name"] as? String }
        set { self.record["Name"] = newValue }
    }

    let record: CKRecord

    var region: Region? {
        get {
            if let rawValue = self.record["Region"] as? String {
                return Region(rawValue: rawValue)
            } else {
                return nil
            }
        }
        set { self.record["Region"] = newValue?.rawValue }
    }

    // MARK: -

    init(record: CKRecord? = nil) {
        self.record = record ?? CKRecord(recordType: CKDistillery.recordType)
    }

    init(id: String?, location: CLLocation?, name: String?, region: Region?) {
        self.init()

        self.id = id
        self.location = location
        self.name = name
        self.region = region
    }
}

// MARK: - Comparison
extension CKDistillery: Comparable {}
func <(x: CKDistillery, y: CKDistillery) -> Bool {
    return x.rank() < y.rank()
}

// MARK: Equatable
extension CKDistillery: Equatable {}
func ==(x: CKDistillery, y: CKDistillery) -> Bool {
    return x.record.recordID == y.record.recordID
}

// MARK: CustomStringConvertible
extension CKDistillery: CustomStringConvertible {
    var description: String { return "<CKDistillery: \(self.record.recordID.recordName); id=\(self.id), location=(\(self.location?.coordinate.latitude), \(self.location?.coordinate.longitude)), name=\(self.name), region=\(self.region)>" }
}