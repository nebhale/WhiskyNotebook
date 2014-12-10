// Copyright 2014 Ben Hale. All Rights Reserved

import Foundation

final class JSONRequest {
    
    let logger = Logger(name: "JSONRequest")
    
    let uri: NSURL
    
    init(uri: NSURL) {
        self.uri = uri
    }
    
    convenience init(uri: String) {
        self.init(uri: NSURL(string: uri)!)
    }
    
    func link(rel: String, closure: (NSURL) -> ()) {
        payload { (payload: [String:[String:[String:String]]]) in
            if let href = payload["_links"]?[rel]?["href"] {
                closure(NSURL(string: href)!)
            } else {
                self.logger.warn { "Request for \(self.uri) does not contain link for \(rel): \(payload)" }
            }
        }
    }
    
    func payload<T>(closure: (T) -> ()) {
        self.logger.debug { return "Requesting \(self.uri)" }
        
        NSURLSession.sharedSession().dataTaskWithURL(self.uri, completionHandler: { (data, response, error) in
            if let response = response as? NSHTTPURLResponse {
                if response.statusCode == 200 {
                    closure(self.json(data))
                } else {
                    self.logger.warn { "Request for \(self.uri) returned status code \(response.statusCode)" }
                }
            } else {
                self.logger.error { error }
            }
        }).resume()
    }
    
    private func json<T>(data: NSData) -> T {
        return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error:nil) as T
    }
    
}
