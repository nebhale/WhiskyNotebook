// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import WhiskyNotebook


final class PlistConfigurationProviderSpec: QuickSpec {
    override func spec() {
        let bundle = NSBundle(forClass: self.dynamicType)

        it("returns root if file does not exist") {
            let configurationProvider = PlistConfigurationProvider(file: "NonExistent", bundle: bundle)
            expect(configurationProvider.configuration("Test").name).to(equal("ROOT"))
        }

        it("returns root if named configuration is not specified") {
            let configurationProvider = PlistConfigurationProvider(file: "RootOnly", bundle: bundle)
            expect(configurationProvider.configuration("Test").name).to(equal("ROOT"))
        }

        it("returns named configuration if specified") {
            let configurationProvider = PlistConfigurationProvider(file: "Named", bundle: bundle)
            expect(configurationProvider.configuration("Test").name).to(equal("Test"))
        }

        it("sets level if specified") {
            let configurationProvider = PlistConfigurationProvider(file: "LevelSet", bundle: bundle)
            expect(configurationProvider.configuration("Test").level).to(equal(Level.Error))
        }

        it("sets format if specified") {
            let configurationProvider = PlistConfigurationProvider(file: "FormatSet", bundle: bundle)
            expect(configurationProvider.configuration("Test").format).to(equal("test-format"))
        }
    }
}