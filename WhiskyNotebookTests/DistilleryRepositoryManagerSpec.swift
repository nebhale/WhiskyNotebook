// Copyright 2014-2015 Ben Hale. All Rights Reserved


import Nimble
import Quick

final class DistilleryRepositoryManagerSpec: QuickSpec {
    override func spec() {
        describe("DistilleryRepositoryManager") {
            it("returns InMemoryDistilleryRepository shared instance") {
                expect(DistilleryRepositoryManager.sharedInstance is CloudKitDistilleryRepository).to(beTruthy())
            }
        }
    }
}
