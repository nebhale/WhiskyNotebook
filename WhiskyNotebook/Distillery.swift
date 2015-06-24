// Copyright 2014-2015 Ben Hale.  All Rights Reserved.

import CoreLocation


protocol Distillery {

    var id: String? { get set }

    var location: CLLocation? { get set }

    var name: String? { get set }

    var region: Region? { get set }
}

// MARK: - Comparison

extension Distillery {
    func rank() -> Int {
        return (self.id?.rank ?? 0) + (self.region?.rank ?? 0)
    }
}

extension Region {
    private var rank: Int {
        switch self {
        case .Grain:
            return 7000
        default:
            return 0
        }
    }
}

extension String {

    private func matches(pattern: String) -> [NSTextCheckingResult]? {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            return regex.matchesInString(self, options: [], range: NSMakeRange(0, self.characters.count))
        } catch {
            return nil
        }
    }

    private var rank: Int {
        if let matches = self.matches("^[A-Z]?([\\d]+)$") {
            let range = matches[0].rangeAtIndex(1)
            return Int((self as NSString).substringWithRange(range)) ?? 0
        }

        return 0
    }
}