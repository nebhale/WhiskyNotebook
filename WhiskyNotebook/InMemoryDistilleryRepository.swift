// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation
import ReactiveCocoa


public final class InMemoryDistilleryRepository: DistilleryRepository {

    private let content: MutableProperty<Set<Distillery>> = MutableProperty([])

    public let distilleries: SignalProducer<Set<Distillery>, NoError>

    private let logger = Logger()

    public init() {
        self.distilleries = self.content.producer
    }

    public func delete(distillery: Distillery) {
        self.logger.info("Deleting Distillery: \(distillery)")
        self.content.value - distillery
    }

    public func save(distillery: Distillery) {
        self.logger.info("Saving Distillery: \(distillery)")
        self.content.value + distillery
    }
}
