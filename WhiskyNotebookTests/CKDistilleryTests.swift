// Copyright 2014-2015 Ben Hale. All Rights Reserved

import CloudKit
import CoreLocation
import Nimble
@testable
import WhiskyNotebook
import XCTest


final class CKDistilleryTests: XCTestCase {

    // MARK: - Tests

    func test_InitializesAllPropertiesToNil() {
        let distillery = CKDistillery()

        expect(distillery.id).to(beNil())
        expect(distillery.location).to(beNil())
        expect(distillery.name).to(beNil())
        expect(distillery.region).to(beNil())
    }

    func test_InitializesAllPropertiesToCKRecordValues() {
        let record = CKRecord(recordType: CKDistillery.recordType)
        record["Id"] = "test-id"
        record["Location"] = CLLocation(latitude: 0, longitude: 0)
        record["Name"] = "test-name"
        record["Region"] = Region.Campbeltown.rawValue

        let distillery = CKDistillery(record: record)

        expect(distillery.id).to(equal(record["Id"] as? String))
        expect(distillery.location).to(equal(record["Location"] as? CLLocation))
        expect(distillery.name).to(equal(record["Name"] as? String))
        expect(distillery.region?.rawValue).to(equal(record["Region"] as? String))
    }

    func test_PropertiesSetOnRecord() {
        let id = "test-id"
        let location = CLLocation(latitude: 0, longitude: 0)
        let name = "test-name"
        let region = Region.Campbeltown

        var distillery = CKDistillery()
        distillery.id = id
        distillery.location = location
        distillery.name = name
        distillery.region = region

        expect(distillery.record["Id"] as? String).to(equal(id))
        expect(distillery.record["Location"] as? CLLocation).to(equal(location))
        expect(distillery.record["Name"] as? String).to(equal(name))
        expect(distillery.record["Region"] as? String).to(equal(region.rawValue))
    }

    func test_ComparisonBasedOnIdAndRegion() {
        let distillery0 = CKDistillery(id: "1", location: nil, name: nil, region: .Campbeltown)
        let distillery1 = CKDistillery(id: "100", location: nil, name: nil, region: .Campbeltown)
        let distillery2 = CKDistillery(id: "G10", location: nil, name: nil, region: .Grain)

        expect(distillery0).to(beLessThan(distillery1))
        expect(distillery1).to(beLessThan(distillery2))
    }

    func test_EqualityBasedOnRecord() {
        let record0 = CKRecord(recordType: CKDistillery.recordType)
        let record1 = CKRecord(recordType: CKDistillery.recordType)

        expect(CKDistillery(record: record0)).to(equal(CKDistillery(record: record0)))
        expect(CKDistillery(record: record0)).toNot(equal(CKDistillery(record: record1)))
    }
}