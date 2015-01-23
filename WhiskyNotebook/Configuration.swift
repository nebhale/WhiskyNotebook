// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation


typealias Configuration = [String : AnyObject]

func configuration(name: String) -> Configuration? {
    var qualifiedName: String
    if let configuration = (NSBundle.mainBundle().infoDictionary as? Configuration)?["Configuration"] as? String {
        qualifiedName = "\(name)-\(configuration)"
    } else {
        qualifiedName = name
    }
    
    var path: String?
    if let candidate = NSBundle.mainBundle().pathForResource(qualifiedName, ofType: "plist") {
        path = candidate
    } else if let candidate = NSBundle.mainBundle().pathForResource(name, ofType: "plist") {
        path = candidate
    }
    
    if let path = path {
        return NSDictionary(contentsOfFile: path) as? [String: AnyObject]
    } else {
        return nil
    }
}