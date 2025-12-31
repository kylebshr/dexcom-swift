//
//  DexcomError.swift
//  Dexcom
//
//  Created by Kyle Bashour on 4/1/24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public enum ErrorCode: String, Codable, Sendable {
    case sessionIdNotFound = "SessionIdNotFound"
    case sessionNotValid = "SessionNotValid"
    case accountPasswordInvalid = "AccountPasswordInvalid"
    case authenticateMaxAttemptsExceeed = "SSO_AuthenticateMaxAttemptsExceeed"
    case invalidArgument = "InvalidArgument"
}

public struct DexcomError: Codable, Error, Sendable {
    public var code: ErrorCode?
    public var message: String?

    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case message = "Message"
    }
}

public struct DexcomDecodingError: Error, Sendable {
    public var errorDescription: String
    public var body: Data
    public var statusCode: Int?
    public var url: URL?

    init(error: any Error, body: Data, response: URLResponse) {
        self.errorDescription = String(describing: error)
        self.body = body
        self.statusCode = (response as? HTTPURLResponse)?.statusCode
        self.url = response.url
    }
}
