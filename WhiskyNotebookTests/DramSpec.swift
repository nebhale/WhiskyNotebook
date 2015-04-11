// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import WhiskyNotebook


final class DramSpec: QuickSpec {
    override func spec() {
        describe("Dram") {
            it("initializes all properties to nil") {
                let dram = Dram()
                expect(dram.id).to(beNil())
                expect(dram.date).toNot(beNil())
                expect(dram.rating).to(beNil())
            }

            it("initializes all properties to values") {
                let id = "test-id"
                let date = NSDate()
                let rating = Rating.Positive
                let dram = Dram(id: id, date: date, rating: rating)
                expect(dram.id).to(equal(id))
                expect(dram.date).to(equal(date))
                expect(dram.rating).to(equal(rating))
            }

            it("bases equality on synthetic key") {
                let dram1 = Dram(id: "test-id", date: nil, rating: nil)
                let dram2 = Dram(id: "test-id", date: nil, rating: nil)
                var dram3 = dram1
                dram3.id = "another-test-id"

                expect(dram1).toNot(equal(dram2))
                expect(dram1).to(equal(dram3))
            }

            it("bases hash value on id") {
                let dram1 = Dram(id: "test-id", date: nil, rating: nil)
                var dram2 = dram1
                dram2.id = "another-test-id"

                expect(dram1.hashValue).to(equal(dram2.hashValue))
            }
        }
    }
}
