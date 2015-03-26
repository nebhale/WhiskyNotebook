// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation


extension String {
    public func basename() -> String {
        return self.lastPathComponent.stringByDeletingPathExtension
    }
}