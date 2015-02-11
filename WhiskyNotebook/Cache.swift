// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation


func URLForCached(name: String, withExtension: String = "plist") -> NSURL? {
    let fileManager = NSFileManager.defaultManager()

    if let cachesDirectory = fileManager.URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask).first as? NSURL {
        if let bundleIdentifier = NSBundle.mainBundle().bundleIdentifier {
            let bundleCacheDirectory = cachesDirectory.URLByAppendingPathComponent(bundleIdentifier, isDirectory: true)
            fileManager.createDirectoryAtURL(bundleCacheDirectory, withIntermediateDirectories: true, attributes: nil, error: nil)

            return bundleCacheDirectory.URLByAppendingPathComponent(name).URLByAppendingPathExtension(withExtension)
        } else {
            return nil
        }
    } else {
        return nil
    }
}
