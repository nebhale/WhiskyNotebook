// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation
import ReactiveCocoa


public final class InMemoryDramRepository: DramRepository {

    public let currentDrams: MutableProperty<Set<Dram>> = MutableProperty([])

    private let currentDramsMap: MutableProperty<[String : Dram]> = MutableProperty([:])

    private let logger = Logger()

    public init() {
        self.currentDrams <~ self.currentDramsMap.producer
            |> map { Set($0.values) }
    }

    public func delete(dram: Dram) {
        self.logger.info("Deleting Dram: \(dram)")
        self.currentDramsMap.value[dram.id] = nil
    }

    public func save(dram: Dram) {
        self.logger.info("Saving Dram: \(dram)")
        self.currentDramsMap.value[dram.id] = dram
    }
}
