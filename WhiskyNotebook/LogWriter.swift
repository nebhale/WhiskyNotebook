// Copyright 2014 Ben Hale. All Rights Reserved

import Foundation

final class LogWriter {
    
    private let level = Level.Debug
    
    private let monitor = Monitor()
    
    private var maxNameLength = 0
    
    func registerName(name: String) {
        synchronized(self.monitor) {
            self.maxNameLength = max(self.maxNameLength, countElements(name))
        }
    }
    
    func debug(name:String, closure: () -> (AnyObject)) {
        log(Level.Debug) { return "[DEBUG] \(self.pad(name)) \(closure())" }
    }
    
    func info(name: String, closure: () -> (AnyObject)) {
        log(Level.Info) { return "[INFO]  \(self.pad(name)) \(closure())" }
    }
    
    func warn(name: String, closure: () -> (AnyObject)) {
        log(Level.Warn) { return "[WARN]  \(self.pad(name)) \(closure())" }
    }
    
    func error(name: String, closure: () -> (AnyObject)) {
        log(Level.Error) { return "[ERROR] \(self.pad(name)) \(closure())" }
    }
    
    private func log(level: Level, closure: () -> (String)) {
        synchronized(self.monitor) {
            if self.level.rawValue <= level.rawValue {
                println(closure())
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