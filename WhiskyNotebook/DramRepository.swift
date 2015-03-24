// Copyright 2014-2015 Ben Hale. All Rights Reserved

import ReactiveCocoa


public protocol DramRepository {

    var drams: MutableProperty<[Dram]> { get }

    func save(dram: Dram)
}
