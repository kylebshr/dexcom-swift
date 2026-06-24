import XCTest
@testable import Dexcom

final class GlucoseFormatterTests: XCTestCase {
    func test_mgdl() throws {
        XCTAssertEqual(100.formatted(.glucose(.mgdl)), "100")
        XCTAssertEqual(101.formatted(.glucose(.mgdl)), "101")
    }

    func test_mmolL() throws {
        XCTAssertEqual(100.formatted(.glucose(.mmolL)), "5.6")
        XCTAssertEqual(101.formatted(.glucose(.mmolL)), "5.6")
    }

    func test_low() throws {
        XCTAssertEqual(39.formatted(.glucose(.mgdl)), "Low")
        XCTAssertEqual(39.formatted(.glucose(.mmolL)), "Low")
        // Anything at or below the low sentinel is still "Low".
        XCTAssertEqual(38.formatted(.glucose(.mgdl)), "Low")
        // 40 is the lowest real reading and should format normally.
        XCTAssertEqual(40.formatted(.glucose(.mgdl)), "40")
    }

    func test_high() throws {
        XCTAssertEqual(401.formatted(.glucose(.mgdl)), "Hi")
        XCTAssertEqual(401.formatted(.glucose(.mmolL)), "Hi")
        // Anything at or above the high sentinel is still "Hi".
        XCTAssertEqual(402.formatted(.glucose(.mgdl)), "Hi")
        // 400 is the highest real reading and should format normally.
        XCTAssertEqual(400.formatted(.glucose(.mgdl)), "400")
    }
}
