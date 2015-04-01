// Copyright 2014-2015 Ben Hale. All Rights Reserved

import ReactiveCocoa


public final class InMemoryDramRepository: DramRepository {

    public var drams = MutableProperty<[Dram]>([])

    private let logger = Logger()

    public init() {}

    public func delete(dram: Dram) {
        self.logger.info("Deleting Dram: \(dram)")
        self.drams.value.remove(dram)
    }

    public func save(dram: Dram) {
        self.logger.info("Saving Dram: \(dram)")
        if let index = self.drams.value.indexOf(dram) {
            self.drams.value[index] = dram
        } else {
            self.drams.value.append(dram)
        }
    }
}
