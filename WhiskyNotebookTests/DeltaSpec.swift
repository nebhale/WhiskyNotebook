// Copyright 2014-2015 Ben Hale. All Rights Reserved


import Nimble
import Quick
import UIKit

final class DeltaSpec: QuickSpec {
    override func spec() {
        describe("DeltaSpec") {
            let dram1 = TestStruct(id: "1")
            let dram2 = TestStruct(id: "2")
            let dram3 = TestStruct(id: "3")

            var dram2b = dram2
            dram2b.id = "2b"

            let old = [dram1, dram2]
            let new = [dram2b, dram3]
            let delta = Delta(old: old, new: new, contentMatches: self.contentMatches)

            it("assigns old and new") {
                expect(delta.old).to(equal(old))
                expect(delta.new).to(equal(new))
            }

            it("calculates what was added") {
                expect(delta.added).to(equal([1]))
            }

            it("calculates what was deleted") {
                expect(delta.deleted).to(equal([0]))
            }

            it("calculates what was modified") {
                expect(delta.modified).to(equal([1]))
            }
        }
    }

    private func contentMatches(x: TestStruct, y: TestStruct) -> Bool {
        return x.id == y.id
    }
}

private struct TestStruct: Equatable {
    var id: String
    private let key = NSUUID().UUIDString
}

private func ==(x: TestStruct, y: TestStruct) -> Bool {
    return x.key == y.key
}
