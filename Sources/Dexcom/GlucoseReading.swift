//
//  GlucoseReading.swift
//  Dexcom
//
//  Created by Kyle Bashour on 4/1/24.
//

import Foundation

public struct GlucoseReading: Codable {
    public var value: Int
    public var trend: TrendDirection
    public var date: Date

    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case trend = "Trend"
        case date = "WT"
    }
}
