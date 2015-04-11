// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation


public struct Dram {

    public let id: String = NSUUID().UUIDString

    public var identifier: String?

    public var date: NSDate? = NSDate()

    public var rating: Rating?

    public init() {}

    public init(identifier: String?, date: NSDate?, rating: Rating?) {
        self.identifier = identifier;
        self.date = date
        self.rating = rating
    }
}

// MARK: - Equatable
extension Dram: Equatable {}
public func ==(x: Dram, y: Dram) -> Bool {
    return x.id == y.id
}

// MARK: - Hashable
extension Dram: Hashable {
    public var hashValue: Int { return id.hashValue }
}

// MARK: - Printable
extension Dram: Printable {
    public var description: String { return "<Dram: \(self.id); identifer=\(self.identifier), date=\(self.date), rating=\(self.rating)>" }
}
