// Copyright 2014-2015 Ben Hale. All Rights Reserved

final class UserRepository {
    
    class var instance: UserRepository {
        struct Static {
            static let instance = UserRepository()
        }
        
        return Static.instance
    }
    
    private let logger = Logger(name: "UserRepository")
    
    private let monitor = Monitor()
    
    typealias UserHandler = User -> Void
    
    private var userHandlers: [Memento: UserHandler] = [:]
    
    private init() {}
    
    func save(user: User) {
        synchronized(self.monitor) {
            for userHandler in self.userHandlers.values {
                userHandler(user)
            }
        }
    }
    
    func subscribe(subscriber: UserHandler) -> Memento {
        return synchronized(self.monitor) {
            let memento = Memento()
            self.userHandlers[memento] = subscriber
            return memento
        }
    }
    
    func unsubscribe(memento: Memento?) {
        if let memento = memento {
            synchronized(self.monitor) {
                self.userHandlers[memento] = nil
            }
        }
    }
    
}
