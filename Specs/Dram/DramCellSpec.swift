// Copyright 2014-2015 Ben Hale. All Rights Reserved


import Nimble
import Quick
import UIKit

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
            }

            describe("Interface Update") {
                it("configures id when nil") {
                    expect(id.text).to(beNil())
                    cell.configure(Dram(id: nil, date: nil, rating: nil))
                    expect(id.text).to(beNil())
                }

                it("configures id when not nil") {
                    expect(id.text).to(beNil())
                    cell.configure(Dram(id: "test-id", date: nil, rating: nil))
                    expect(id.text).to(equal("test-id"))
                }

                it("configures date when nil") {
                    expect(date.text).to(beNil())
                    cell.configure(Dram(id: nil, date: nil, rating: nil))
                    expect(date.text).to(beNil())
                }

                it("configures date when not nil") {
                    expect(date.text).to(beNil())
                    cell.configure(Dram(id: nil, date: NSDate(), rating: nil))
                    expect(date.text).toNot(beNil())
                }

                it("configures rating when nil") {
                    expect(cell.rating.selectedSegmentIndex).to(equal(UISegmentedControlNoSegment))
                    cell.configure(Dram(id: nil, date: nil, rating: nil))
                    expect(cell.rating.selectedSegmentIndex).to(equal(UISegmentedControlNoSegment))
                }

                it("configures rating when not nil") {
                    let rating = Rating.Neutral
                    expect(cell.rating.selectedSegmentIndex).to(equal(UISegmentedControlNoSegment))
                    cell.configure(Dram(id: nil, date: nil, rating: rating))
                    expect(cell.rating.selectedSegmentIndex).to(equal(rating.rawValue))
                }
            }
        }
    }
}
