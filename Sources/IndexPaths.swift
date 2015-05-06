// Copyright 2014-2015 Ben Hale. All Rights Reserved


import UIKit

func toIndexPaths(rows: [Int], section: Int = 0) -> [NSIndexPath] {
    return rows.map { NSIndexPath(forRow: $0, inSection: section) }
}