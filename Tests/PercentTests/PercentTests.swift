import XCTest
@testable import Percent

final class PercentTests: XCTestCase {
	func testPercent() {
		XCTAssertEqual(10%, 10%)
		XCTAssertEqual(-10% / 2, -5%)
		XCTAssertEqual(1.1%.rawValue, 1.1)
		XCTAssertEqual("\(1%)", "1%")
		XCTAssertEqual(10% + 5.5%, 15.5%)
		XCTAssertEqual((40% + 93%) * 3, 399%)
		XCTAssertEqual(50%.of(200), 100)
		XCTAssertEqual(Percent(50.5), 50.5%)
		XCTAssertEqual(Percent(rawValue: 50.5), 50.5%)

		let int = 50
		XCTAssertEqual(Percent(int), 50%)

		let cgFloat: CGFloat = 50.5
		XCTAssertEqual(Percent(cgFloat), 50.5%)

		XCTAssertEqual(Percent(fraction: 0.5), 50%)
		XCTAssertEqual(50%.fraction, 0.5)
		XCTAssertEqual("\(50%)", "50%")

		XCTAssertTrue(30% > 25%)
	}

	func testArithmetics() {
		XCTAssertEqual(1% + 1%, 2%)
		XCTAssertEqual(1% - 1%, 0%)
		XCTAssertEqual(1% * 2%, 2%)
		XCTAssertEqual(1% / 2%, 0.5%)
	}

	func testArithmeticsDouble() {
		XCTAssertEqual(1% + 1, 2%)
		XCTAssertEqual(1% - 1, 0%)
		XCTAssertEqual(1% * 2, 2%)
		XCTAssertEqual(1% / 2, 0.5%)
	}

	func testArithmeticsMutating() {
		var plus = 1%
		plus += 1%
		XCTAssertEqual(plus, 2%)

		var minus = 1%
		minus -= 1%
		XCTAssertEqual(minus, 0%)

		var multiply = 1%
		multiply *= 2%
		XCTAssertEqual(multiply, 2%)

		var divide = 1%
		divide /= 2%
		XCTAssertEqual(divide, 0.5%)
	}

	func testArithmeticsMutatingDouble() {
		var plus = 1%
		plus += 1
		XCTAssertEqual(plus, 2%)

		var minus = 1%
		minus -= 1
		XCTAssertEqual(minus, 0%)

		var multiply = 1%
		multiply *= 2
		XCTAssertEqual(multiply, 2%)

		var divide = 1%
		divide /= 2
		XCTAssertEqual(divide, 0.5%)
	}

	func testCodable() {
		struct Foo: Codable {
			let alpha: Percent
		}

		let foo = Foo(alpha: 1%)
		let data = try! JSONEncoder().encode(foo)
		let string = String(data: data, encoding: .utf8)!

		XCTAssertEqual(string, "{\"alpha\":1}")
	}
}
