// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation
import ReactiveCocoa


public final class InMemoryDramRepository: DramRepository {

    private let content: MutableProperty<Set<Dram>> = MutableProperty([])

    public let drams: SignalProducer<Set<Dram>, NoError>

    private let logger = Logger()

    public init() {
        self.drams = self.content.producer
    }

    public func delete(dram: Dram) {
        self.logger.info("Deleting Dram: \(dram)")
        self.content.value - dram
    }

    public func save(dram: Dram) {
        self.logger.info("Saving Dram: \(dram)")
        self.content.value + dram
    }
}
