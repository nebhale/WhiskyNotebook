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
                repository.drams
                    |> start { drams = $0 }

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

            describe("Cancel") {
                it("dismisses view when pressed") {
                    var dismissed = false
                    controller.rac_signalForSelector(Selector("dismissViewControllerAnimated:completion:")).toSignalProducer()
                        |> start { _ in dismissed = true }

                    controller.cancelAndDismiss()
                    expect(dismissed).toEventually(beTrue())
                }
            }

            describe("Save") {
                it("enables save when the id is valid") {
                    let save = controller.save

                    expect(save.enabled).toEventuallyNot(beTrue())
                    controller.id.text = "1.2"
                    controller.id.sendActionsForControlEvents(.EditingChanged)
                    expect(save.enabled).toEventually(beTrue())
                }

                it("disables save when the dram is invalid") {
                    let save = controller.save
                    save.enabled = true

                    expect(save.enabled).toEventually(beTrue())
                    controller.id.text = "invalid"
                    controller.id.sendActionsForControlEvents(.EditingChanged)
                    expect(save.enabled).toEventuallyNot(beTrue())
                }

                it("dismisses view when pressed") {
                    var dismissed = false
                    controller.rac_signalForSelector(Selector("dismissViewControllerAnimated:completion:")).toSignalProducer()
                        |> start{ _ in dismissed = true }

                    controller.saveAndDismiss()
                    expect(dismissed).toEventually(beTrue())
                }

                it("saves dram when pressed") {
                    controller.saveAndDismiss()
                    expect(drams.count).toEventually(equal(1))
                }
            }
        }
    }
}
