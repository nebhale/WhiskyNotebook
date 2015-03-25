// Copyright 2014-2015 Ben Hale. All Rights Reserved

import ReactiveCocoa
import UIKit

public final class DramsController: UITableViewController {

    private var drams: [Dram] = [] {
        didSet { self.tableView.reloadData() }
    }

    public var repository = DramRepositoryManager.sharedInstance

    public var scheduler: SchedulerType = UIScheduler()

    @IBAction
    func cancelNewDram(segue : UIStoryboardSegue) {}

    @IBAction
    func saveNewDram(segue : UIStoryboardSegue) {
        (segue.sourceViewController as? NewDramController)?.performSave()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        let producer = repository.drams.producer |> startOn(self.scheduler)
        producer.start(next: { self.drams = $0 }) // TODO: Inline once segfault is fixed
    }
}

extension DramsController: UITableViewDataSource {
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Dram", forIndexPath: indexPath) as! UITableViewCell
        let dram = drams[indexPath.row]

        dram.configure(cell)

        return cell
    }

    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.drams.count
    }
}

extension Dram {
    public func configure(cell: UITableViewCell) {
        cell.textLabel?.text = id
    }
}
