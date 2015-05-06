// Copyright 2014-2015 Ben Hale. All Rights Reserved


import Foundation
import LoggerLogger
import ReactiveCocoa

final class InMemoryRepository<T: Hashable> {

    let items: PropertyOf<Set<T>>

    private let _items: MutableProperty<Set<T>>

    private let logger = Logger()

    init() {
        self._items = MutableProperty(Set())
        self.items = PropertyOf(self._items)
    }

    func delete(item: T) {
        self.logger.info("Deleting item: \(item)")
        self._items.value.remove(item)
        self.logger.debug("Deleted item: \(item)")
    }

    func save(item: T) {
        self.logger.info("Saving item: \(item)")
        self._items.value.insert(item)
        self.logger.debug("Saved item: \(item)")
    }
}
