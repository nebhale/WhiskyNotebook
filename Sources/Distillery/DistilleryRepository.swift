// Copyright 2014-2015 Ben Hale. All Rights Reserved


import ReactiveCocoa

protocol DistilleryRepository {

    var distilleries: PropertyOf<Set<Distillery>> { get }

    func delete(distillery: Distillery)

    func save(distillery: Distillery)
}