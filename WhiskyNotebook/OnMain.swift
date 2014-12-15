// Copyright 2014 Ben Hale. All Rights Reserved

import Foundation

func onMain(closure: () -> Void) {
    dispatch_async(dispatch_get_main_queue(), closure)
}