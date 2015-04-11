// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import ReactiveCocoa
import UIKit
import WhiskyNotebook


final class DramsDataSourceSpec: QuickSpec {
    override func spec() {
        let storyboard = UIStoryboard(name: "WhiskyNotebook", bundle: nil)
        
        describe("DramsDataSource") {
            var dataSource: DramsDataSource!
            var repository: DramRepository!
            var tableView: UITableView!

            beforeEach {
                let controller = storyboard.instantiateViewControllerWithIdentifier("DramsController") as! DramsController

                repository = InMemoryDramRepository()

                dataSource = controller.dataSource
                dataSource.repository = repository
                dataSource.viewDidLoad()

                tableView = controller.tableView
                tableView.dataSource = dataSource
            }

            describe("Display Drams") {
                it("specifies 1 section in table view") {
                    expect(dataSource.numberOfSectionsInTableView(tableView)).to(equal(1))
                }

                it("provides a DramCell") {
                    var dram = Dram(identifier: "test", date: NSDate(), rating: nil)
                    repository.save(dram)

                    let cell = dataSource.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
                    expect(cell).to(beAnInstanceOf(DramCell))
                }

                it("specifies the number of drams as the number of rows in section") {
                    expect(dataSource.tableView(tableView, numberOfRowsInSection: 0)).to(equal(0))
                    repository.save(Dram())
                    expect(dataSource.tableView(tableView, numberOfRowsInSection: 0)).to(equal(1))
                }

                it("sorts the drams in reverse chronological order") {
                    let now = NSDate()
                    let past = now.dateByAddingTimeInterval(-86400)
                    let future = now.dateByAddingTimeInterval(86400)

                    let dram1 = Dram(identifier: "now", date: now, rating: nil)
                    let dram2 = Dram(identifier: "past", date: past, rating: nil)
                    let dram3 = Dram(identifier: "future", date: future, rating: nil)

                    repository.save(dram1)
                    repository.save(dram2)
                    repository.save(dram3)

                    let cell1 = dataSource.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! DramCell
                    let cell2 = dataSource.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0)) as! DramCell
                    let cell3 = dataSource.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 2, inSection: 0)) as! DramCell

                    expect(cell1.currentDram.value).to(equal(dram3))
                    expect(cell2.currentDram.value).to(equal(dram1))
                    expect(cell3.currentDram.value).to(equal(dram2))
                }
            }

            describe("Edit Drams") {
                it("specifes that all cells can be edited") {
                    expect(dataSource.tableView(tableView, canEditRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))).to(beTrue())
                }

                it("deletes dram") {
                    repository.save(Dram())
                    expect(repository.currentDrams.value.count).toEventually(equal(1))
                    dataSource.tableView(tableView, commitEditingStyle: .Delete, forRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
                    expect(repository.currentDrams.value.count).toEventually(equal(0))
                }

                it("specifies editing style depending on table editing mode") {
                    expect(dataSource.tableView(tableView, editingStyleForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))).to(equal(UITableViewCellEditingStyle.None))
                    tableView.setEditing(true, animated: false)
                    expect(dataSource.tableView(tableView, editingStyleForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))).to(equal(UITableViewCellEditingStyle.Delete))
                }
            }
        }
    }
}