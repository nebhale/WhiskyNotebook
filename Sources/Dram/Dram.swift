// Copyright 2014-2015 Ben Hale. All Rights Reserved


import Foundation

struct Dram {

    var id: String?

    var date: NSDate?

    var rating: Rating?

    private let key = NSUUID()
}

// MARK: - Equatable
extension Dram: Equatable {}
func ==(x: Dram, y: Dram) -> Bool {
    return x.key == y.key
}

// MARK: - Hashable
extension Dram: Hashable {
    var hashValue: Int { return self.key.hashValue }
}

// MARK: - Printable
extension Dram: Printable {
    var description: String { return "<Dram: \(self.key.UUIDString); id=\(self.id), date=\(self.date), rating=\(self.rating)>" }
}
