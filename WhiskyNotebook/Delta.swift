// Copyright 2014-2015 Ben Hale. All Rights Reserved

public struct Delta<T: Equatable> {

    public let added: [Int]

    public let deleted: [Int]

    public let modified: [Int]

    public let new: [T]

    public let old: [T]

    typealias ContentMatcher = (x: T, y: T) -> Bool

    public init(old: [T], new: [T], contentMatches: ContentMatcher) {
        self.old = old
        self.new = new

        self.added = (new - old).map { new.indexOf($0)! }
        self.deleted = (old - new).map { old.indexOf($0)! }
        self.modified = (old & new)
            .filter { contentMatches(x: $0, y: new[new.indexOf($0)!]) }
            .map { old.indexOf($0)! }
    }

}