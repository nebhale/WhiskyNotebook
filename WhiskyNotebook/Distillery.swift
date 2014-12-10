// Copyright 2014 Ben Hale. All Rights Reserved

final class Distillery: Comparable, Equatable, Hashable {
    let id: String
    
    let name: String
    
    let region: Region
    
    let latitude: Double
    
    let longitude: Double
    
    init(id:String, name: String, region: Region, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.region = region
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var hashValue: Int {
        return id.hashValue
    }
}

func ==(x: Distillery, y: Distillery) -> Bool {
    return x.id == y.id
}

func <(x: Distillery, y: Distillery) -> Bool {
    return x.id < y.id
}
