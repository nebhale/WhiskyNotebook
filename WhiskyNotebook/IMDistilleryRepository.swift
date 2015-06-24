// Copyright 2014-2015 Ben Hale.  All Rights Reserved.

import CacheCache
import Foundation
import ReactiveCocoa


final class IMDistilleryRepository: DistilleryRepository {

    private let _distilleries: MutableProperty<[IMDistillery]>

    let distilleries: PropertyOf<[Distillery]>

    // MARK: -

    init<T: Cache where T.PayloadType == [IMDistillery]>(cache: T) {
        let initialValue = cache.retrieve(deserializer: IMDistilleryRepository.deserialize) ?? []
        self._distilleries = MutableProperty(initialValue)

        let typeConverter = MutableProperty<[Distillery]>([])
        typeConverter <~ self._distilleries.producer
            .map { $0.map { $0 as Distillery } }

        self.distilleries = PropertyOf(typeConverter)
        self._distilleries.producer
            .skip(1)
            .skipRepeats { $0 == $1 }
            .start { cache.persist($0, serializer: IMDistilleryRepository.serialize) }

        populate()
    }

    // MARK: - Cache

    private static func deserialize(value: Any) -> [IMDistillery]? {
        return value as? [IMDistillery]
    }

    private static func serialize(distilleries: [IMDistillery]) -> Any {
        return distilleries
    }

    // MARK: Initialization

    private func populate() {
        self._distilleries.value = [
            IMDistillery(id: "1", location: CLLocation(latitude: 57.427211, longitude: -3.318214), name: "Glenfarclas", region: .Speyside),
            IMDistillery(id: "3", location: CLLocation(latitude: 55.757139, longitude: -6.289844), name: "Bowmore", region: .Islay),
            IMDistillery(id: "4", location: CLLocation(latitude: 58.968603, longitude: -2.95545), name: "Highland Park", region: .Highland),
            IMDistillery(id: "5", location: CLLocation(latitude: 55.922, longitude: -4.439), name: "Auchentoshan", region: .Lowland),
            IMDistillery(id: "27", location: CLLocation(latitude: 55.425, longitude: -5.609), name: "Springbank", region: .Campbeltown),
            IMDistillery(id: "51", location: CLLocation(latitude: 55.201919, longitude: -6.519648), name: "Bushmills", region: .Ireland),
            IMDistillery(id: "116", location: CLLocation(latitude: 43.187222, longitude: 140.791667), name: "Yoichi", region: .Japan),
            IMDistillery(id: "128", location: CLLocation(latitude: 51.764167, longitude: -3.521111), name: "Penderyn", region: .Wales),
            IMDistillery(id: "G1", location: CLLocation(latitude: 55.940128, longitude: -3.235603), name: "North British", region: .Grain)
        ]
    }
}