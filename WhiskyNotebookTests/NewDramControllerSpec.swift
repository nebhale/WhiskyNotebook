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
            var drams: Set<Dram>!
            var repository: DramRepository!
            var scheduler: TestScheduler!

            beforeEach {
                repository = InMemoryDramRepository()
                repository.drams
                    |> start { drams = $0 }

                scheduler = TestScheduler()

                controller = storyboard.instantiateViewControllerWithIdentifier("NewDramController") as! NewDramController
                controller.repository = repository
                controller.scheduler = scheduler

                controller.loadView()
                controller.viewDidLoad()
            }

            it("sets maxium date to today") {
                let maximumDate = controller.date.maximumDate
                let today = NSDate()
                expect(maximumDate).to(equalToDay(today))
            }

            describe("Cancel") {
                it("dismisses view when pressed") {
                    var dismissed = false
                    controller.rac_signalForSelector(Selector("dismissViewControllerAnimated:completion:")).toSignalProducer()
                        |> start { _ in dismissed = true }

                    controller.cancelAndDismiss()
                    expect(dismissed).to(beTruthy())
                }
            }

            describe("Save") {
                it("enables save when the id is valid") {
                    let save = controller.save

                    expect(save.enabled).toNot(beTruthy())
                    controller.id.text = "1.2"
                    controller.id.sendActionsForControlEvents(.EditingChanged)
                    scheduler.advance()
                    expect(save.enabled).to(beTruthy())
                }

                it("disables save when the dram is invalid") {
                    let save = controller.save
                    save.enabled = true

                    expect(save.enabled).to(beTruthy())
                    controller.id.text = "invalid"
                    controller.id.sendActionsForControlEvents(.EditingChanged)
                    scheduler.advance()
                    expect(save.enabled).toNot(beTruthy())
                }

                it("dismisses view when pressed") {
                    var dismissed = false
                    controller.rac_signalForSelector(Selector("dismissViewControllerAnimated:completion:")).toSignalProducer()
                        |> start{ _ in dismissed = true }

                    controller.saveAndDismiss()
                    expect(dismissed).to(beTruthy())
                }

                it("saves dram when pressed") {
                    controller.saveAndDismiss()
                    expect(drams.count).to(equal(1))
                }
            }
        }
    }
}
