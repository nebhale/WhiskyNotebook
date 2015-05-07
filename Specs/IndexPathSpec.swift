// Copyright 2014-2015 Ben Hale. All Rights Reserved


import Nimble
import Quick

final class IndexPathSpec: QuickSpec {
    override func spec() {
        describe("inIndexPaths()") {
            it("maps ints to NSIndexPaths") {
                let indexPaths = toIndexPaths(Array(0...2))
                for i in 0...2 {
                    expect(indexPaths[i].row).to(equal(i))
                }
            }

            it("uses 0 as the default section") {
                let indexPaths = toIndexPaths([0])
                expect(indexPaths[0].section).to(equal(0))
            }

            it("uses the specified section") {
                let indexPaths = toIndexPaths([0], section: 1)
                expect(indexPaths[0].section).to(equal(1))
            }
        }
    }
}
