// Copyright 2014 Ben Hale. All Rights Reserved

import Foundation

final class Distilleries {
    
    private let logger = Logger(name: "Distilleries")
    
    private let monitor = Monitor()
    
    private let root = NSURL(string: "http://whisky-notebook-server.cfapps.io/reference")!
    
    private var distilleries: [Distillery]
    
    subscript(index: Int) -> Distillery {
        return synchronized(self.monitor) {
            return self.distilleries[index]
        }
    }
    
    init() {
        self.distilleries = []
    }
    
    func count() -> Int {
        return synchronized(self.monitor) {
            return self.distilleries.count
        }
    }
    
    func map<T>(transform: (Distillery) -> T) -> [T] {
        return synchronized(self.monitor) {
            return self.distilleries.map(transform)
        }
    }
    
    func update(closure: (() -> Void)? = nil) {
        JSONRequest(uri: self.root).link("distilleries") { (href) in
            JSONRequest(uri: href).payload { (payload: [[String:AnyObject]]) in
                synchronized(self.monitor) {
                    for entity in payload {
                        self.processEntity(entity)
                    }
                }
                
                closure?()
            }
        }
    }
    
    private func processEntity(entity: [String:AnyObject]) {
        switch(entity["id"], entity["name"], entity["region"], entity["latitude"], entity["longitude"]) {
        case(.Some(let id as String), .Some(let name as String), .Some(let region as String), .Some(let latitude as Double), .Some(let longitude as Double)):
            self.distilleries.append(Distillery(id: id, name: name, region: Region(rawValue: region)!, latitude: latitude, longitude: longitude))
        default:
            self.logger.error { "Invalid distillery payload '\(entity)'" }
        }
    }
    
}