// Copyright 2014-2015 Ben Hale. All Rights Reserved

import CloudKit

final class UserRepository {
    
    class var instance: UserRepository {
        struct Static {
            static let instance = UserRepository()
        }
        
        return Static.instance
    }
    
    typealias Listener = User? -> Void
    
    private let database = CKContainer.defaultContainer().privateCloudDatabase
    
    private var listeners: [Memento : Listener] = [:]
    
    private let logger = Logger(name: "UserRepository")
    
    private let monitor = Monitor()
    
    private var user: User? {
        didSet {
            synchronized(self.monitor) {
                for listener in self.listeners.values {
                    listener(self.user)
                }
            }
        }
    }
    
    private init() {
        fetch()
    }
    
    func save(user: User?) {
        if let user = user {
            self.database.saveRecord(user.toRecord()) { record, error in
                if error != nil {
                    // TODO:
                    self.logger.error { "Error saving user: \(error)"}
                    return
                }
                
                self.user = User(record: record)
            }
        }
    }
    
    func subscribe(listener: Listener) -> Memento {
        return synchronized(self.monitor) {
            let memento = Memento()
            self.listeners[memento] = listener
            listener(self.user)
            return memento
        }
    }
    
    func unsubscribe(memento: Memento?) {
        if let memento = memento {
            synchronized(self.monitor) {
                self.listeners[memento] = nil
            }
        }
    }
    
    private func fetch() {
        CKContainer.defaultContainer().fetchUserRecordIDWithCompletionHandler { recordId, error in
            if error != nil {
                //TODO:
                self.logger.error { "Error fetching user: \(error)" }
                return
            }
            
            self.database.fetchRecordWithID(recordId) { record, error in
                if error != nil {
                    //TODO:
                    self.logger.error { "Error fetching user: \(error)" }
                    return
                }

                self.user = User(record: record)
            }
        }
    }
    
}
