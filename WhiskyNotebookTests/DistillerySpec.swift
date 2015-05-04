// Copyright 2014-2015 Ben Hale. All Rights Reserved


import CoreLocation
import Nimble
import Quick

final class DistillerySpec: QuickSpec {
    override func spec() {
        describe("Distillery") {
            it("initializes all properties to nil") {
                let distillery = Distillery()
                expect(distillery.id).to(beNil())
                expect(distillery.location).to(beNil())
                expect(distillery.name).to(beNil())
                expect(distillery.region).to(beNil())
            }

            it("initializes all properties to values") {
                let id = "test-id"
                let location = CLLocation(latitude: 0, longitude: 0)
                let name = "test-name"
                let region = Region.Campbeltown
                let distillery = Distillery(id: id, location: location, name: name, region: region)
                expect(distillery.id).to(equal(id))
                expect(distillery.location).to(equal(location))
                expect(distillery.name).to(equal(name))
                expect(distillery.region).to(equal(region))
            }

            it("bases equality on synthetic key") {
                let distillery1 = Distillery(id: "test-id", location: nil, name: nil, region: nil)
                let distillery2 = Distillery(id: "test-id", location: nil, name: nil, region: nil)
                var distillery3 = distillery1
                distillery3.id = "another-test-id"

                expect(distillery1).toNot(equal(distillery2))
                expect(distillery1).to(equal(distillery3))
            }

            it("bases hash value on id") {
                let distillery1 = Distillery(id: "test-id", location: nil, name: nil, region: nil)
                var distillery2 = distillery1
                distillery2.id = "another-test-id"

                expect(distillery1.hashValue).to(equal(distillery2.hashValue))
            }
        }
    }
}
