// Copyright 2014-2015 Ben Hale. All Rights Reserved

import ReactiveCocoa
import UIKit

public final class NewDramController: UITableViewController {

    private var dram = MutableProperty(Dram())

    private let logger = Logger()

    @IBOutlet
    public var id: UITextField!

    public var repository = DramRepositoryManager.sharedInstance

    @IBOutlet
    public var save: UIBarButtonItem!

    public var scheduler: SchedulerType = QueueScheduler()

    override public func viewDidLoad() {
        super.viewDidLoad()

        let idProducer = self.id.rac_textSignal().toSignalProducer() |> map { $0 as? String  }
        idProducer.start(next: { self.dram.value.id = $0 }) // TODO: Inline once segfault is fixed

        self.dram.producer.start(next: { self.save.enabled = $0.valid() }) // TODO: Inline once segfault is fixed
    }

    public func performSave() {
        self.logger.info("Dram save initiated")

        let producer = SignalProducer<Dram, NoError>(value: self.dram.value) |> startOn(self.scheduler)
        producer.start(next: { self.repository.save($0) })
    }
    
}
