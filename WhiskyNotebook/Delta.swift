// Copyright 2014-2015 Ben Hale. All Rights Reserved

public struct Delta {
    public let added: [Int]

    public let deleted: [Int]

    public let modified: [Int]

    public let new: [Dram]

    public let old: [Dram]

    public init(old: [Dram], new: [Dram]) {
        self.old = old
        self.new = new

        self.added = (new - old).map { new.indexOf($0)! }
        self.deleted = (old - new).map { old.indexOf($0)! }
        self.modified = (old & new)
            .filter { $0.exactMatch(new[new.indexOf($0)!]) }
            .map { old.indexOf($0)! }
    }
}

extension Dram {
    public func exactMatch(dram: Dram) -> Bool {
        return self.identifier == dram.identifier && self.date == dram.date && self.rating == dram.rating
    }
}