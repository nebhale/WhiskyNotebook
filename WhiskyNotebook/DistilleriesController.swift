// Copyright 2014-2015 Ben Hale. All Rights Reserved

import UIKit


final class DistilleriesController: UITableViewController {
    
    private let logger = Logger(name: "DistilleriesController")
    
    private var addButton: UIBarButtonItem?
    
    var distilleries: [Distillery] = [] {
        didSet {
            onMain { self.tableView.reloadData() }
        }
    }
    
    var user: User? {
        didSet {
            onMain {
                self.navigationItem.rightBarButtonItem = (self.user?.administrator? == true) ? self.addButton : nil
                self.tableView.reloadData()
            }
        }
    }
    
    var distilleryRepositoryMemento: Memento?
    
    var userRepositoryMemento: Memento?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.distilleryRepositoryMemento = DistilleryRepository.instance.subscribe { self.distilleries = $0 }
        self.userRepositoryMemento = UserRepository.instance.subscribe { self.user = $0 }
        
        self.addButton = self.navigationItem.rightBarButtonItem
        self.navigationItem.rightBarButtonItem = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        DistilleryRepository.instance.unsubscribe(self.distilleryRepositoryMemento)
        UserRepository.instance.unsubscribe(self.userRepositoryMemento)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.user?.administrator? == true
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Distillery", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = distilleries[indexPath.row].id
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if UITableViewCellEditingStyle.Delete == editingStyle {
            DistilleryRepository.instance.delete(self.distilleries[indexPath.row])
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return distilleries.count
    }
    
}