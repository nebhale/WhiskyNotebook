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

            beforeEach {
                repository = InMemoryDramRepository()

                controller = storyboard.instantiateViewControllerWithIdentifier("NewDramController") as! NewDramController
                controller.repository = repository

                controller.loadView()
                controller.viewDidLoad()
            }

            describe("Cancel") {
                var command: RACCommand!
                var button: UIBarButtonItem!

                beforeEach {
                    button = controller.cancel
                    command = button.rac_command
                }

                it("dismisses view when pressed") {
                    command.execute(button)
                    expect(repository.drams.value).to(beEmpty())
                }
            }

            describe("Dram Update") {
                it("updates dram with id text") {
                    expect(controller.id.text).to(beEmpty())
                    controller.id.text = "1.2"
                    controller.id.sendActionsForControlEvents(.EditingChanged)
                    expect(controller.id.text).to(equal("1.2"))
                }
            }

            describe("Interface Update") {
                it("enables save button when an identifier has text") {
                    expect(controller.save.enabled).to(beFalse())
                    controller.id.text = "1.2"
                    controller.id.sendActionsForControlEvents(.EditingChanged)
                    expect(controller.save.enabled).to(beTrue())
                }

                it("disables save button when an identifier does not have text") {
                    controller.save.enabled = true
                    expect(controller.save.enabled).to(beTrue())
                    controller.id.text = ""
                    controller.id.sendActionsForControlEvents(.EditingChanged)
                    expect(controller.save.enabled).to(beFalse())
                }
            }

            describe("Save") {
                var command: RACCommand!
                var button: UIBarButtonItem!
                var action: Action<AnyObject?, AnyObject?, NSError>!

                beforeEach {
                    button = controller.save
                    command = button.rac_command
                    action = command.toAction()
                }

                it("saves the Dram") {
                    expect(repository.drams.value).to(beEmpty())
                    command.execute(button)
                    expect(repository.drams.value).toEventuallyNot(beEmpty())
                }
            }
        }
    }
}
