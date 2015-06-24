// Copyright 2014-2015 Ben Hale.  All Rights Reserved.

import LoggerLogger
import UIKit


@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    private let logger = Logger()

    var window: UIWindow?

    // MARK: -

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        application.registerForRemoteNotifications()

        ApplicationContext.sharedInstance.status = .Enabled
        ApplicationContext.sharedInstance.iCloudEnforcer().enforceAccountAvailable()

        return true
    }

    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        self.logger.info("Local Notification: \(notification)")
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        self.logger.info("Remote Notification: \(userInfo)")
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        self.logger.info("Remote Notification (Background): \(userInfo)")
        completionHandler(.NoData)
    }
}

