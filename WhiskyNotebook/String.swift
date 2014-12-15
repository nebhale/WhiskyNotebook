// Copyright 2014 Ben Hale. All Rights Reserved

import Foundation

extension String {
    subscript (i: Int) -> String {
        return String(Array(self)[i])
    }
    
    func contains(substring: String) -> Bool {
        return self.rangeOfString(substring) != nil
    }
    
    func containsIgnoreCase(substring: String) -> Bool {
        return self.rangeOfString(substring, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil
    }
    
}