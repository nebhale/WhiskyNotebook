// Copyright 2014-2015 Ben Hale. All Rights Reserved


import Foundation
import LoggerLogger
import ReactiveCocoa

final class InMemoryDistilleryRepository: DistilleryRepository {

    private let content: MutableProperty<Set<Distillery>> = MutableProperty([])

    let distilleries: SignalProducer<Set<Distillery>, NoError>

    private let logger = Logger()

    init() {
        self.distilleries = self.content.producer
    }

    func delete(distillery: Distillery) {
        self.logger.info("Deleting Distillery: \(distillery)")
        self.content.value - distillery
    }

    func save(distillery: Distillery) {
        self.logger.info("Saving Distillery: \(distillery)")
        self.content.value + distillery
    }
}
