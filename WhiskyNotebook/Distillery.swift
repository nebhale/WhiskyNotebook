// Copyright 2014-2015 Ben Hale. All Rights Reserved


import CoreLocation
import Foundation

struct Distillery {

    var id: String?

    var location: CLLocation?

    var name: String?

    var region: Region?

    private let syntheticKey: String = NSUUID().UUIDString

}

// MARK: - Equatable
extension Distillery: Equatable {}
func ==(x: Distillery, y: Distillery) -> Bool {
    return x.syntheticKey == y.syntheticKey
}

// MARK: - Hashable
extension Distillery: Hashable {
    var hashValue: Int { return self.syntheticKey.hashValue }
}

// MARK: - Printable
extension Distillery: Printable {
    var description: String { return "<Distillery: \(self.syntheticKey); id=\(self.id), location=\(self.location), name=\(self.name), region=\(self.region)>" }
}
