import XCTest
@testable import Dexcom

final class GlucoseFormatterTests: XCTestCase {
    func test_mgdl() throws {
        XCTAssertEqual(100.0.formatted(.glucose(.mgdl)), "100")
        XCTAssertEqual(100.9.formatted(.glucose(.mgdl)), "101")
    }

    func test_mmolL() throws {
        XCTAssertEqual(100.0.formatted(.glucose(.mmolL)), "5.6")
        XCTAssertEqual(100.9.formatted(.glucose(.mmolL)), "5.6")
    }
}
