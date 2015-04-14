// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import ReactiveCocoa
import UIKit
import WhiskyNotebook


final class DramCellSpec: QuickSpec {
    override func spec() {
        describe("DramCell") {
            var cell: DramCell!
            var date: UILabel!
            var id: UILabel!
            var rating: UISegmentedControl!
            var repository: DramRepository!

            beforeEach {
                date = UILabel()
                id = UILabel()
                rating = UISegmentedControl(items: ["1", "2", "3"])
                repository = InMemoryDramRepository()

                cell = DramCell()
                cell.date = date
                cell.id = id
                cell.rating = rating
                cell.repository = repository
            }

            describe("Interface Update") {
                it("configures id when nil") {
                    expect(id.text).toEventually(beNil())
                    cell.configure(Dram(id: nil, date: nil, rating: nil))
                    expect(id.text).toEventually(beNil())
                }

                it("configures id when not nil") {
                    expect(id.text).toEventually(beNil())
                    cell.configure(Dram(id: "test-id", date: nil, rating: nil))
                    expect(id.text).toEventually(equal("test-id"))
                }

                it("configures date when nil") {
                    expect(date.text).toEventuallyNot(beNil())
                    cell.configure(Dram(id: nil, date: nil, rating: nil))
                    expect(date.text).toEventually(beNil())
                }

                it("configures date when not nil") {
                    expect(date.text).toEventuallyNot(beNil())
                    cell.configure(Dram(id: nil, date: NSDate(), rating: nil))
                    expect(date.text).toEventuallyNot(beNil())
                }

                it("enables rating when nil") {
                    cell.rating.enabled = false
                    expect(cell.rating.enabled).toEventually(beFalse())
                    cell.configure(Dram(id: nil, date: nil, rating: nil))
                    expect(cell.rating.enabled).toEventually(beTrue())
                }

                it("disables rating when not nil") {
                    cell.rating.enabled = true
                    expect(cell.rating.enabled).toEventually(beTrue())
                    cell.configure(Dram(id: nil, date: nil, rating: Rating.Neutral))
                    expect(cell.rating.enabled).toEventually(beFalse())
                }

                it("configures rating when not nil") {
                    let rating = Rating.Neutral
                    expect(cell.rating.selectedSegmentIndex).toEventually(equal(UISegmentedControlNoSegment))
                    cell.configure(Dram(id: nil, date: nil, rating: rating))
                    expect(cell.rating.selectedSegmentIndex).toEventually(equal(rating.rawValue))
                }
            }

            describe("Save") {
                it("saves the dram") {
                    var drams = Set<Dram>()
                    repository.drams |> start(next: { drams = $0 })

                    cell.configure(Dram(id: nil, date: nil, rating: nil))
                    rating.selectedSegmentIndex = 1
                    rating.sendActionsForControlEvents(.ValueChanged)
                    expect(drams).toEventuallyNot(beEmpty())
                }
            }
        }
    }
}