// Copyright 2014-2015 Ben Hale. All Rights Reserved


import Nimble
import Quick

final class DramRepositoryManagerSpec: QuickSpec {
    override func spec() {
        describe("DramRepositoryManager") {
            it("returns CloudKitDramRepository shared instance") {
                expect(DramRepositoryManager.sharedInstance is CloudKitDramRepository).to(beTruthy())
            }
        }
    }
}
