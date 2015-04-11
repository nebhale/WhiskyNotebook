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
            var identifier: UILabel!
            var rating: UISegmentedControl!
            var repository: DramRepository!

            beforeEach {
                date = UILabel()
                identifier = UILabel()
                rating = UISegmentedControl(items: ["1", "2", "3"])
                repository = InMemoryDramRepository()

                cell = DramCell()
                cell.date = date
                cell.identifier = identifier
                cell.rating = rating
                cell.repository = repository

                cell.layoutSubviews()
            }

            describe("Interface Update") {
                it("configures identifier when nil") {
                    expect(identifier.text).toEventually(beNil())
                    cell.currentDram.value = Dram(identifier: nil, date: nil, rating: nil)
                    expect(identifier.text).toEventually(beNil())
                }

                it("configures identifier when not nil") {
                    expect(identifier.text).toEventually(beNil())
                    cell.currentDram.value = Dram(identifier: "test-id", date: nil, rating: nil)
                    expect(identifier.text).toEventually(equal("test-id"))
                }

                it("configures date when nil") {
                    expect(date.text).toEventuallyNot(beNil())
                    cell.currentDram.value = Dram(identifier: nil, date: nil, rating: nil)
                    expect(date.text).toEventually(beNil())
                }

                it("configures date when not nil") {
                    expect(date.text).toEventuallyNot(beNil())
                    cell.currentDram.value = Dram(identifier: nil, date: NSDate(), rating: nil)
                    expect(date.text).toEventuallyNot(beNil())
                }

                it("enables rating when nil") {
                    cell.rating.enabled = false
                    expect(cell.rating.enabled).toEventually(beFalse())
                    cell.currentDram.value = Dram(identifier: nil, date: nil, rating: nil)
                    expect(cell.rating.enabled).toEventually(beTrue())
                }

                it("disables rating when not nil") {
                    cell.rating.enabled = true
                    expect(cell.rating.enabled).toEventually(beTrue())
                    cell.currentDram.value = Dram(identifier: nil, date: nil, rating: Rating.Neutral)
                    expect(cell.rating.enabled).toEventually(beFalse())
                }

                it("configures rating when not nil") {
                    let rating = Rating.Neutral
                    expect(cell.rating.selectedSegmentIndex).toEventually(equal(UISegmentedControlNoSegment))
                    cell.currentDram.value = Dram(identifier: nil, date: nil, rating: rating)
                    expect(cell.rating.selectedSegmentIndex).toEventually(equal(rating.rawValue))
                }
            }

            describe("Save") {
                it("saves the dram") {
                    expect(repository.currentDrams.value).to(beEmpty())
                    rating.selectedSegmentIndex = 1
                    rating.sendActionsForControlEvents(.ValueChanged)
                    expect(repository.currentDrams.value).toEventuallyNot(beEmpty())
                }
            }
        }
    }
}