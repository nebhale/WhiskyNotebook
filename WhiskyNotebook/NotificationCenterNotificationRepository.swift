// Copyright 2014-2015 Ben Hale.  All Rights Reserved.

import Foundation
import LoggerLogger
import ReactiveCocoa


final class NotificationCenterNotificationRepository: NotificationRepository {

    private let logger = Logger()

    private let notificationCenter: NSNotificationCenter

    let notifications: Signal<NSNotification, NoError>

    private let sink: Event<NSNotification, NoError> -> ()

    // MARK: -

    init(notificationCenter: NSNotificationCenter) {
        self.notificationCenter = notificationCenter
        (self.notifications, self.sink) = Signal<NSNotification, NoError>.pipe()

        self.notifications
            .observe { self.logger.debug("Notification received: \($0.name)") }

        self.notificationCenter.addObserver(self, selector: "handle:", name: nil, object: nil)
    }

    deinit {
        self.notificationCenter.removeObserver(self)
    }

    // MARK: -

    @objc
    private func handle(notification: NSNotification) {
        sendNext(self.sink, notification)
    }
}