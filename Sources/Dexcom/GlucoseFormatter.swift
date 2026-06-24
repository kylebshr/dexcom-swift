//
//  File.swift
//  
//
//  Created by Kyle Bashour on 5/7/24.
//

import Foundation

public struct GlucoseFormatter: FormatStyle, Sendable {
    public enum Unit: Codable, Sendable {
        case mgdl
        case mmolL
    }

    public let unit: Unit

    public init(unit: Unit) {
        self.unit = unit
    }

    public func format(_ value: Int) -> String {
        // The Share API reports sentinel values when a reading is outside the
        // sensor's measurable range (40–400 mg/dL): 39 means below range and
        // 401 means above range. These aren't real numbers, so display them as
        // "Low"/"Hi" regardless of unit. The casing assumes the caller applies
        // small caps (e.g. SwiftUI's `.lowercaseSmallCaps()`) at display time.
        if value <= .lowestGlucoseValue {
            return "Low"
        }

        if value >= .highestGlucoseValue {
            return "Hi"
        }

        switch unit {
        case .mgdl:
            return value.formatted(.number.precision(.fractionLength(0)))
        case .mmolL:
            return (Double(value) * .mmolConversionFactor).formatted(.number.precision(.fractionLength(1)))
        }
    }
}

public extension FormatStyle where Self == GlucoseFormatter {
    static func glucose(_ unit: GlucoseFormatter.Unit) -> Self {
        GlucoseFormatter(unit: unit)
    }
}
