// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import ReactiveCocoa
import UIKit
import WhiskyNotebook


final class NewDramControllerSpec: QuickSpec {
    override func spec() {
        let storyboard = UIStoryboard(name: "WhiskyNotebook", bundle: nil)

        describe("NewDramController") {
            var controller: NewDramController!
            var repository: DramRepository!
            var drams: Set<Dram>!

            beforeEach {
                repository = InMemoryDramRepository()
                repository.drams |> start(next: { drams = $0 })

                controller = storyboard.instantiateViewControllerWithIdentifier("NewDramController") as! NewDramController
                controller.repository = repository

                controller.loadView()
                controller.viewDidLoad()
            }

            it("sets maxium date to today") {
                let maximumDate = controller.date.maximumDate
                let today = NSDate()
                expect(maximumDate).to(equalToDay(today))
            }

            describe("Done") {
                var command: RACCommand!
                var button: UIBarButtonItem!

                beforeEach {
                    button = controller.done
                    command = button.rac_command
                }

                it("dismisses view when pressed") {
                    command.execute(button)
                    expect(drams).toEventually(beEmpty())
                }
            }

            describe("Dram Update") {
                it("updates dram with id text") {
                    expect(controller.id.text).to(beEmpty())
                    controller.id.text = "1.2"
                    controller.id.sendActionsForControlEvents(.EditingChanged)
                    expect(controller.id.text).to(equal("1.2"))
                }

                it("updates dram with date value") {
                    let today = NSDate()
                    let yesterday = today.dateByAddingTimeInterval(-86400)
                    expect(controller.date.date).to(equalToDay(today))
                    controller.date.date = yesterday
                    controller.date.sendActionsForControlEvents(.ValueChanged)
                    expect(controller.date.date).to(equalToDay(yesterday))
                }

                it("updates dram with rating value") {
                    let rating = Rating.Neutral
                    expect(controller.rating.selectedSegmentIndex).to(equal(UISegmentedControlNoSegment))
                    controller.rating.selectedSegmentIndex = rating.rawValue
                    controller.rating.sendActionsForControlEvents(.ValueChanged)
                    expect(controller.rating.selectedSegmentIndex).to(equal(rating.rawValue))
                }
            }

            describe("Save") {
                it("saves the dram when drams is valid") {
                    controller.id.text = "1.2"
                    controller.id.sendActionsForControlEvents(.EditingChanged)
                    expect(drams).toEventuallyNot(beEmpty())
                }

                it("does not save the dram when dram is invalid") {
                    controller.id.text = ""
                    controller.id.sendActionsForControlEvents(.EditingChanged)
                    expect(drams).toEventually(beEmpty())
                }

                it("validates Dram id") {
                    expect(Dram().validId()).to(beFalse())
                    expect(Dram(id: "", date: nil, rating: nil).validId()).to(beFalse())
                    expect(Dram(id: "test-id", date: nil, rating: nil).validId()).to(beFalse())
                    expect(Dram(id: "1.", date: nil, rating: nil).validId()).to(beFalse())
                    expect(Dram(id: ".1", date: nil, rating: nil).validId()).to(beFalse())
                    expect(Dram(id: "1234.1", date: nil, rating: nil).validId()).to(beFalse())
                    expect(Dram(id: "1.1234", date: nil, rating: nil).validId()).to(beFalse())
                    expect(Dram(id: "1.2", date: nil, rating: nil).validId()).to(beTrue())
                    expect(Dram(id: "12.34", date: nil, rating: nil).validId()).to(beTrue())
                    expect(Dram(id: "123.456", date: nil, rating: nil).validId()).to(beTrue())
                }

                it("validates Dram date") {
                    let now = NSDate()
                    let past = now.dateByAddingTimeInterval(-86400)
                    let future = now.dateByAddingTimeInterval(86400)

                    expect(Dram(id: nil, date: now, rating: nil).validDate()).to(beTrue())
                    expect(Dram(id: nil, date: past, rating: nil).validDate()).to(beTrue())
                    expect(Dram(id: nil, date: future, rating: nil).validDate()).to(beFalse())
                    expect(Dram(id: nil, date: nil, rating: nil).validDate()).to(beFalse())
                }
            }
        }
    }
}
