// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation


public struct Dram {

    public var id: String?

    public var date: NSDate? = NSDate()

    public var rating: Rating?

    private let syntheticKey: String = NSUUID().UUIDString

    public init() {}

    public init(id: String?, date: NSDate?, rating: Rating?) {
        self.id = id;
        self.date = date
        self.rating = rating
    }
}

// MARK: - Equatable
extension Dram: Equatable {}
public func ==(x: Dram, y: Dram) -> Bool {
    return x.syntheticKey == y.syntheticKey
}

// MARK: - Hashable
extension Dram: Hashable {
    public var hashValue: Int { return syntheticKey.hashValue }
}

// MARK: - Printable
extension Dram: Printable {
    public var description: String { return "<Dram: \(self.syntheticKey); id=\(self.id), date=\(self.date), rating=\(self.rating)>" }
}
