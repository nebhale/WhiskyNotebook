// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation


func onMain(f: () -> Void) {
    dispatch_async(dispatch_get_main_queue(), f)
}
