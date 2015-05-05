// Copyright 2014-2015 Ben Hale. All Rights Reserved


import Foundation
import LoggerLogger
import ReactiveCocoa

final class InMemoryDramRepository: DramRepository {

    private let content: MutableProperty<Set<Dram>> = MutableProperty([])

    let drams: SignalProducer<Set<Dram>, NoError>

    private let logger = Logger()

    init() {
        self.drams = self.content.producer
    }

    func delete(dram: Dram) {
        self.logger.info("Deleting: \(dram)")
        self.content.value - dram
    }

    func save(dram: Dram) {
        self.logger.info("Saving: \(dram)")
        self.content.value + dram
    }
}
