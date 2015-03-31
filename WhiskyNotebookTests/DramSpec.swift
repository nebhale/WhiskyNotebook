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
                expect(dram.date).to(beNil())
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

            it("bases equality on id") {
                expect(Dram(id: "test-id", date: nil, rating: nil)).to(equal(Dram(id: "test-id", date: nil, rating: nil)))
                expect(Dram(id: "test-id", date: nil, rating: nil)).toNot(equal(Dram(id: "anoter-test-id", date: nil, rating: nil)))
            }

            it("bases hash value on id") {
                let id = "test-id"
                expect(Dram(id: id, date: nil, rating: nil).hashValue).to(equal(id.hashValue))
                expect(Dram().hashValue).to(equal(0))
            }
        }
    }
}
