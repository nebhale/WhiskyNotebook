// Copyright 2014-2015 Ben Hale. All Rights Reserved

import CoreLocation
import Nimble
@testable
import WhiskyNotebook
import XCTest


final class IMDistilleryTests: XCTestCase {

    // MARK: - Tests

    func test_InitializesAllPropertiesToNil() {
        let distillery = IMDistillery()

        expect(distillery.id).to(beNil())
        expect(distillery.location).to(beNil())
        expect(distillery.name).to(beNil())
        expect(distillery.region).to(beNil())
    }

    func test_InitializesAllPropertiesToValues() {
        let id = "test-id"
        let location = CLLocation(latitude: 0, longitude: 0)
        let name = "test-name"
        let region = Region.Campbeltown

        let distillery = IMDistillery(id: id, location: location, name: name, region: region)

        expect(distillery.id).to(equal(id))
        expect(distillery.location).to(equal(location))
        expect(distillery.name).to(equal(name))
        expect(distillery.region).to(equal(region))
    }

    func test_ComparisonBasedOnIdAndRegion() {
        let distillery0 = IMDistillery(id: "1", location: nil, name: nil, region: .Campbeltown)
        let distillery1 = IMDistillery(id: "100", location: nil, name: nil, region: .Campbeltown)
        let distillery2 = IMDistillery(id: "G10", location: nil, name: nil, region: .Grain)

        expect(distillery0).to(beLessThan(distillery1))
        expect(distillery1).to(beLessThan(distillery2))
    }

    func test_EqualityBasedOnId() {
        let distillery0 = IMDistillery(id: "1", location: CLLocation(latitude: 0, longitude: 0), name: "test-name", region: .Campbeltown)
        let distillery1 = IMDistillery(id: "1", location: CLLocation(latitude: 1, longitude: 1), name: "another-test-name", region: .Grain)
        let distillery2 = IMDistillery(id: "2", location: CLLocation(latitude: 0, longitude: 0), name: "test-name", region: .Campbeltown)

        expect(distillery0).to(equal(distillery1))
        expect(distillery0).toNot(equal(distillery2))
    }
}