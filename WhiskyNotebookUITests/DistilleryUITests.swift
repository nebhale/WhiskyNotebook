// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import XCTest


final class DistilleryUITests: XCTestCase {

    var app: XCUIApplication!

    // MARK: - Setup

    override func setUp() {
        self.continueAfterFailure = false

        self.app = XCUIApplication()
        self.app.launchEnvironment["PROFILE"] = "test"
        self.app.launch()

        self.app.tabBars.buttons["Distilleries"].tap()
    }

    // MARK: Tests

    func test_DistilleryList() {
        expect(self.app.navigationBars["Distilleries"].exists).to(beTrue())
        expect(self.app.tables.cells.count).to(equal(9))

        let cells = self.app.tables.cells
        expect(cells.staticTexts["1"].exists).to(beTrue())
        expect(cells.staticTexts["Glenfarclas"].exists).to(beTrue())
        expect(cells.staticTexts["Speyside"].exists).to(beTrue())
    }

    func test_DistilleryDetails() {
        self.app.tables.cells.staticTexts["1"].tap()

        expect(self.app.navigationBars["Details"].exists).to(beTrue())

        expect(self.app.maps.elementBoundByIndex(0).exists).to(beTrue())
        expect(self.app.staticTexts["1"].exists).to(beTrue())
        expect(self.app.staticTexts["Glenfarclas"].exists).to(beTrue())
        expect(self.app.staticTexts["Speyside"].exists).to(beTrue())
    }
}