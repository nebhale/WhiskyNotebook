// Copyright 2014-2015 Ben Hale. All Rights Reserved

import UIKit

final class RemoteNotificationBroker {

    static let instance = RemoteNotificationBroker()

    typealias Listener = UserInfo -> UIBackgroundFetchResult

    typealias UserInfo = [NSObject : AnyObject]

    private init() {}

    private let monitor = Monitor()

    private var listeners: [Memento : Listener] = [:]

    func publish(userInfo: UserInfo) -> UIBackgroundFetchResult {
        return synchronized(self.monitor) {
            var result = UIBackgroundFetchResult.NoData

            for listener in self.listeners.values {
                result = self.max(result, listener(userInfo))
            }

            return result
        }
    }

    func subscribe(listener: Listener) -> Memento {
        return synchronized(self.monitor) {
            let memento = Memento()
            self.listeners[memento] = listener
            return memento
        }
    }

    func unsubscribe(memento: Memento?) {
        if let memento = memento {
            synchronized(self.monitor) {
                self.listeners[memento] = nil
            }
        }
    }

    private func max(a: UIBackgroundFetchResult, _ b: UIBackgroundFetchResult) -> UIBackgroundFetchResult {
        switch a {
        case .NoData:
            return b
        case .NewData:
            switch b  {
            case .NoData:
                return a
            case .NewData:
                return UIBackgroundFetchResult.NewData
            case .Failed:
                return b
            }
        case .Failed:
            return a
        }
    }

}
