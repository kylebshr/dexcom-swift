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

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try container.decode(Int.self, forKey: .value)
        self.trend = try container.decode(TrendDirection.self, forKey: .trend)
        
        let dateString = try container.decode(String.self, forKey: .date)
        self.date = Date(timeIntervalSince1970: Double(dateString) ?? 0)
    }
}
