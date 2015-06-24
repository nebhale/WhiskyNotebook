// Copyright 2014-2015 Ben Hale.  All Rights Reserved.

import CacheCache
import Foundation
import ReactiveCocoa


final class IMProfileRepository: ProfileRepository {

    private let _profile: MutableProperty<IMProfile>

    let profile: PropertyOf<Profile>

    // MARK: -

    init<T: Cache where T.PayloadType == IMProfile>(cache: T) {
        let initialValue = cache.retrieve(deserializer: IMProfileRepository.deserialize) ?? IMProfile()
        self._profile = MutableProperty(initialValue)

        let typeConverter = MutableProperty<Profile>(IMProfile() as Profile)
        typeConverter <~ self._profile.producer
            .map { $0 as Profile }

        self.profile = PropertyOf(typeConverter)
        self._profile.producer
            .skip(1)
            .start { cache.persist($0, serializer: IMProfileRepository.serialize) }

        self._profile.value = IMProfile(administrator: true, membership: "1234567890")
    }

    // MARK: - Cache

    private static func deserialize(value: Any) -> IMProfile? {
        return value as? IMProfile
    }

    private static func serialize(profile: IMProfile) -> Any {
        return profile
    }
}