// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation

final class Logger {
    
    private let logWriter = LogWriter.instance
    
    private let name: String
    
    init(name: String) {
        self.name = name
        self.logWriter.registerName(name)
    }
    
    typealias MessageProvider = () -> AnyObject?
    
    func debug(messageProvider: MessageProvider) {
        self.logWriter.debug(self.name, messageProvider)
    }

    func info(messageProvider: MessageProvider) {
        self.logWriter.info(self.name, messageProvider)
    }
    
    func warn(messageProvider: MessageProvider) {
        self.logWriter.warn(self.name, messageProvider)
    }

    func error(messageProvider: MessageProvider) {
        self.logWriter.error(self.name, messageProvider)
    }

}



