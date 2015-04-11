// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import UIKit
import WhiskyNotebook


final class DeltaSpec: QuickSpec {
    override func spec() {
        describe("DeltaSpec") {
            let dram1 = Dram(identifier: "1", date: nil, rating: .Positive)
            let dram2 = Dram(identifier: "2", date: nil, rating: .Positive)
            let dram3 = Dram(identifier: "3", date: nil, rating: .Positive)

            var dram2b = dram2
            dram2b.rating = .Neutral

            let old = [dram1, dram2]
            let new = [dram2b, dram3]
            let delta = Delta(old: old, new: new)

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
}