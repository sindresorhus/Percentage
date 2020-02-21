import XCTest
@testable import Percentage

final class PercentageTests: XCTestCase {
	func testPercentage() {
		XCTAssertEqual(10%, 10%)
		XCTAssertEqual(-10% / 2, -5%)
		XCTAssertEqual(1.1%.rawValue, 1.1)
		XCTAssertEqual(10% + 5.5%, 15.5%)
		XCTAssertEqual((40% + 93%) * 3, 399%)
		XCTAssertEqual(50%.of(200), 100)
		XCTAssertEqual(Percentage(50.5), 50.5%)
		XCTAssertEqual(Percentage(rawValue: 50.5), 50.5%)

		let int = 50
		XCTAssertEqual(Percentage(int), 50%)

		let int8: Int8 = 50
		XCTAssertEqual(Percentage(int8), 50%)

		let cgFloat: CGFloat = 50.5
		XCTAssertEqual(Percentage(cgFloat), 50.5%)

		let float: Float = 50.5
		XCTAssertEqual(Percentage(float), 50.5%)

		XCTAssertEqual(Percentage(fraction: 0.5), 50%)
		XCTAssertEqual(50%.fraction, 0.5)

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
			let alpha: Percentage
		}

		let foo = Foo(alpha: 1%)
		let data = try! JSONEncoder().encode(foo)
		let string = String(data: data, encoding: .utf8)!

		XCTAssertEqual(string, "{\"alpha\":1}")
	}

	func testStringConversion() {
		let formatter = NumberFormatter()
		formatter.numberStyle = .percent

		formatter.locale = Locale(identifier: "ru")
		Percentage.formatter = formatter
		XCTAssertEqual("\(50%)", formatter.string(for: 50%.fraction))
		XCTAssertEqual("\(1%)", formatter.string(for: 1%.fraction))

		formatter.locale = Locale(identifier: "tr")
		Percentage.formatter = formatter
		XCTAssertEqual("\(50%)", formatter.string(for: 50%.fraction))
		XCTAssertEqual("\(1%)", formatter.string(for: 1%.fraction))

		formatter.locale = Locale(identifier: "eu")
		Percentage.formatter = formatter
		XCTAssertEqual("\(50%)", formatter.string(for: 50%.fraction))
		XCTAssertEqual("\(1%)", formatter.string(for: 1%.fraction))

		formatter.locale = Locale(identifier: "ar")
		Percentage.formatter = formatter
		XCTAssertEqual("\(50%)", formatter.string(for: 50%.fraction))
		XCTAssertEqual("\(1%)", formatter.string(for: 1%.fraction))

		formatter.locale = Locale.current
		Percentage.formatter = formatter
	}
}
