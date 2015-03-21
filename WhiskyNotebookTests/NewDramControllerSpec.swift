// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import ReactiveCocoa
import UIKit
import WhiskyNotebook

class NewDramControllerSpec: QuickSpec {
    override func spec() {
        let storyboard = UIStoryboard(name: "WhiskyNotebook", bundle: nil)

        describe("NewDramController") {
            var controller: NewDramController!
            var repository: DramRepository!
            var scheduler: TestScheduler!

            beforeEach {
                repository = InMemoryDramRepository()
                scheduler = TestScheduler()

                controller = storyboard.instantiateViewControllerWithIdentifier("NewDramController") as! NewDramController
                controller.repository = repository
                controller.scheduler = scheduler

                controller.loadView()
                controller.viewDidLoad()
            }

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

            it("saves the Dram") {
                controller.performSave()
                expect(repository.drams.value).to(beEmpty())
                scheduler.advance()
                expect(repository.drams.value).notTo(beEmpty())
            }
        }
    }
}
