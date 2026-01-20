//
//  AppInfoLiveStore.swift
//  ios26_test
//
//  Created by Christoph Huschenhöfer on 08.12.25.
//

import Foundation

struct AppInfoLiveStore {
    let name: String = "testApp"
    let description: String = "This is a test app"
    let developer: String = "Christoph Huschenhöfer"
    let website: String = "https://www.testapp.com"
    let agreements: Agreements = .init()
    
    var version: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "-"
    }
    
    var companyName: String {
        if let minimumVersion = Bundle.main.infoDictionary?["MinimumOSVersion"] as? String {
            return "iOS \(minimumVersion)+"
        }
        return "-"
    }
}

extension AppInfoLiveStore {
    struct Agreements {
        let copyrightURL: String = "https://www.testapp.com/copyright/testApp"
        let disclaimerURL: String = "https://www.testapp.com/disclaimer/testApp"
        let licenseURL: String = "https://www.testapp.com/license/testApp"
        let privacyPolicyURL: String = "https://www.testapp.com/privacy/testApp"
        let termsOfServiceURL: String = "https://www.testapp.com/terms/testApp"
    }
}
