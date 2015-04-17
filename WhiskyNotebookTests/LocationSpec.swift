// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import WhiskyNotebook


final class LocationSpec: QuickSpec {
    override func spec() {
        describe("Location") {
            it("returns a location with valid inputs") {
                expect(locationFrom("0", "0")).toNot(beNil())
            }

            it("returns null with invalid latitude") {
                expect(locationFrom("t", "0")).to(beNil())
            }

            it("returns null with longitude latitude") {
                expect(locationFrom("0", "t")).to(beNil())
            }
        }
    }
}