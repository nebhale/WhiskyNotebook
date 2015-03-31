// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import UIKit
import WhiskyNotebook


final class DramCellSpec: QuickSpec {
    override func spec() {
        describe("DramCell") {
            var cell: DramCell!
            var date: UILabel!
            var id: UILabel!

            beforeEach {
                date = UILabel()
                id = UILabel()

                cell = DramCell()
                cell.date = date
                cell.id = id
            }

            it("configures id when nil") {
                expect(id.text).to(beNil())
                cell.configure(Dram(id: nil, date: nil))
                expect(id.text).to(beNil())
            }

            it("configured id when not nil") {
                expect(id.text).to(beNil())
                cell.configure(Dram(id: "test-id", date: nil))
                expect(id.text).to(equal("test-id"))
            }

            it("configures date when nil") {
                expect(date.text).to(beNil())
                cell.configure(Dram(id: nil, date: nil))
                expect(date.text).to(beNil())
            }

            it("configures date when not nil") {
                expect(date.text).to(beNil())
                cell.configure(Dram(id: nil, date: NSDate()))
                expect(date.text).toNot(beNil())
            }
        }
    }
}