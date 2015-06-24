// Copyright 2014-2015 Ben Hale. All Rights Reserved

import CacheCache
import Nimble
import ReactiveCocoa
@testable
import WhiskyNotebook
import XCTest


final class IMDistilleryRepositoryTests: XCTestCase {

    private var cache: InMemoryCache<[IMDistillery]>!

    private var distilleryRepository: IMDistilleryRepository!

    // MARK: - Setup

    override func setUp() {
        self.cache = InMemoryCache(type: [IMDistillery].self)
        self.distilleryRepository = IMDistilleryRepository(cache: self.cache)
    }

    // MARK: Tests

    func test_InitializedWithDefaultCollection() {
        var distilleries: [Distillery]?
        self.distilleryRepository.distilleries.producer
            .start { distilleries = $0 }

        expect(distilleries?.count).toEventually(equal(9))
    }
}