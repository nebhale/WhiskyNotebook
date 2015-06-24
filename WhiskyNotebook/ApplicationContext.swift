// Copyright 2014-2015 Ben Hale.  All Rights Reserved.

import CacheCache
import Foundation
import LoggerLogger
import UIKit


final class ApplicationContext {

    private var instances = [String : Any]()

    private let logger = Logger()

    private var profile: String?

    static let sharedInstance = ApplicationContext()

    var status = ApplicationContextStatus.Disabled

    // MARK: -

    private init() {
        self.profile = NSProcessInfo.processInfo().environment["PROFILE"]

        if let profile = self.profile {
            self.logger.info("Application Context Profile: \(profile)")
        }
    }

    // MARK: - Distillery

    func distilleryDataSource() -> DistilleryDataSource {
        return get("distilleryDataSource") {
            return DistilleryDataSource(distilleryRepository: distilleryRepository())
        }
    }

    func distilleryRepository() -> DistilleryRepository {
        switch self.profile {
        case .Some("test"):
            return get("distilleryRepository") {
                let cache = InMemoryCache(type: [IMDistillery].self)
                return IMDistilleryRepository(cache: cache)
            }
        default:
            return get("distilleryRepository") {
                let cache = PropertyListCache(type: [CKDistillery].self)
                return CKDistilleryRepository(cache: cache)
            }
        }
    }

    // MARK: Profile

    func profileRepository() -> ProfileRepository {
        switch self.profile {
        case .Some("test"):
            return get("profileRepository") {
                let cache = InMemoryCache(type: IMProfile.self)
                return IMProfileRepository(cache: cache)
            }
        default:
            return get("profileRepository") {
                let cache = PropertyListCache(type: CKProfile.self)
                return CKProfileRepository(cache: cache)
            }
        }
    }

    // MARK: Utility

    func iCloudEnforcer() -> ICloudEnforcer {
        return get("iCloudEnforcer") {
            return ICloudEnforcer(application: UIApplication.sharedApplication())
        }
    }

    func notificationCenter() -> NSNotificationCenter {
        return get("notificationCenter") {
            return NSNotificationCenter.defaultCenter()
        }
    }

    func notificationRepository() -> NotificationRepository {
        return get("notificationRepository") {
            return NotificationCenterNotificationRepository(notificationCenter: self.notificationCenter())
        }
    }

    // MARK: -

    private func get<T>(key: String, @noescape generator: () -> T) -> T {
        assert(.Enabled == self.status, "ApplicationContext is disabled")

        if self.instances[key] == nil {
            self.instances[key] = generator()
        }
        
        return self.instances[key] as! T
    }
}