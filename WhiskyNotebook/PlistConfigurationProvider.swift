// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation


public final class PlistConfigurationProvider: ConfigurationProvider {

    private var configurations: [String : Configuration] = [:]

    private let rootConfiguration: Configuration

    public init(file: String = "Logging", bundle: NSBundle = NSBundle.mainBundle()) {
        let source = PlistConfigurationProvider.readSource(file, bundle: bundle)
        rootConfiguration = PlistConfigurationProvider.toConfiguration("ROOT", source: source)

        for (key, value) in source {
            if let value = value as? [String : AnyObject] {
                configurations += PlistConfigurationProvider.toConfiguration(key, source: value)
            }
        }
    }

    public func configuration(name: String) -> Configuration {
        if let configuration = self.configurations[name] {
            return configuration
        } else {
            return self.rootConfiguration
        }
    }

    private static func toConfiguration(name: String, source: [String : AnyObject]) -> Configuration {
        var configuration = Configuration(name: name)

        if let level = source["Level"] as? String {
            configuration.level = Level.fromString(level)
        }

        if let format = source["Format"] as? String {
            configuration.format = format
        }

        return configuration
    }

    private static func readSource(file: String, bundle: NSBundle) -> [String : AnyObject] {
        if let url = bundle.URLForResource(file, withExtension: "plist"), let dictionary = NSDictionary(contentsOfURL: url) as? [String: AnyObject] {
            return dictionary
        } else {
            return [:]
        }
    }
}

func +=(inout dictionary: [String : Configuration], configuration: Configuration) -> [String : Configuration] {
    dictionary[configuration.name] = configuration
    return dictionary
}