// Copyright 2014 Ben Hale. All Rights Reserved

import Foundation

final class Logger {
    
    // MARK: Properties
    
    private class var logWriter: LogWriter {
        struct Static {
            static var instance: LogWriter?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = LogWriter()
        }
        
        return Static.instance!
    }

    private let name: String
    
    // MARK: Initializers
    
    init(_ name: String) {
        self.name = name
        Logger.logWriter.registerName(name)
    }
    
    // MARK:

    func debug(closure: () -> (AnyObject)) {
        Logger.logWriter.debug(self.name, closure)
    }

    func info(closure: () -> (AnyObject)) {
        Logger.logWriter.info(self.name, closure)
    }
    
    func warn(closure: () -> (AnyObject)) {
        Logger.logWriter.warn(self.name, closure)
    }

    func error(closure: () -> (AnyObject)) {
        Logger.logWriter.error(self.name, closure)
    }

}



