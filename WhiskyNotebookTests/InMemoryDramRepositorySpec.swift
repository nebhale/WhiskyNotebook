// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import ReactiveCocoa
import WhiskyNotebook


final class InMemoryDramRepositorySpec: QuickSpec {

    override func spec() {
        describe("InMemoryDramRepository") {
            var repository: InMemoryDramRepository!

            beforeEach {
                repository = InMemoryDramRepository()
            }

            it("deletes dram") {
                let dram = Dram()
                repository.save(dram)
                expect(repository.drams.value.count).to(equal(1))
                repository.delete(dram)
                expect(repository.drams.value.count).to(equal(0))
            }

            it("saves dram") {
                expect(repository.drams.value.count).to(equal(0))
                repository.save(Dram())
                expect(repository.drams.value.count).to(equal(1))
            }

            it("signals changes to drams") {
                let dram = Dram()
                let sentValue = MutableProperty<[Dram]>([])
                sentValue <~ repository.drams.producer

                repository.save(dram)

                expect(sentValue.value).to(contain(dram))
            }
        }
    }
}