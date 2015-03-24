// Copyright 2014-2015 Ben Hale. All Rights Reserved

import ReactiveCocoa
import UIKit

public class NewDramController: UITableViewController {

    private var dram = MutableProperty(Dram())

    @IBOutlet
    public var save: UIBarButtonItem!

    @IBOutlet
    public var id: UITextField!

    public var repository = DramRepositoryManager.sharedInstance

    public var scheduler: SchedulerType = QueueScheduler()

    override public func viewDidLoad() {
        super.viewDidLoad()

        let idProducer = self.id.rac_textSignal().toSignalProducer() |> map { $0 as? String  }
        idProducer.start(next: { self.dram.value.id = $0 }) // TODO: Inline once segfault is fixed

        self.dram.producer.start(next: { self.save.enabled = $0.valid() }) // TODO: Inline once segfault is fixed
    }

    public func performSave() {
        let producer = SignalProducer<Dram, NoError>(value: self.dram.value) |> startOn(self.scheduler)
        producer.start(next: { self.repository.save($0) })
    }
    
}
