// Copyright 2014-2015 Ben Hale.  All Rights Reserved.

import CoreLocation
import Foundation


struct IMDistillery: Distillery {

    var id: String?

    var location: CLLocation?

    var name: String?

    var region: Region?
}

// MARK: - Comparison
extension IMDistillery: Comparable {}
func <(x: IMDistillery, y: IMDistillery) -> Bool {
    return x.rank() < y.rank()
}

// MARK: Equatable
extension IMDistillery: Equatable {}
func ==(x: IMDistillery, y: IMDistillery) -> Bool {
    return x.id == y.id
}

// MARK: CustomStringConvertible
extension IMDistillery: CustomStringConvertible {
    var description: String { return "<IMDistillery: \(self.id); location=(\(self.location?.coordinate.latitude), \(self.location?.coordinate.longitude)), name=\(self.name), region=\(self.region)>" }
}