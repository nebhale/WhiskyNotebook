// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation
import ReactiveCocoa


infix operator =~ { associativity left precedence 130 }

public func =~ (input: String, pattern: String) -> Bool {
    return input.rangeOfString(pattern, options: .RegularExpressionSearch) != nil
}

