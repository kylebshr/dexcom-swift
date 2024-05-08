//
//  Constants.swift
//  Dexcom
//
//  Created by Kyle Bashour on 4/1/24.
//

import Foundation

extension URL {
    static let baseURL = URL(string: "https://share2.dexcom.com/ShareWebServices/Services")!
    static let baseURLOUS = URL(string: "https://shareous1.dexcom.com/ShareWebServices/Services")!
    static let baseURLAPAC = URL(string: "https://share.dexcom.jp")!
}

extension String {
    static let loginEndpoint = "General/LoginPublisherAccountById"
    static let authenticateEndpoint = "General/AuthenticatePublisherAccount"
    static let readingsEndpoint = "Publisher/ReadPublisherLatestGlucoseValues"

    static let dexcomAppID = "d89443d2-327c-4a6f-89e5-496bbb0317db"
    static let dexcomAppIDAPAC = "d8665ade-9673-4e27-9ff6-92db4ce13d13"
}

extension Measurement<UnitDuration> {
    public static let maxGlucoseDuration = Self(value: 24, unit: .hours)
}

extension Int {
    public static let maxGlucoseCount = Int(Measurement.maxGlucoseDuration.converted(to: .minutes).value / 5)
}

extension Double {
    static let mmolConversionFactor: Double = 0.0555
}
