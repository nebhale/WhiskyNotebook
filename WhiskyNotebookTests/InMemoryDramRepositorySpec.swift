// Copyright 2014-2015 Ben Hale. All Rights Reserved


import Nimble
import Quick
import ReactiveCocoa

final class InMemoryDramRepositorySpec: QuickSpec {

    override func spec() {
        describe("InMemoryDramRepository") {
            var repository: InMemoryDramRepository!
            var drams: Set<Dram>!

            beforeEach {
                repository = InMemoryDramRepository()
                repository.drams
                    |> start { drams = $0 }
            }

            it("deletes dram") {
                let dram = Dram()
                repository.save(dram)
                expect(drams.count).to(equal(1))
                repository.delete(dram)
                expect(drams.count).to(equal(0))
            }

            it("saves dram") {
                expect(drams.count).to(equal(0))
                repository.save(Dram())
                expect(drams.count).to(equal(1))
            }

            it("replaces existing dram") {
                let dram = Dram()
                expect(drams.count).to(equal(0))
                repository.save(dram)
                expect(drams.count).to(equal(1))
                repository.save(dram)
                expect(drams.count).to(equal(1))
            }

            it("signals changes to drams") {
                let dram = Dram()
                repository.save(dram)
                expect(drams).to(contain(dram))
            }
        }
    }
}
