// Copyright 2014-2015 Ben Hale. All Rights Reserved


import ReactiveCocoa
import UIKit

protocol DistilleryDataSource: UITableViewDataSource {
    var distilleries: PropertyOf<[Distillery]> { get }
}