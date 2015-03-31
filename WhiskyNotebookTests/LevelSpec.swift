// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import WhiskyNotebook


final class LevelSpec: QuickSpec {
    override func spec() {
        describe("Level") {
            it("parses from String") {
                expect(Level("debug")).to(equal(Level.Debug))
                expect(Level("DEBUG")).to(equal(Level.Debug))
                expect(Level("Debug")).to(equal(Level.Debug))
                
                expect(Level("info")).to(equal(Level.Info))
                expect(Level("INFO")).to(equal(Level.Info))
                expect(Level("Info")).to(equal(Level.Info))
                
                expect(Level("warn")).to(equal(Level.Warn))
                expect(Level("WARN")).to(equal(Level.Warn))
                expect(Level("Warn")).to(equal(Level.Warn))
                
                expect(Level("error")).to(equal(Level.Error))
                expect(Level("ERROR")).to(equal(Level.Error))
                expect(Level("Error")).to(equal(Level.Error))
            }
            
            it("serializes to String") {
                expect(Level.Debug.toString()).to(equal("Debug"))
                expect(Level.Info.toString()).to(equal("Info"))
                expect(Level.Warn.toString()).to(equal("Warn"))
                expect(Level.Error.toString()).to(equal("Error"))
            }
            
            it("parses to .Debug for an unknown String") {
                expect(Level("test-value")).to(equal(Level.Debug))
            }
        }
    }
}