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
        switch unit {
        case .mgdl:
            value.formatted(.number.precision(.fractionLength(0)))
        case .mmolL:
            (Double(value) * .mmolConversionFactor).formatted(.number.precision(.fractionLength(1)))
        }
    }
}

public extension FormatStyle where Self == GlucoseFormatter {
    static func glucose(_ unit: GlucoseFormatter.Unit) -> Self {
        GlucoseFormatter(unit: unit)
    }
}
