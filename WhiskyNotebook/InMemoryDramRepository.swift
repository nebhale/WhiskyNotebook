// Copyright 2014-2015 Ben Hale. All Rights Reserved

import ReactiveCocoa


public final class InMemoryDramRepository: DramRepository {

    public var drams = MutableProperty<[Dram]>([])

    public init() {}

    public func save(dram: Dram) {
        self.drams.value.append(dram)
    }
}
