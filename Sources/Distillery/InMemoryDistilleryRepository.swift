// Copyright 2014-2015 Ben Hale. All Rights Reserved


import ReactiveCocoa

final class InMemoryDistilleryRepository: DistilleryRepository {

    let distilleries: PropertyOf<Set<Distillery>>

    private let delegate: InMemoryRepository<Distillery>

    init() {
        self.delegate = InMemoryRepository()
        self.distilleries = self.delegate.items
    }

    func delete(distillery: Distillery) {
        self.delegate.delete(distillery)
    }

    func save(distillery: Distillery) {
        self.delegate.save(distillery)
    }
}