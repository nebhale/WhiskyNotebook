// Copyright 2014-2015 Ben Hale. All Rights Reserved

import CloudKit
import Foundation


final class DistilleryRepository {
    
    class var instance: DistilleryRepository {
        struct Static {
            static let instance = DistilleryRepository()
        }
        
        return Static.instance
    }
    
    typealias Listener = [Distillery] -> Void
    
    private let database = CKContainer.defaultContainer().publicCloudDatabase
    
    private var listeners: [Memento : Listener] = [:]
    
    private let logger = Logger(name: "DistilleryRepository")
    
    private let monitor = Monitor()
    
    private let predicate = NSPredicate(format: "TRUEPREDICATE")
    
    private let recordType = "Distillery"
    
    private var distilleries: [Distillery] = [] {
        didSet {
            synchronized(self.monitor) {
                for listener in self.listeners.values {
                    listener(self.distilleries)
                }
            }
        }
    }

    private init() {
        Subscription(recordType: recordType, database: self.database, predicate: self.predicate, notificationHandler: fetch)
    }
    
    func delete(distillery: Distillery?) {
        if let distillery = distillery {
            self.logger.debug { "Deleting distillery \(distillery)" }
            
            self.database.deleteRecordWithID(distillery.toRecord().recordID) { recordId, error in
                if error != nil {
                    //TODO:
                    self.logger.error { "Error deleting distillery: \(error)" }
                    return
                }
                
                self.distilleries = self.distilleries.filter { $0.toRecord().recordID != recordId }
                self.logger.info { "Deleted distillery: \(distillery)" }
            }
        }
    }
    
    func save(distillery: Distillery?) {
        if let distillery = distillery {
            self.logger.debug { "Saving distillery \(distillery)" }
            
            self.database.saveRecord(distillery.toRecord()) { record, error in
                if error != nil {
                    // TODO:
                    self.logger.error { "Error saving distillery: \(error)"}
                    return
                }
                
                let distillery = Distillery(record: record)
                
                var distilleries = self.distilleries
                distilleries.append(distillery)
                self.distilleries = distilleries.sorted { $0 < $1 }
                
                self.logger.info { "Saved distillery: \(distillery)" }
            }
        }
    }
    
    func subscribe(listener: Listener) -> Memento {
        return synchronized(self.monitor) {
            let memento = Memento()
            self.listeners[memento] = listener
            listener(self.distilleries)
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
        self.logger.debug { "Fetching distilleries" }
        
        let query = CKQuery(recordType: self.recordType, predicate: self.predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "Id", ascending: true)]
        
        self.database.performQuery(query, inZoneWithID: nil) { records, error in
            if error != nil {
                //TODO:
                self.logger.error { "Error fetching distilleries: \(error)" }
                return
            }
            
            if let records = records as? [CKRecord] {
                self.distilleries = records.map { return Distillery(record: $0) }
                self.logger.info { "Fetched distilleries: \(self.distilleries)" }
            }
        }
    }

}