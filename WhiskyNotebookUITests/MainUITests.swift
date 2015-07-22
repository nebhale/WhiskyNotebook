// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import XCTest


final class MainUITests: XCTestCase {

    var app: XCUIApplication!

    // MARK: - Setup

    override func setUp() {
        self.continueAfterFailure = false

        self.app = XCUIApplication()
        self.app.launchEnvironment["PROFILE"] = "test"
        self.app.launch()
    }

    // MARK: Tests

    func test_TabBarHasTwoTabs() {
        let buttons = self.app.tabBars.buttons

        expect(buttons.count).to(equal(2))
        expect(buttons.elementBoundByIndex(0).label).to(equal("Drams"))
        expect(buttons.elementBoundByIndex(1).label).to(equal("Distilleries"))
    }
}