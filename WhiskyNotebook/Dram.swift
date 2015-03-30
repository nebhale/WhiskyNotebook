// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation


public struct Dram {

    public var id: String?

    public var date: NSDate

    public init() {
        self.date = NSDate()
    }

    public init(id: String?, date: NSDate) {
        self.id = id;
        self.date = date
    }
}

// MARK: - Equatable
extension Dram: Equatable {}
public func ==(x: Dram, y: Dram) -> Bool {
    return x.id == y.id
}

// MARK: - Hashable
extension Dram: Hashable {
    public var hashValue: Int {
        if let id = self.id {
            return id.hashValue
        } else {
            return 0
        }
    }
}

// MARK: - Printable
extension Dram: Printable {
    public var description: String { return "<Dram: \(self.id); date=\(self.date)>" }
}

// MARK: - Validation
extension Dram {
    public func valid() -> Bool {
        return validId() && validDate()
    }

    private func validDate() -> Bool {
        return self.date < NSDate()
    }

    private func validId() -> Bool {
        if let id = self.id {
            return id =~ "^[\\d]{1,3}\\.[\\d]{1,3}$"
        } else {
            return false
        }
    }
}
