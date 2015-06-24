// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import ReactiveCocoa
@testable
import WhiskyNotebook
import XCTest


final class NotificationCenterNotificationRepositoryTests: XCTestCase {

    private var notificationCenter: NSNotificationCenter!

    private var notificationRepository: NotificationCenterNotificationRepository!

    // MARK: - Setup

    override func setUp() {
        self.notificationCenter = NSNotificationCenter()
        self.notificationRepository = NotificationCenterNotificationRepository(notificationCenter: self.notificationCenter)
    }

    // MARK: Tests

    func test_NotificationsAreForwarded() {
        var notification: NSNotification?
        self.notificationRepository.notifications
            .filter { $0.name == "TestNotification" }
            .observe { notification = $0 }

        self.notificationCenter.postNotificationName("TestNotification", object: [:])

        expect(notification).toEventually(beTruthy())
    }
}
