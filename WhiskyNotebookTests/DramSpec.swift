// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import WhiskyNotebook


final class DramSpec: QuickSpec {
    override func spec() {
        describe("Dram") {
            it("initializes all properties except date to nil") {
                let dram = Dram()
                expect(dram.id).to(beNil())
                expect(dram.date).toNot(beNil())
            }

            it("initializes all properties to values") {
                let id = "test-id"
                let date = NSDate()
                let dram = Dram(id: id, date: date)
                expect(dram.id).to(equal(id))
                expect(dram.date).to(equal(date))
            }

            it("bases equality on id") {
                expect(Dram(id: "test-id", date: NSDate())).to(equal(Dram(id: "test-id", date: NSDate())))
                expect(Dram(id: "test-id", date: NSDate())).toNot(equal(Dram(id: "anoter-test-id", date: NSDate())))
            }

            it("bases hash value on id") {
                let id = "test-id"
                expect(Dram(id: id, date: NSDate()).hashValue).to(equal(id.hashValue))
                expect(Dram().hashValue).to(equal(0))
            }

            it("validates id") {
                expect(Dram().valid()).to(beFalse())
                expect(Dram(id: "", date: NSDate()).valid()).to(beFalse())
                expect(Dram(id: "test-id", date: NSDate()).valid()).to(beFalse())
                expect(Dram(id: "1.", date: NSDate()).valid()).to(beFalse())
                expect(Dram(id: ".1", date: NSDate()).valid()).to(beFalse())
                expect(Dram(id: "1234.1", date: NSDate()).valid()).to(beFalse())
                expect(Dram(id: "1.1234", date: NSDate()).valid()).to(beFalse())
                expect(Dram(id: "1.2", date: NSDate()).valid()).to(beTrue())
                expect(Dram(id: "12.34", date: NSDate()).valid()).to(beTrue())
                expect(Dram(id: "123.456", date: NSDate()).valid()).to(beTrue())
            }

            it("validates date") {
                let now = NSDate()
                let past = now.dateByAddingTimeInterval(-1000)
                let future = now.dateByAddingTimeInterval(1000)


                expect(Dram(id: "1.2", date: now).valid()).to(beTrue())
                expect(Dram(id: "1.2", date: past).valid()).to(beTrue())
                expect(Dram(id: "1.2", date: future).valid()).to(beFalse())
            }
        }
    }
}
