//
//  Params.swift
//  Dexcom
//
//  Created by Kyle Bashour on 4/1/24.
//

import Foundation

struct GetAccountIDParams: Codable {
    var accountName: String
    var password: String
    var applicationId: String
}

struct GetSessionIDParams: Codable {
    var accountId: UUID
    var password: String
    var applicationId: String
}
