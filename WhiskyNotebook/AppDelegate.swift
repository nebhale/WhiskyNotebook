// Copyright 2014-2015 Ben Hale. All Rights Reserved

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let logger = Logger(name: "AppDelegate")

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: UIBackgroundFetchResult -> Void) {
        self.logger.debug { userInfo }
        return completionHandler(RemoteNotificationBroker.instance.publish(userInfo))
    }

}

