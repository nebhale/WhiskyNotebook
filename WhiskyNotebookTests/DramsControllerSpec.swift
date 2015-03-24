// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import ReactiveCocoa
import UIKit
import WhiskyNotebook


class DramsControllerSpec: QuickSpec {
    override func spec() {
        let storyboard = UIStoryboard(name: "WhiskyNotebook", bundle: nil)

        describe("DramsController") {
            var controller: DramsController!
            var repository: DramRepository!
            var scheduler: TestScheduler!

            beforeEach {
                repository = InMemoryDramRepository()
                scheduler = TestScheduler()

                controller = storyboard.instantiateViewControllerWithIdentifier("DramsController") as! DramsController
                controller.repository = repository
                controller.scheduler = scheduler

                controller.loadView()
                controller.viewDidLoad()
            }

            describe("UITableViewDataSource") {
                it("specifies 1 section in table view") {
                    expect(controller.numberOfSectionsInTableView(controller.tableView)).to(equal(1))
                }

                it("specifies the number of drams as the number of rows in section") {
                    expect(controller.tableView(controller.tableView, numberOfRowsInSection: 0)).to(equal(0))
                    repository.save(Dram())
                    scheduler.advance()
                    expect(controller.tableView(controller.tableView, numberOfRowsInSection: 0)).to(equal(1))
                }

                it("provides a properly configured cell") {
                    var dram = Dram(id: "test")

                    repository.save(dram)
                    scheduler.advance()

                    let cell = controller.tableView(controller.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
                    expect(cell.textLabel?.text).to(equal("test"))
                }

            }
        }

        describe("Dram") {
            it("configured UITableViewCell") {
                let cell = UITableViewCell()
                Dram(id: "test-id").configure(cell)

                expect(cell.textLabel?.text).to(equal("test-id"))
            }
        }
    }
}