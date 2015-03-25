// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import WhiskyNotebook


final class LevelSpec: QuickSpec {
    override func spec() {
        describe("Level") {
            it("parses from String") {
                expect(Level.fromString("debug")).to(equal(Level.Debug))
                expect(Level.fromString("DEBUG")).to(equal(Level.Debug))
                expect(Level.fromString("Debug")).to(equal(Level.Debug))
                
                expect(Level.fromString("info")).to(equal(Level.Info))
                expect(Level.fromString("INFO")).to(equal(Level.Info))
                expect(Level.fromString("Info")).to(equal(Level.Info))
                
                expect(Level.fromString("warn")).to(equal(Level.Warn))
                expect(Level.fromString("WARN")).to(equal(Level.Warn))
                expect(Level.fromString("Warn")).to(equal(Level.Warn))
                
                expect(Level.fromString("error")).to(equal(Level.Error))
                expect(Level.fromString("ERROR")).to(equal(Level.Error))
                expect(Level.fromString("Error")).to(equal(Level.Error))
            }
            
            it("serializes to String") {
                expect(Level.Debug.toString()).to(equal("Debug"))
                expect(Level.Info.toString()).to(equal("Info"))
                expect(Level.Warn.toString()).to(equal("Warn"))
                expect(Level.Error.toString()).to(equal("Error"))
            }
            
            it("parses to .Debug for an unknown String") {
                expect(Level.fromString("test-value")).to(equal(Level.Debug))
            }
        }
    }
}