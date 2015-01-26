// Copyright 2014-2015 Ben Hale. All Rights Reserved

extension String {
    
    func toBool() -> Bool {
        return self == "\(true)"
    }
    
    func toDouble() -> Double? {
        return Scanner(string: self).scanDouble()
    }
    
}