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
            var rating: UISegmentedControl!

            beforeEach {
                date = UILabel()
                id = UILabel()
                rating = UISegmentedControl(items: ["1", "2", "3"])

                cell = DramCell()
                cell.date = date
                cell.id = id
                cell.rating = rating

                cell.layoutSubviews()
            }

            it("configures id when nil") {
                expect(id.text).toEventually(beNil())
                cell.dram.value = Dram(id: nil, date: nil, rating: nil)
                expect(id.text).toEventually(beNil())
            }

            it("configured id when not nil") {
                expect(id.text).toEventually(beNil())
                cell.dram.value = Dram(id: "test-id", date: nil, rating: nil)
                expect(id.text).toEventually(equal("test-id"))
            }

            it("configures date when nil") {
                expect(date.text).toEventually(beNil())
                cell.dram.value = Dram(id: nil, date: nil, rating: nil)
                expect(date.text).toEventually(beNil())
            }

            it("configures date when not nil") {
                expect(date.text).toEventually(beNil())
                cell.dram.value = Dram(id: nil, date: NSDate(), rating: nil)
                expect(date.text).toEventuallyNot(beNil())
            }

            it("enables rating when nil") {
                cell.rating.enabled = false
                expect(cell.rating.enabled).toEventually(beFalse())
                cell.dram.value = Dram(id: nil, date: nil, rating: nil)
                expect(cell.rating.enabled).toEventually(beTrue())
            }

            it("disables rating when not nil") {
                cell.rating.enabled = true
                expect(cell.rating.enabled).toEventually(beTrue())
                cell.dram.value = Dram(id: nil, date: nil, rating: Rating.Neutral)
                expect(cell.rating.enabled).toEventually(beFalse())
            }
            
            it("configures rating when not nil") {
                let rating = Rating.Neutral
                expect(cell.rating.selectedSegmentIndex).toEventually(equal(UISegmentedControlNoSegment))
                cell.dram.value = Dram(id: nil, date: nil, rating: rating)
                expect(cell.rating.selectedSegmentIndex).toEventually(equal(rating.rawValue))
            }
        }
    }
}