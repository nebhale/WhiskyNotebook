// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import ReactiveCocoa
import WhiskyNotebook

class InMemoryDramRepositorySpec: QuickSpec {

    override func spec() {
        describe("InMemoryDramRepository") {
            var repository: InMemoryDramRepository!

            beforeEach {
                repository = InMemoryDramRepository()
            }

            pending("saves dram") {
                expect(repository.drams.value.count).to(equal(0))
                repository.save(Dram())
                expect(repository.drams.value.count).to(equal(1))
            }

            pending("signals changes to drams") {
                let dram = Dram()
                var sentValue: [Dram]?

                repository.drams.producer.start(next: { sentValue = $0 }) // TODO: Inline once segfault is fixed
                repository.save(dram)

                expect(sentValue).to(contain(dram))
            }
        }
    }
}