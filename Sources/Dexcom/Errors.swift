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

/// Metadata from the HTTP response that produced an error, so consumers can
/// inspect the status code and headers such as `Retry-After`.
public struct DexcomHTTPResponse: Codable, Sendable {
    public var statusCode: Int
    public var url: URL?

    /// All response header fields, keyed by lowercased header name.
    public var headers: [String: String]

    public init(statusCode: Int, url: URL? = nil, headers: [String: String] = [:]) {
        self.statusCode = statusCode
        self.url = url
        self.headers = Dictionary(
            headers.map { ($0.key.lowercased(), $0.value) },
            uniquingKeysWith: { first, _ in first }
        )
    }

    init?(response: URLResponse) {
        guard let response = response as? HTTPURLResponse else {
            return nil
        }

        var headers: [String: String] = [:]
        for (key, value) in response.allHeaderFields {
            if let key = key as? String {
                headers[key] = String(describing: value)
            }
        }

        self.init(statusCode: response.statusCode, url: response.url, headers: headers)
    }

    /// The value of a header field, matched case-insensitively.
    public func value(forHTTPHeaderField field: String) -> String? {
        headers[field.lowercased()]
    }

    /// The delay from the `Retry-After` header, if present. Supports both the
    /// delay-seconds and HTTP-date forms; the HTTP-date form is converted to a
    /// delay relative to now.
    public var retryAfter: TimeInterval? {
        guard let value = value(forHTTPHeaderField: "Retry-After") else {
            return nil
        }

        if let seconds = TimeInterval(value) {
            return max(0, seconds)
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "GMT")
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"

        if let date = formatter.date(from: value) {
            return max(0, date.timeIntervalSinceNow)
        }

        return nil
    }
}

public struct DexcomError: Codable, Error, Sendable {
    public var code: ErrorCode?
    public var message: String?

    /// The HTTP response that carried this error, including the status code
    /// and headers such as `Retry-After`.
    public var httpResponse: DexcomHTTPResponse? = nil

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

    /// The HTTP response that failed to decode, including the status code
    /// and headers such as `Retry-After`.
    public var httpResponse: DexcomHTTPResponse?

    init(error: any Error, body: Data, response: URLResponse) {
        self.errorDescription = String(describing: error)
        self.body = body
        self.httpResponse = DexcomHTTPResponse(response: response)
        self.statusCode = httpResponse?.statusCode
        self.url = response.url
    }
}
