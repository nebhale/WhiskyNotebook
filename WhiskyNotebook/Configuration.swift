// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation


typealias Configuration = [String : AnyObject]

func configuration(name: String) -> Configuration? {
    let qualifiedName: String
    if let configuration = (NSBundle.mainBundle().infoDictionary as? Configuration)?["Configuration"] as? String {
        qualifiedName = "\(name)-\(configuration)"
    } else {
        qualifiedName = name
    }

    let url: NSURL?
    if let candidate = NSBundle.mainBundle().URLForResource(qualifiedName, withExtension: "plist") {
        url = candidate
    } else if let candidate = NSBundle.mainBundle().URLForResource(name, withExtension: "plist") {
        url = candidate
    } else {
        url = nil
    }

    if let url = url {
        return NSDictionary(contentsOfURL: url) as? [String: AnyObject]
    } else {
        return nil
    }
}
