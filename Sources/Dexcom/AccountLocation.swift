//
//  File.swift
//  
//
//  Created by Kyle Bashour on 5/6/24.
//

import Foundation

public enum AccountLocation: String, Codable {
    case usa
    case apac
    case worldwide

    var url: URL {
        switch self {
        case .usa:
            .baseURL
        case .apac:
            .baseURLAPAC
        case .worldwide:
            .baseURLOUS
        }
    }

    var appID: String {
        switch self {
        case .usa, .worldwide:
            .dexcomAppID
        case .apac:
            .dexcomAppIDAPAC
        }
    }
}
