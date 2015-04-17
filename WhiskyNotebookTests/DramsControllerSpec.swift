// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import ReactiveCocoa
import UIKit
import WhiskyNotebook


final class DramsControllerSpec: QuickSpec {
    override func spec() {
        let storyboard = UIStoryboard(name: "WhiskyNotebook", bundle: nil)

        describe("DramsController") {
            var controller: DramsController!
            var navigationController: UINavigationController!
            var repository: DramRepository!
            var scheduler: TestScheduler!

            beforeEach {
                repository = InMemoryDramRepository()
                scheduler = TestScheduler()

                controller = storyboard.instantiateViewControllerWithIdentifier("DramsController") as! DramsController

                navigationController = UINavigationController()
                navigationController.pushViewController(controller, animated: false)

                let datasource = controller.dataSource
                datasource.repository = repository
                datasource.scheduler = scheduler

                controller.loadView()
                controller.viewDidLoad()
            }

            describe("Interface Update") {
                it("removes add button when editing") {
                    expect(controller.navigationItem.rightBarButtonItem).toNot(beNil())
                    controller.setEditing(true, animated: false)
                    expect(controller.navigationItem.rightBarButtonItem).to(beNil())
                }

                it("sets the toolbar to visible when editing") {
                    expect(controller.navigationController?.toolbarHidden).to(beTruthy())
                    controller.setEditing(true, animated: false)
                    expect(controller.navigationController?.toolbarHidden).to(beFalsy())
                }
            }

            describe("Model Update") {
                it("updates the rows in the table when the model is updated") {
                    expect(controller.tableView.numberOfRowsInSection(0)).to(equal(0))
                    repository.save(Dram())
                    scheduler.advance()
                    expect(controller.tableView.numberOfRowsInSection(0)).to(equal(1))
                }
            }
        }
    }
}