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
            var distilleries: Set<Distillery>!
            var repository: DistilleryRepository!
            var scheduler: TestScheduler!

            beforeEach {
                repository = InMemoryDistilleryRepository()
                repository.distilleries
                    |> start { distilleries = $0 }

                scheduler = TestScheduler()

                controller = storyboard.instantiateViewControllerWithIdentifier("NewDistilleryController") as! NewDistilleryController
                controller.repository = repository
                controller.scheduler = scheduler

                controller.loadView()
                controller.viewDidLoad()
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
                it("enables save when the id, latitude, longitude, name, and region are valid") {
                    let save = controller.save

                    expect(save.enabled).toNot(beTruthy())
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
                    scheduler.advance()
                    expect(save.enabled).to(beTruthy())
                }

                it("disables save when the distillery is invalid") {
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

                it("saves distiler when pressed") {
                    controller.saveAndDismiss()
                    expect(distilleries.count).to(equal(1))
                }
            }
        }
    }
}
