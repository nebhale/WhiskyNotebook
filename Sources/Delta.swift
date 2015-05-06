// Copyright 2014-2015 Ben Hale. All Rights Reserved


struct Delta<T: Equatable> {

    let added: [Int]

    let deleted: [Int]

    let modified: [Int]

    let new: [T]

    let old: [T]

    typealias ContentMatches = (x: T, y: T) -> Bool

    init(old: [T], new: [T], contentMatches: ContentMatches) {
        self.old = old
        self.new = new

        self.added = (new - old).map { new.indexOf($0)! }
        self.deleted = (old - new).map { old.indexOf($0)! }
        self.modified = (old & new)
            .filter { contentMatches(x: $0, y: new[new.indexOf($0)!]) }
            .map { old.indexOf($0)! }
    }
}