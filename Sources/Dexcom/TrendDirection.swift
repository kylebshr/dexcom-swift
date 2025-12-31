//
//  TrendDirection.swift
//  Dexcom
//
//  Created by Kyle Bashour on 4/1/24.
//

import Foundation

public enum TrendDirection: String, Codable, CaseIterable, Sendable {
    case none = "None"
    case doubleUp = "DoubleUp"
    case singleUp = "SingleUp"
    case fortyFiveUp = "FortyFiveUp"
    case flat = "Flat"
    case fortyFiveDown = "FortyFiveDown"
    case singleDown = "SingleDown"
    case doubleDown = "DoubleDown"
    case notComputable = "NotComputable"
    case rateOutOfRange = "RateOutOfRange"
}
