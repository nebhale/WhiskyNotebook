// Copyright 2014-2015 Ben Hale. All Rights Reserved


import Foundation

struct Dram {

    var id: String?

    var date: NSDate?

    var rating: Rating?

    let syntheticKey: String = NSUUID().UUIDString

}

// MARK: - Equatable
extension Dram: Equatable {}
func ==(x: Dram, y: Dram) -> Bool {
    return x.syntheticKey == y.syntheticKey
}

// MARK: - Hashable
extension Dram: Hashable {
    var hashValue: Int { return self.syntheticKey.hashValue }
}

// MARK: - Printable
extension Dram: Printable {
    var description: String { return "<Dram: \(self.syntheticKey); id=\(self.id), date=\(self.date), rating=\(self.rating)>" }
}
