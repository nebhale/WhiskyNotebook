// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation

extension String {
    
    func contains(substring: String) -> Bool {
        return self.rangeOfString(substring) != nil
    }
    
    func containsIgnoreCase(substring: String) -> Bool {
        return self.rangeOfString(substring, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil
    }
    
    subscript (i: Int) -> String {
        return String(Array(self)[i])
    }
    
    func toBool() -> Bool {
        return self == "\(true)"
    }
    
    func toDouble() -> Double? {
        return Scanner(string: self).scanDouble()
    }
    
}