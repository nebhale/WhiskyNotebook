// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation

final class Scanner {
    
    private let scanner : NSScanner
    
    init(string: String) {
        self.scanner = NSScanner(string: string)
    }
    
    func scan(token: String) -> Bool {
        return scanner.scanString(token, intoString: nil)
    }
    
    func scanDouble() -> Double? {
        var double: CDouble = 0.0
        let didScan = self.scanner.scanDouble(&double)
        return didScan ? Double(double) : nil
    }
    
    func scanInt() -> Int? {
        var int: CInt = 0
        let didScan = self.scanner.scanInt(&int)
        return didScan ? Int(int) : nil
    }
    
}