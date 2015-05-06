// Copyright 2014-2015 Ben Hale. All Rights Reserved


import ReactiveCocoa
import UIKit

protocol DramDataSource: UITableViewDataSource {
    var drams: PropertyOf<[Dram]> { get }
}