// Copyright 2014-2015 Ben Hale. All Rights Reserved


import ReactiveCocoa

final class InMemoryDramRepository: DramRepository {

    let drams: PropertyOf<Set<Dram>>

    private let delegate: InMemoryRepository<Dram>

    init() {
        self.delegate = InMemoryRepository()
        self.drams = self.delegate.items
    }

    func delete(dram: Dram) {
        self.delegate.delete(dram)
    }

    func save(dram: Dram) {
        self.delegate.save(dram)
    }
}