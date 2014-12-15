// Copyright 2014 Ben Hale. All Rights Reserved

import Foundation

final class DistilleriesFactory {
    
    private let logger = Logger("DistilleriesFactory")
    
    private let root = NSURL(string: "http://localhost:8080/reference")!
    
    func create(closure: ([Distillery]) -> Void) {
        JSONRequest(self.root).link("distilleries") { (href) in
            self.handleDistilleryLink(href, closure)
        }
    }
    
    private func handleDistilleryLink(href:NSURL!, closure: ([Distillery]) -> Void) {
        JSONRequest(href).payload { (payload: [[String:AnyObject]]) in
            var distilleries: [Distillery] = []
            
            for entity in payload {
                if let distillery = self.process(entity) {
                    self.logger.debug { "Created \(distillery)" }
                    distilleries.append(distillery)
                }
            }
            
            closure(distilleries)
        }
    }
    
    private func process(entity: [String:AnyObject]) -> Distillery? {
        var distillery: Distillery?
        
        switch(entity["id"], entity["name"], entity["region"], entity["latitude"], entity["longitude"]) {
        case(.Some(let id as String), .Some(let name as String), .Some(let region as String), .Some(let latitude as Double), .Some(let longitude as Double)):
            distillery = Distillery(id, name, Distillery.Region(rawValue: region)!, latitude, longitude)
        default:
            self.logger.warn { "Invalid distillery payload '\(entity)'" }
        }
        
        return distillery
    }
}