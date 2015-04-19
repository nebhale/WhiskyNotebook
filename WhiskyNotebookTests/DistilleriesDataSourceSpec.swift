// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import ReactiveCocoa
import UIKit
import WhiskyNotebook


final class DistilleriesDataSourceSpec: QuickSpec {
    override func spec() {
        let storyboard = UIStoryboard(name: "WhiskyNotebook", bundle: nil)

        describe("DistilleriesDataSource") {
            var dataSource: DistilleriesDataSource!
            var repository: DistilleryRepository!
            var scheduler: TestScheduler!
            var tableView: UITableView!

            beforeEach {
                scheduler = TestScheduler()

                let controller = storyboard.instantiateViewControllerWithIdentifier("DistilleriesController") as! DistilleriesController
                controller.scheduler = scheduler

                repository = InMemoryDistilleryRepository()

                dataSource = controller.dataSource
                dataSource.repository = repository
                dataSource.schedulerAsync = scheduler
                dataSource.schedulerSync = scheduler
                dataSource.viewDidLoad()

                tableView = controller.tableView
                tableView.dataSource = dataSource
            }

            describe("Display Distilleries") {
                it("specifies 1 section in table view") {
                    expect(dataSource.numberOfSectionsInTableView(tableView)).to(equal(1))
                }

                it("provides a DistilleryCell") {
                    var distillery = Distillery()
                    repository.save(distillery)
                    scheduler.advance()

                    let cell = dataSource.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
                    expect(cell).to(beAnInstanceOf(DistilleryCell))
                }

                it("specifies the number of distilleries as the number of rows in section") {
                    expect(dataSource.tableView(tableView, numberOfRowsInSection: 0)).to(equal(0))
                    repository.save(Distillery())
                    scheduler.advance()
                    expect(dataSource.tableView(tableView, numberOfRowsInSection: 0)).to(equal(1))
                }

                it("sorts the distilleries by region then id") {
                    let now = NSDate()
                    let past = now.dateByAddingTimeInterval(-86400)
                    let future = now.dateByAddingTimeInterval(86400)

                    let distillery1 = Distillery(id: "G1", location: nil, name: nil, region: .Grain)
                    let distillery2 = Distillery(id: "2", location: nil, name: nil, region: .Campbeltown)
                    let distillery3 = Distillery(id: "1", location: nil, name: nil, region: .Wales)

                    repository.save(distillery1)
                    repository.save(distillery2)
                    repository.save(distillery3)

                    scheduler.advance()

                    let cell1 = dataSource.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! DistilleryCell
                    let cell2 = dataSource.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0)) as! DistilleryCell
                    let cell3 = dataSource.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 2, inSection: 0)) as! DistilleryCell

                    expect(cell1.id.text).to(equal("1"))
                    expect(cell2.id.text).to(equal("2"))
                    expect(cell3.id.text).to(equal("G1"))
                }
            }

            describe("Edit Distilleries") {
                it("specifes that all cells can be edited") {
                    expect(dataSource.tableView(tableView, canEditRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))).to(beTruthy())
                }

                it("deletes distillery") {
                    var distilleries = Set<Distillery>()
                    repository.distilleries
                        |> start { distilleries = $0 }

                    repository.save(Distillery())
                    scheduler.advance()

                    expect(distilleries.count).to(equal(1))
                    dataSource.tableView(tableView, commitEditingStyle: .Delete, forRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
                    scheduler.advance()
                    expect(distilleries.count).to(equal(0))
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