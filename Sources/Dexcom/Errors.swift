//
//  DexcomError.swift
//  Dexcom
//
//  Created by Kyle Bashour on 4/1/24.
//

import Foundation

enum ErrorCode: String, Codable {
    case sessionIdNotFound = "SessionIdNotFound"
    case sessionNotValid = "SessionNotValid"
    case accountPasswordInvalid = "AccountPasswordInvalid"
    case authenticateMaxAttemptsExceeed = "SSO_AuthenticateMaxAttemptsExceeed"
    case invalidArgument = "InvalidArgument"
}

struct DexcomError: Codable, Error {
    var code: ErrorCode
    var message: String?

    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case message = "Message"
    }
}
