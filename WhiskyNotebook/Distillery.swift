// Copyright 2014-2015 Ben Hale. All Rights Reserved

import CoreLocation
import Foundation


public struct Distillery {

    public var id: String?

    public var location: CLLocation?

    public var name: String?

    public var region: Region?

    private let syntheticKey: String = NSUUID().UUIDString

    public init() {}

    public init(id: String?, location: CLLocation?, name: String?, region: Region?) {
        self.id = id;
        self.location = location
        self.name = name
        self.region = region
    }
}

// MARK: - Equatable
extension Distillery: Equatable {}
public func ==(x: Distillery, y: Distillery) -> Bool {
    return x.syntheticKey == y.syntheticKey
}

// MARK: - Hashable
extension Distillery: Hashable {
    public var hashValue: Int { return self.syntheticKey.hashValue }
}

// MARK: - Printable
extension Distillery: Printable {
    public var description: String { return "<Distillery: \(self.syntheticKey); id=\(self.id), location=\(self.location), name=\(self.name), region=\(self.region)>" }
}
