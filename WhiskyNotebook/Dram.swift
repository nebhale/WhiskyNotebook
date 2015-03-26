// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation


public struct Dram {

    public var id: String?

    public init() {}

    public init(id: String?) {
        self.id = id;
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
    public var description: String { return "<Dram: \(self.id)>" }
}

// MARK: - Validation
extension Dram {
    public func valid() -> Bool {
        return validId()
    }

    private func validId() -> Bool {
        if let id = self.id {
            return id =~ "^[\\d]{1,3}\\.[\\d]{1,3}$"
        } else {
            return false
        }
    }
}
