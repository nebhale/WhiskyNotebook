// Copyright 2014 Ben Hale. All Rights Reserved

import Foundation

final class LogWriter {
    
    private let dateFormatter: NSDateFormatter
    
    private let level: Level
    
    private let monitor = Monitor()
    
    private var maxNameLength = 0
    
    init() {
        let config = configuration("Logging")
        
        self.dateFormatter = NSDateFormatter()
        self.dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        self.dateFormatter.dateFormat = config?["Format"] as? String
        
        if let level = config?["Level"] as? String {
            switch level {
            case "Debug":
                self.level = Level.Debug
            case "Info":
                self.level = Level.Info
            case "Warn":
                self.level = Level.Warn
            case "Error":
                self.level = Level.Error
            default:
                self.level = Level.Warn
            }
        } else {
            self.level = Level.Warn
        }
    }
    
    func registerName(name: String) {
        synchronized(self.monitor) {
            self.maxNameLength = max(self.maxNameLength, countElements(name))
        }
    }
    
    func debug(name:String, closure: () -> (AnyObject)) {
        log(Level.Debug) { "[DEBUG] \(self.pad(name)) \(closure())" }
    }
    
    func info(name: String, closure: () -> (AnyObject)) {
        log(Level.Info) { "[INFO]  \(self.pad(name)) \(closure())" }
    }
    
    func warn(name: String, closure: () -> (AnyObject)) {
        log(Level.Warn) { "[WARN]  \(self.pad(name)) \(closure())" }
    }
    
    func error(name: String, closure: () -> (AnyObject)) {
        log(Level.Error) { "[ERROR] \(self.pad(name)) \(closure())" }
    }
    
    private func log(level: Level, closure: () -> (String)) {
        synchronized(self.monitor) {
            if self.level.rawValue <= level.rawValue {
                println("\(self.dateFormatter.stringFromDate(NSDate())) \(closure())")
            }
        }
    }
    
    private func pad(name: String) -> String {
        var padded = name
        
        while countElements(padded) < self.maxNameLength {
            padded += " "
        }
        
        return padded
    }
    
    private enum Level: Int {
        
        case Debug, Info, Warn, Error
        
    }
    
}