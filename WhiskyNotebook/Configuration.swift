// Copyright 2014 Ben Hale. All Rights Reserved

import Foundation

func configuration(name: String) -> [String: AnyObject]? {
    if let path = NSBundle.mainBundle().pathForResource("Logging", ofType: "plist") {
        if let configuration = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            return configuration
        }
    }
    return nil
}