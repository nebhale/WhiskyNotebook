// Copyright 2014-2015 Ben Hale. All Rights Reserved

import UIKit


final class DistilleriesController: UITableViewController, UIDocumentPickerDelegate {
    
    private let logger = Logger(name: "DistilleriesController")
    
    private var addButton: UIBarButtonItem?
    
    var distilleries: [Distillery]? = [] {
        didSet {
            onMain { self.tableView.reloadData() }
        }
    }
    
    var distilleryRepositoryMemento: Memento?
    
    private var importButton: UIBarButtonItem?
    
    var user: User? {
        didSet {
            onMain {
                self.navigationItem.rightBarButtonItem = (self.user?.administrator? == true) ? self.addButton : nil
                self.navigationItem.leftBarButtonItem = (self.user?.administrator? == true) ? self.importButton : nil
                self.tableView.reloadData()
            }
        }
    }
    
    var userRepositoryMemento: Memento?
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        DistilleryRepository.instance.unsubscribe(self.distilleryRepositoryMemento)
        UserRepository.instance.unsubscribe(self.userRepositoryMemento)
    }
    
    @IBAction
    func distilleryAddCancel(segue: UIStoryboardSegue) {
        self.logger.debug { "Distillery add canceled" }
    }
    
    @IBAction
    func distilleryAddSave(segue: UIStoryboardSegue) {
        if let controller = segue.sourceViewController.childViewControllers.first as? DistilleryAddDataController {
            DistilleryRepository.instance.save(controller.toDistillery())
        }
    }
    
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        var error: NSError?
        let contents = String(contentsOfURL: url, encoding: NSUTF8StringEncoding, error: &error)
        
        if error != nil {
            // TODO: Handle error reading imported file
            self.logger.error { "Error reading imported file: \(error)" }
            return
        }
        
        if let contents = contents {
            for line in contents.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).componentsSeparatedByString("\n") {
                let distillery = Distillery(data: line.componentsSeparatedByString(","))
                DistilleryRepository.instance.save(distillery)
            }
        }
    }
    
    @IBAction
    func importDistilleries() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.comma-separated-values-text"], inMode: UIDocumentPickerMode.Import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        
        self.presentViewController(documentPicker, animated: true, completion: nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDistillery" {
            if let row = self.tableView.indexPathForSelectedRow()?.row {
                (segue.destinationViewController as DistilleryController).distillery = self.distilleries?[row]
            }
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.user?.administrator? == true
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Distillery", forIndexPath: indexPath) as DistilleryCell
        cell.loadItem(distilleries?[indexPath.row])
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if UITableViewCellEditingStyle.Delete == editingStyle {
            DistilleryRepository.instance.delete(self.distilleries?[indexPath.row])
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let distilleries = self.distilleries {
            return distilleries.count
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.distilleryRepositoryMemento = DistilleryRepository.instance.subscribe { self.distilleries = $0 }
        self.userRepositoryMemento = UserRepository.instance.subscribe { self.user = $0 }
        
        self.addButton = self.navigationItem.rightBarButtonItem
        self.navigationItem.rightBarButtonItem = nil
        
        self.importButton = self.navigationItem.leftBarButtonItem
        self.navigationItem.leftBarButtonItem = nil
    }
    
}