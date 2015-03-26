// Copyright 2014-2015 Ben Hale. All Rights Reserved

public protocol ConfigurationProvider {

    func configuration(name: String) -> Configuration
}