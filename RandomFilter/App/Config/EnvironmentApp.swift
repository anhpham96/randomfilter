//
//  EnvironmentApp.swift
//  Mechanic Buddy
//
//  Created by Pham Nguyen Nhat Anh on 22/04/2024.
//

import Foundation

enum EnvironmentApp: String {

    case dev = "dev"
    case production = "production"

    enum ConfigKey: String {
        case environment = "ENV_NAME"
        case admobAppID = "ADMOB_APP_ID"
        case interUnitID = "INTER_UNIT_ID"
        case nativeUnitID = "NATIVE_UNIT_ID"

    }

    private static let infoPlist: [String: Any] = Bundle.main.infoDictionary!
    static let environmentName = infoPlist[ConfigKey.environment.rawValue] as! String

    static let current = EnvironmentApp(rawValue: environmentName.lowercased())!
    static let appVersion = infoPlist["CFBundleShortVersionString"] as? String

    static let appName = infoPlist[kCFBundleNameKey as String] as! String

    
    // Add these new static properties
    static let admobAppID = infoPlist[ConfigKey.admobAppID.rawValue] as! String
    static let interUnitID = infoPlist[ConfigKey.interUnitID.rawValue] as! String
    static let nativeUnitID = infoPlist[ConfigKey.nativeUnitID.rawValue] as! String


}

extension EnvironmentApp {
    static var loadPrototype: Bool {
        switch EnvironmentApp.current {
        case .production:
            return false
        default:
            return false
        }
    }
}
