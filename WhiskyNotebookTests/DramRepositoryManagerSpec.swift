// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import WhiskyNotebook


final class DramRepositoryManagerSpec: QuickSpec {
    override func spec() {
        describe("DramRepositoryManager") {
            it("returns InMemoryDramRepository shared instance") {
                expect(DramRepositoryManager.sharedInstance is CloudKitDramRepository).to(beTrue())
            }
        }
    }
}