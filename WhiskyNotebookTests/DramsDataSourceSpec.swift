// Copyright 2014-2015 Ben Hale. All Rights Reserved


import Nimble
import Quick
import ReactiveCocoa
import UIKit

final class DramsDataSourceSpec: QuickSpec {
    override func spec() {
        let storyboard = UIStoryboard(name: "WhiskyNotebook", bundle: nil)

        describe("DramsDataSource") {
            var dataSource: DramsDataSource!
            var repository: DramRepository!
            var scheduler: TestScheduler!
            var tableView: UITableView!

            beforeEach {
                scheduler = TestScheduler()

                let controller = storyboard.instantiateViewControllerWithIdentifier("DramsController") as! DramsController
                controller.scheduler = scheduler

                repository = InMemoryDramRepository()

                dataSource = controller.dataSource
                dataSource.repository = repository
                dataSource.schedulerAsync = scheduler
                dataSource.schedulerSync = scheduler
                dataSource.viewDidLoad()

                tableView = controller.tableView
                tableView.dataSource = dataSource
            }

            describe("Display Drams") {
                it("specifies 1 section in table view") {
                    expect(dataSource.numberOfSectionsInTableView(tableView)).to(equal(1))
                }

                it("provides a DramCell") {
                    var dram = Dram()
                    repository.save(dram)
                    scheduler.advance()

                    let cell = dataSource.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
                    expect(cell).to(beAnInstanceOf(DramCell))
                }

                it("specifies the number of drams as the number of rows in section") {
                    expect(dataSource.tableView(tableView, numberOfRowsInSection: 0)).to(equal(0))
                    repository.save(Dram())
                    scheduler.advance()
                    expect(dataSource.tableView(tableView, numberOfRowsInSection: 0)).to(equal(1))
                }

                it("sorts the drams in reverse chronological order") {
                    let now = NSDate()
                    let past = now.dateByAddingTimeInterval(-86400)
                    let future = now.dateByAddingTimeInterval(86400)

                    let dram1 = Dram(id: "now", date: now, rating: nil)
                    let dram2 = Dram(id: "past", date: past, rating: nil)
                    let dram3 = Dram(id: "future", date: future, rating: nil)

                    repository.save(dram1)
                    repository.save(dram2)
                    repository.save(dram3)

                    scheduler.advance()

                    let cell1 = dataSource.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! DramCell
                    let cell2 = dataSource.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0)) as! DramCell
                    let cell3 = dataSource.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 2, inSection: 0)) as! DramCell

                    expect(cell1.id.text).to(equal("future"))
                    expect(cell2.id.text).to(equal("now"))
                    expect(cell3.id.text).to(equal("past"))
                }
            }

            describe("Edit Drams") {
                it("specifes that all cells can be edited") {
                    expect(dataSource.tableView(tableView, canEditRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))).to(beTruthy())
                }

                it("deletes dram") {
                    var drams = Set<Dram>()
                    repository.drams
                        |> start { drams = $0 }

                    repository.save(Dram())
                    scheduler.advance()

                    expect(drams.count).to(equal(1))
                    dataSource.tableView(tableView, commitEditingStyle: .Delete, forRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
                    scheduler.advance()
                    expect(drams.count).to(equal(0))
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
