//
//  DexcomError.swift
//  Dexcom
//
//  Created by Kyle Bashour on 4/1/24.
//

import Foundation

public enum ErrorCode: String, Codable {
    case sessionIdNotFound = "SessionIdNotFound"
    case sessionNotValid = "SessionNotValid"
    case accountPasswordInvalid = "AccountPasswordInvalid"
    case authenticateMaxAttemptsExceeed = "SSO_AuthenticateMaxAttemptsExceeed"
    case invalidArgument = "InvalidArgument"
}

public struct DexcomError: Codable, Error {
    public var code: ErrorCode
    public var message: String?

    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case message = "Message"
    }
}
