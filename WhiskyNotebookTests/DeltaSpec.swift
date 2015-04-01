// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import UIKit
import WhiskyNotebook


final class DeltaSpec: QuickSpec {
    override func spec() {
        describe("DeltaSpec") {
            let old = [Dram(id: "1", date: nil, rating: Rating.Positive), Dram(id: "2", date: nil, rating: Rating.Positive)]
            let new = [Dram(id: "2", date: nil, rating: Rating.Neutral), Dram(id: "3", date: nil, rating: Rating.Positive)]
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