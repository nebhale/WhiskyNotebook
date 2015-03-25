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
            }

            it("initializes all properties to values") {
                let dram = Dram(id: "test-id")
                expect(dram.id).to(equal("test-id"))
            }

            it("bases equality on id") {
                expect(Dram(id: "test-id")).to(equal(Dram(id: "test-id")))
                expect(Dram(id: "test-id")).notTo(equal(Dram(id: "anoter-test-id")))
            }

            it("bases hash value on id") {
                let id = "test-id"
                expect(Dram(id: id).hashValue).to(equal(id.hashValue))
                expect(Dram().hashValue).to(equal(0))
            }

            it("validates id") {
                expect(Dram().valid()).to(beFalse())
                expect(Dram(id: "").valid()).to(beFalse())
                expect(Dram(id: "test-id").valid()).to(beFalse())
                expect(Dram(id: "1.").valid()).to(beFalse())
                expect(Dram(id: ".1").valid()).to(beFalse())
                expect(Dram(id: "1234.1").valid()).to(beFalse())
                expect(Dram(id: "1.1234").valid()).to(beFalse())
                expect(Dram(id: "1.2").valid()).to(beTrue())
                expect(Dram(id: "12.34").valid()).to(beTrue())
                expect(Dram(id: "123.456").valid()).to(beTrue())
            }
        }
    }
}
