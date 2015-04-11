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
            var repository: DramRepository!
            var tableView: UITableView!

            beforeEach {
                repository = InMemoryDramRepository()
                tableView = UITableView()

                controller = storyboard.instantiateViewControllerWithIdentifier("DramsController") as! DramsController
                controller.repository = repository

                controller.loadView()
                controller.viewDidLoad()
            }

            describe("Display Drams") {
                it("specifies 1 section in table view") {
                    expect(controller.numberOfSectionsInTableView(controller.tableView)).to(equal(1))
                }

                it("provides a DramCell") {
                    var dram = Dram(identifier: "test", date: NSDate(), rating: nil)
                    repository.save(dram)

                    let cell = controller.tableView(controller.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
                    expect(cell).to(beAnInstanceOf(DramCell))
                }

                it("specifies the number of drams as the number of rows in section") {
                    expect(controller.tableView(controller.tableView, numberOfRowsInSection: 0)).to(equal(0))
                    repository.save(Dram())
                    expect(controller.tableView(controller.tableView, numberOfRowsInSection: 0)).to(equal(1))
                }

                it("sorts the drams in reverse chronological order") {
                    let now = NSDate()
                    let past = now.dateByAddingTimeInterval(-86400)
                    let future = now.dateByAddingTimeInterval(86400)

                    let dram1 = Dram(identifier: nil, date: now, rating: nil)
                    let dram2 = Dram(identifier: nil, date: past, rating: nil)
                    let dram3 = Dram(identifier: nil, date: future, rating: nil)

                    repository.save(dram1)
                    repository.save(dram2)
                    repository.save(dram3)

                    let cell1 = controller.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! DramCell
                    let cell2 = controller.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0)) as! DramCell
                    let cell3 = controller.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 2, inSection: 0)) as! DramCell

                    expect(cell1.currentDram.value).to(equal(dram3))
                    expect(cell2.currentDram.value).to(equal(dram1))
                    expect(cell3.currentDram.value).to(equal(dram2))
                }
            }

            describe("Edit Drams") {
                it("specifes that all cells can be edited") {
                    expect(controller.tableView(tableView, canEditRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))).to(beTrue())
                }

                it("deletes dram") {
                    repository.save(Dram())
                    expect(repository.currentDrams.value.count).to(equal(1))
                    controller.tableView(tableView, commitEditingStyle: .Delete, forRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
                    expect(repository.currentDrams.value.count).toEventually(equal(0))
                }

                it("specifies editing style depending on table editing mode") {
                    expect(controller.tableView(tableView, editingStyleForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))).to(equal(UITableViewCellEditingStyle.None))
                    tableView.setEditing(true, animated: false)
                    expect(controller.tableView(tableView, editingStyleForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))).to(equal(UITableViewCellEditingStyle.Delete))
                }
            }

            describe("Interface Update") {
                it("removes add button when editing") {
                    expect(controller.navigationItem.rightBarButtonItem).toNot(beNil())
                    controller.setEditing(true, animated: false)
                    expect(controller.navigationItem.rightBarButtonItem).to(beNil())
                }
            }

            describe("Model Update") {
                it("updates the rows in the table when the model is update") {
                    expect(controller.tableView.numberOfRowsInSection(0)).to(equal(0))
                    repository.save(Dram())
                    expect(controller.tableView.numberOfRowsInSection(0)).toEventually(equal(1))
                }
            }
        }
    }
}