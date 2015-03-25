// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import WhiskyNotebook


final class RegExSpec: QuickSpec {
    override func spec() {
        describe("=~") {
            it("sets matched to true for a match") {
                expect("a" =~ "^[a]$").to(beTruthy())
                expect(("a" =~ "^[a]$").matched).to(beTrue())
            }

            it("returns false for a non-match") {
                expect("a" =~ "^[b]$").to(beFalsy())
                expect(("a" =~ "^[b]$").matched).to(beFalse())
            }

            it("returns false if string is nil") {
                let s: String? = nil
                expect(s =~ "^[a]$").to(beFalsy())
                expect((s =~ "^[a]$").matched).to(beFalse())
            }

            it("returns empty array if there are no capture groups") {
                expect(("a" =~ "^[a]$").captures).to(beEmpty())
            }

            it("returns array of contents if there are capture groups") {
                expect(("ab" =~ "^([a])[b]$").captures).to(contain("a"))
            }
        }
    }
}