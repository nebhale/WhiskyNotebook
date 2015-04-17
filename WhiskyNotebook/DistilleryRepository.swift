// Copyright 2014-2015 Ben Hale. All Rights Reserved

import ReactiveCocoa


public protocol DistilleryRepository {

    var distilleries: SignalProducer<Set<Distillery>, NoError> { get }

    func delete(distillery: Distillery)

    func save(distillery: Distillery)
}
