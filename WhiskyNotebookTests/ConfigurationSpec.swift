// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import WhiskyNotebook


final class ConfigurationSpec: QuickSpec {
    override func spec() {
        describe("Configuration") {
            it("initializes all properties to values") {
                let configuration = Configuration(name: "test-name")
                expect(configuration.name).to(equal("test-name"))
                expect(configuration.level).notTo(beNil())
                expect(configuration.format).notTo(beNil())
            }
            
            it("bases equality on name") {
                expect(Configuration(name: "test-name")).to(equal(Configuration(name: "test-name")))
                expect(Configuration(name: "test-name")).notTo(equal(Configuration(name: "another-test-name")))
            }
            
            it("bases hash value on name") {
                let name = "test-name"
                expect(Configuration(name: name).hashValue).to(equal(name.hashValue))
            }
        }
    }
}