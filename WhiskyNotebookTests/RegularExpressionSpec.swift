// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import WhiskyNotebook

class RegExSpec: QuickSpec {
    override func spec() {
        describe("=~") {
            it("returns true for a match") {
                expect("a" =~ "[a]").to(beTrue())
            }

            it("returns false for a non-match") {
                expect("a" =~ "[b]").to(beFalse())
            }
        }
    }
}