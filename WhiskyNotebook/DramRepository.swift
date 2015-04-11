// Copyright 2014-2015 Ben Hale. All Rights Reserved

import ReactiveCocoa


public protocol DramRepository {

    var drams: SignalProducer<Set<Dram>, NoError> { get }

    func delete(dram: Dram)

    func save(dram: Dram)
}
