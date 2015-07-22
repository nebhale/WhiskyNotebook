// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import ReactiveCocoa
import UIKit
@testable
import WhiskyNotebook
import XCTest


final class DistilleryDataSourceTests: XCTestCase {

    private var distilleryRepository: StubDistilleryRepository!

    private var distilleryDataSource: DistilleryDataSource!

    private let storyboard = UIStoryboard(name: "Distillery", bundle: nil)

    private var tableView: UITableView!

    // MARK: - Setup

    override func setUp() {
        self.distilleryRepository = StubDistilleryRepository()
        self.distilleryDataSource = DistilleryDataSource(distilleryRepository: self.distilleryRepository)

        let distilleriesController = self.storyboard.instantiateViewControllerWithIdentifier("DistilleryListController") as! DistilleryListController
        self.tableView = distilleriesController.tableView
    }

    // MARK: Tests

    func test_NumberOfRowsInSectionMatchesNumberOfDistilleries() {
        expect(self.distilleryDataSource.tableView(self.tableView, numberOfRowsInSection: 0)).to(equal(0))

        self.distilleryRepository._distilleries.value = [IMDistillery()]
        expect(self.distilleryDataSource.tableView(self.tableView, numberOfRowsInSection: 0)).to(equal(1))
    }

    func test_ConfiguresDistilleryCellWithDistillery() {
        self.distilleryRepository._distilleries.value = [IMDistillery(id: "test-id", location: nil, name: "test-name", region: .Campbeltown)]

        expect(self.distilleryDataSource.tableView(self.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))).to(beAnInstanceOf(DistilleryCell))
    }
}

// MARK: - Stubs

private final class StubDistilleryRepository: DistilleryRepository {

    let _distilleries: MutableProperty<[Distillery]>

    let distilleries: PropertyOf<[Distillery]>

    init() {
        self._distilleries = MutableProperty([])
        self.distilleries = PropertyOf(self._distilleries)
    }
}