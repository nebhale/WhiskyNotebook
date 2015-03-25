// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import WhiskyNotebook


final class ConfigurationProviderManagerSpec: QuickSpec {
    override func spec() {
        describe("ConfigurationProviderManager") {
            it("returns PlistConfigurationProvider default instance") {
                expect(ConfigurationProviderManager.defaultInstance is PlistConfigurationProvider).to(beTrue())
            }
        }
    }
}