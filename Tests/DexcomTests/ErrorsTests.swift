import XCTest
@testable import Dexcom
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class ErrorsTests: XCTestCase {
    func test_headerLookupIsCaseInsensitive() {
        let response = DexcomHTTPResponse(
            statusCode: 429,
            headers: ["Retry-After": "60", "X-Request-ID": "abc"]
        )

        XCTAssertEqual(response.value(forHTTPHeaderField: "retry-after"), "60")
        XCTAssertEqual(response.value(forHTTPHeaderField: "RETRY-AFTER"), "60")
        XCTAssertEqual(response.value(forHTTPHeaderField: "x-request-id"), "abc")
        XCTAssertNil(response.value(forHTTPHeaderField: "missing"))
    }

    func test_retryAfterSeconds() {
        let response = DexcomHTTPResponse(statusCode: 429, headers: ["Retry-After": "120"])
        XCTAssertEqual(response.retryAfter, 120)
    }

    func test_retryAfterHTTPDate() throws {
        let future = Date().addingTimeInterval(300)

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "GMT")
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"

        let response = DexcomHTTPResponse(
            statusCode: 429,
            headers: ["Retry-After": formatter.string(from: future)]
        )

        let retryAfter = try XCTUnwrap(response.retryAfter)
        XCTAssertGreaterThan(retryAfter, 290)
        XCTAssertLessThanOrEqual(retryAfter, 300)
    }

    func test_retryAfterPastDateClampsToZero() throws {
        let response = DexcomHTTPResponse(
            statusCode: 429,
            headers: ["Retry-After": "Wed, 01 Jan 2020 00:00:00 GMT"]
        )

        XCTAssertEqual(try XCTUnwrap(response.retryAfter), 0)
    }

    func test_retryAfterMissingOrInvalid() {
        XCTAssertNil(DexcomHTTPResponse(statusCode: 500).retryAfter)
        XCTAssertNil(
            DexcomHTTPResponse(statusCode: 429, headers: ["Retry-After": "soon"]).retryAfter
        )
    }

    func test_initFromHTTPURLResponse() throws {
        let url = try XCTUnwrap(URL(string: "https://share2.dexcom.com/ShareWebServices/Services"))
        let urlResponse = try XCTUnwrap(
            HTTPURLResponse(
                url: url,
                statusCode: 429,
                httpVersion: "HTTP/1.1",
                headerFields: ["Retry-After": "30"]
            )
        )

        let response = try XCTUnwrap(DexcomHTTPResponse(response: urlResponse))
        XCTAssertEqual(response.statusCode, 429)
        XCTAssertEqual(response.url, url)
        XCTAssertEqual(response.retryAfter, 30)
    }

    func test_initFromNonHTTPResponse() throws {
        let url = try XCTUnwrap(URL(string: "https://share2.dexcom.com"))
        let urlResponse = URLResponse(
            url: url,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )

        XCTAssertNil(DexcomHTTPResponse(response: urlResponse))
    }

    func test_dexcomErrorDecodingIgnoresHTTPResponse() throws {
        let json = Data(#"{"Code": "SessionNotValid", "Message": "Session ID is invalid"}"#.utf8)
        var error = try JSONDecoder().decode(DexcomError.self, from: json)

        XCTAssertEqual(error.code, .sessionNotValid)
        XCTAssertEqual(error.message, "Session ID is invalid")
        XCTAssertNil(error.httpResponse)

        error.httpResponse = DexcomHTTPResponse(statusCode: 401)
        XCTAssertEqual(error.httpResponse?.statusCode, 401)
    }
}
