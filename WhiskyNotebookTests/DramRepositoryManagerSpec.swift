// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import WhiskyNotebook

class DramRepositoryManagerSpec: QuickSpec {
    override func spec() {
        describe("DramRepositoryManager") {
            it("initializes all properties to values") {
                let dram = Dram(id: "test-id")
                expect(dram.id).to(equal("test-id"))
            }

            it("returns InMemoryDramRepository shared instance") {
                expect(DramRepositoryManager.sharedInstance is InMemoryDramRepository).to(beTrue())
            }
        }
    }
}