// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import ReactiveCocoa
import UIKit
import WhiskyNotebook


final class NewDistilleryControllerSpec: QuickSpec {
    override func spec() {
        let storyboard = UIStoryboard(name: "WhiskyNotebook", bundle: nil)

        describe("NewDistilleryController") {
            var controller: NewDistilleryController!
            var repository: DistilleryRepository!
            var distilleries: Set<Distillery>!

            beforeEach {
                repository = InMemoryDistilleryRepository()
                repository.distilleries
                    |> start { distilleries = $0 }

                controller = storyboard.instantiateViewControllerWithIdentifier("NewDistilleryController") as! NewDistilleryController
                controller.repository = repository

                controller.loadView()
                controller.viewDidLoad()
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
                it("enables save when the id, latitude, longitude, name, and region are valid") {
                    let save = controller.save

                    expect(save.enabled).toEventuallyNot(beTrue())
                    controller.id.text = "0"
                    controller.id.sendActionsForControlEvents(.EditingChanged)
                    controller.latitude.text = "0"
                    controller.latitude.sendActionsForControlEvents(.EditingChanged)
                    controller.longitude.text = "0"
                    controller.longitude.sendActionsForControlEvents(.EditingChanged)
                    controller.name.text = "test-name"
                    controller.name.sendActionsForControlEvents(.EditingChanged)
                    controller.region.text = "Campbeltown"
                    controller.region.sendActionsForControlEvents(.EditingChanged)
                    expect(save.enabled).toEventually(beTrue())
                }

                it("disables save when the distillery is invalid") {
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

                it("saves distiler when pressed") {
                    controller.saveAndDismiss()
                    expect(distilleries.count).toEventually(equal(1))
                }
            }
        }
    }
}
