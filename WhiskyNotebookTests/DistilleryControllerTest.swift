// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import ReactiveCocoa
import UIKit
@testable
import WhiskyNotebook
import XCTest


final class DistilleryControllerTests: XCTestCase {

    private var distilleryController: DistilleryDetailsController!

    private let storyboard = UIStoryboard(name: "Distillery", bundle: nil)

    // MARK: - Setup

    override func setUp() {
        self.distilleryController = self.storyboard.instantiateViewControllerWithIdentifier("DistilleryDetailsController") as! DistilleryDetailsController
    }

    // MARK: Tests

    func test_ConfiguresWithDistillery() {
        self.distilleryController.configureWithDistillery(IMDistillery(id: "test-id", location: nil, name: "test-name", region: .Campbeltown))
    }
}
