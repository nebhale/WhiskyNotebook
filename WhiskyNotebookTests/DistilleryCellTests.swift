// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import UIKit
@testable
import WhiskyNotebook
import XCTest


final class DistilleryCellTests: XCTestCase {

    private var cell: DistilleryCell!

    // MARK: - Setup

    override func setUp() {
        self.cell = DistilleryCell()
        self.cell.id = UILabel()
        self.cell.name = UILabel()
        self.cell.region = UILabel()
    }

    // MARK: Tests

    func test_ConfiguresDistilleryCellWithDistillery() {
        self.cell.configureWithDistillery(IMDistillery(id: "test-id", location: nil, name: "test-name", region: .Campbeltown))

        expect(self.cell.id.text).to(equal("test-id"))
        expect(self.cell.name.text).to(equal("test-name"))
        expect(self.cell.region.text).to(equal(Region.Campbeltown.rawValue))
    }
}
