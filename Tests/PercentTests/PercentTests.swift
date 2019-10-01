import XCTest
@testable import Percent

final class PercentTests: XCTestCase {
	func testPercent() {
		XCTAssertEqual(10%, 10%)
		XCTAssertEqual(1.1%.rawValue, 1.1)
		XCTAssertEqual(10% + 5.5%, 15.5%)
		XCTAssertEqual((40% + 93%) * 3, 399%)
		XCTAssertEqual(50%.of(200), 100)
		XCTAssertEqual(Percent(50.5), 50.5%)

		let int = 50
		XCTAssertEqual(Percent(int), 50%)

		let cgFloat: CGFloat = 50.5
		XCTAssertEqual(Percent(cgFloat), 50.5%)

		XCTAssertEqual(Percent(fraction: 0.5), 50%)
		XCTAssertEqual(50%.fraction, 0.5)
		XCTAssertEqual("\(50%)", "50%")
	}
}
