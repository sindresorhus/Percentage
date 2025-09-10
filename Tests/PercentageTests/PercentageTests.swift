import XCTest
@testable import Percentage

final class PercentageTests: XCTestCase {
	func testPercentage() {
		XCTAssertEqual(10%, 10%)
//		XCTAssertEqual(-10% / 2, -5%)
		XCTAssertEqual(1.1%.rawValue, 1.1)
		XCTAssertEqual(10% + 5.5%, 15.5%)
//		XCTAssertEqual((40% + 93%) * 3, 399%)
		XCTAssertEqual(50% * 50%, 25%)
		XCTAssertEqual(50% / 50%, 100%)
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

	func testClampedZeroToHundred() {
		XCTAssertEqual(101%.clampedZeroToHundred, 100%)
		XCTAssertEqual((-1%).clampedZeroToHundred, 0%)
		XCTAssertEqual(40%.clampedZeroToHundred, 40%)
	}

	func testPercentageOf() {
		XCTAssertEqual(50%.of(200), 100)
		XCTAssertEqual(50%.of(201), 100)
		XCTAssertEqual(50%.of(201) as Double, 100.5)
		XCTAssertEqual(50%.of(250.5), 125.25)
		XCTAssertEqual(25%.of(Float64(200)), Float64(50))
	}

	func testArithmetics() {
		XCTAssertEqual(1% + 1%, 2%)
		XCTAssertEqual(1% - 1%, 0%)
//		XCTAssertEqual(20% * 10%, 2%, accuracy: .ulpOfOne)
		XCTAssertEqual(20% / 10%, 200%)
	}

	func testArithmeticsDouble() {
		XCTAssertEqual(1% + 1, 2%)
		XCTAssertEqual(1% - 1, 0%)
//		XCTAssertEqual(1% * 2, 2%)
//		XCTAssertEqual(1% / 2, 0.5%)
	}

	func testArithmeticsMutating() {
		var plus = 1%
		plus += 1%
		XCTAssertEqual(plus, 2%)

		var minus = 1%
		minus -= 1%
		XCTAssertEqual(minus, 0%)

//		var multiply = 20%
//		multiply *= 10%
//		XCTAssertEqual(multiply, 2%, accuracy: .ulpOfOne)

		var divide = 20%
		divide /= 10%
		XCTAssertEqual(divide, 200%)
	}

	func testArithmeticsMutatingDouble() {
		var plus = 1%
		plus += 1
		XCTAssertEqual(plus, 2%)

		var minus = 1%
		minus -= 1
		XCTAssertEqual(minus, 0%)

//		var multiply = 20%
//		multiply *= 10
//		XCTAssertEqual(multiply, 2%, accuracy: .ulpOfOne)

		var divide = 20%
		divide /= 10
		XCTAssertEqual(divide, 200%)
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

	func testRandom() {
		let range = 10%...20%
		let random = Percentage.random(in: range)
		XCTAssertTrue(range.contains(random))
	}

	func testPercentageFrom() {
		// Test: Percent.from(100, of: 200) //=> 50%
		XCTAssertEqual(Percentage.from(100, of: 200), 50%)
		XCTAssertEqual(Percentage.from(50, of: 100), 50%)
		XCTAssertEqual(Percentage.from(25, of: 50), 50%)
		XCTAssertEqual(Percentage.from(75, of: 300), 25%)
		XCTAssertEqual(Percentage.from(0, of: 100), 0%)
		XCTAssertEqual(Percentage.from(100, of: 100), 100%)
		XCTAssertEqual(Percentage.from(150, of: 100), 150%)
		
		// Test with floating point values
		XCTAssertEqual(Percentage.from(50.5, of: 101), 50%)
		XCTAssertEqual(Percentage.from(12.5, of: 50.0), 25%)
	}

	func testOriginalValueBeforeIncrease() {
		// If a value is 120 after a 40% increase, what is the original value?
		// Formula: original = final / (1 + percentage)
		// 120 / 1.4 = 85.71428...
		XCTAssertEqual(40%.originalValueBeforeIncrease(finalValue: 120), 85.71428571428571, accuracy: 0.00001)
		XCTAssertEqual(50%.originalValueBeforeIncrease(finalValue: 150), 100.0, accuracy: 0.00001)
		XCTAssertEqual(100%.originalValueBeforeIncrease(finalValue: 200), 100.0, accuracy: 0.00001)
		XCTAssertEqual(0%.originalValueBeforeIncrease(finalValue: 100), 100.0, accuracy: 0.00001)
		XCTAssertEqual(25%.originalValueBeforeIncrease(finalValue: 125), 100.0, accuracy: 0.00001)
	}

	func testOriginalValueBeforeDecrease() {
		// If a value is 106 after a 12% decrease, what is the original value?
		// Formula: original = final / (1 - percentage)
		// 106 / 0.88 = 120.45454...
		XCTAssertEqual(12%.originalValueBeforeDecrease(finalValue: 106), 120.45454545454545, accuracy: 0.00001)
		XCTAssertEqual(50%.originalValueBeforeDecrease(finalValue: 50), 100.0, accuracy: 0.00001)
		XCTAssertEqual(20%.originalValueBeforeDecrease(finalValue: 80), 100.0, accuracy: 0.00001)
		XCTAssertEqual(0%.originalValueBeforeDecrease(finalValue: 100), 100.0, accuracy: 0.00001)
		XCTAssertEqual(25%.originalValueBeforeDecrease(finalValue: 75), 100.0, accuracy: 0.00001)
	}

	func testIsPercentOf() {
		// "x IS y% OF what?" - 67 is 90% of what?
		// Formula: result = value / percentage
		// 67 / 0.9 = 74.44444...
		XCTAssertEqual(90%.isPercentOf(67), 74.44444444444444, accuracy: 0.00001)
		XCTAssertEqual(50%.isPercentOf(50), 100.0, accuracy: 0.00001)
		XCTAssertEqual(100%.isPercentOf(100), 100.0, accuracy: 0.00001)
		XCTAssertEqual(25%.isPercentOf(25), 100.0, accuracy: 0.00001)
		XCTAssertEqual(200%.isPercentOf(200), 100.0, accuracy: 0.00001)
	}

	func testIsWithinStandardRange() {
		XCTAssertTrue(0%.isWithinStandardRange)
		XCTAssertTrue(50%.isWithinStandardRange)
		XCTAssertTrue(100%.isWithinStandardRange)
		XCTAssertFalse((-1%).isWithinStandardRange)
		XCTAssertFalse(101%.isWithinStandardRange)
		XCTAssertFalse(150%.isWithinStandardRange)
		XCTAssertFalse((-50%).isWithinStandardRange)
	}

	func testClampedToRange() {
		XCTAssertEqual(50%.clamped(to: 0%...100%), 50%)
		XCTAssertEqual(150%.clamped(to: 0%...100%), 100%)
		XCTAssertEqual((-50%).clamped(to: 0%...100%), 0%)
		XCTAssertEqual(75%.clamped(to: 0%...100%), 75%)
		
		// Custom ranges
		XCTAssertEqual(50%.clamped(to: 25%...75%), 50%)
		XCTAssertEqual(20%.clamped(to: 25%...75%), 25%)
		XCTAssertEqual(80%.clamped(to: 25%...75%), 75%)
		XCTAssertEqual((-10%).clamped(to: (-20%)...20%), -10%)
	}

	func testPercentageChange() {
		// Percentage.change(from: 100, to: 150) //=> 50%
		XCTAssertEqual(Percentage.change(from: 100, to: 150), 50%)
		XCTAssertEqual(Percentage.change(from: 150, to: 100).rawValue, -33.333333333333336, accuracy: 0.00001)
		XCTAssertEqual(Percentage.change(from: 100, to: 100), 0%)
		XCTAssertEqual(Percentage.change(from: 50, to: 75), 50%)
		XCTAssertEqual(Percentage.change(from: 200, to: 100), -50%)
		XCTAssertEqual(Percentage.change(from: 100, to: 0), -100%)
		XCTAssertEqual(Percentage.change(from: 100, to: 200), 100%)
		
		// Floating point values
		XCTAssertEqual(Percentage.change(from: 100.0, to: 150.0), 50%)
		XCTAssertEqual(Percentage.change(from: 50.5, to: 75.75), 50%)
		
		// Edge case: from 0
		XCTAssertTrue(Percentage.change(from: 0, to: 100).rawValue.isInfinite)
		XCTAssertEqual(Percentage.change(from: 0, to: 0), 0%)
	}

	func testNumericExtensionsInteger() {
		// Integer types - using explicit Int type to avoid ambiguity with Percentage literals
		let hundred: Int = 100
		XCTAssertEqual(hundred.increased(by: 20%), 120)
		XCTAssertEqual(hundred.decreased(by: 20%), 80)
		
		let fifty: Int = 50
		XCTAssertEqual(fifty.increased(by: 100%), 100)
		XCTAssertEqual(fifty.decreased(by: 50%), 25)
		
		let twoHundred: Int = 200
		XCTAssertEqual(twoHundred.increased(by: 0%), 200)
		XCTAssertEqual(twoHundred.decreased(by: 0%), 200)
		
		// Negative percentages
		XCTAssertEqual(hundred.increased(by: Percentage(-20)), 80)
		XCTAssertEqual(hundred.decreased(by: Percentage(-20)), 120)
		
		// Large percentages
		XCTAssertEqual(hundred.increased(by: 200%), 300)
		XCTAssertEqual(hundred.decreased(by: 100%), 0)
		
		// Test with Int8, Int16, etc.
		let int8: Int8 = 50
		XCTAssertEqual(int8.increased(by: 20%), 60)
		XCTAssertEqual(int8.decreased(by: 20%), 40)
		
		let int16: Int16 = 100
		XCTAssertEqual(int16.increased(by: 50%), 150)
		XCTAssertEqual(int16.decreased(by: 25%), 75)
	}

	func testNumericExtensionsFloatingPoint() {
		// Floating point types
		XCTAssertEqual(100.0.increased(by: 20%), 120.0, accuracy: 0.00001)
		XCTAssertEqual(100.0.decreased(by: 20%), 80.0, accuracy: 0.00001)
		XCTAssertEqual(50.5.increased(by: 100%), 101.0, accuracy: 0.00001)
		XCTAssertEqual(50.5.decreased(by: 50%), 25.25, accuracy: 0.00001)
		
		// CGFloat
		let cgFloat: CGFloat = 100.0
		XCTAssertEqual(cgFloat.increased(by: 25%), 125.0, accuracy: 0.00001)
		XCTAssertEqual(cgFloat.decreased(by: 10%), 90.0, accuracy: 0.00001)
		
		// Float
		let float: Float = 200.0
		XCTAssertEqual(float.increased(by: 15%), 230.0, accuracy: 0.00001)
		XCTAssertEqual(float.decreased(by: 30%), 140.0, accuracy: 0.00001)
	}

	func testFormatting() {
		// Basic formatting
		XCTAssertEqual(33.333%.formatted(decimalPlaces: 1), "33.3%")
		XCTAssertEqual(33.333%.formatted(decimalPlaces: 0), "33%")
		XCTAssertEqual(33.333%.formatted(decimalPlaces: 2), "33.33%")
		XCTAssertEqual(33.336%.formatted(decimalPlaces: 2), "33.34%")
		XCTAssertEqual(50%.formatted(decimalPlaces: 0), "50%")
		XCTAssertEqual(50%.formatted(decimalPlaces: 2), "50.00%")
		
		// Negative percentages
		XCTAssertEqual((-33.333%).formatted(decimalPlaces: 1), "-33.3%")
		XCTAssertEqual((-50%).formatted(decimalPlaces: 0), "-50%")
		
		// Large percentages
		XCTAssertEqual(150%.formatted(decimalPlaces: 0), "150%")
		XCTAssertEqual(1234.567%.formatted(decimalPlaces: 1), "1234.6%")
		
		// Edge cases
		XCTAssertEqual(0%.formatted(decimalPlaces: 0), "0%")
		XCTAssertEqual(0.004%.formatted(decimalPlaces: 2), "0.00%")
		XCTAssertEqual(0.005%.formatted(decimalPlaces: 2), "0.00%") // Rounding: 0.005% = 0.00005 as fraction, rounds down
	}

	@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
	func testFormattedWithFormatStyle() {
		// Test with FormatStyle
		let percent1 = 33.333%
		let formatted1 = percent1.formatted(.percent.precision(.fractionLength(1)).locale(Locale(identifier: "en_US")))
		XCTAssertEqual(formatted1, "33.3%")
		
		let percent2 = 50%
		let formatted2 = percent2.formatted(.percent.precision(.fractionLength(0)).locale(Locale(identifier: "en_US")))
		XCTAssertEqual(formatted2, "50%")
		
		let percent3 = 0.5%
		let formatted3 = percent3.formatted(.percent.precision(.fractionLength(2)).locale(Locale(identifier: "en_US")))
		XCTAssertEqual(formatted3, "0.50%")
		
		// Test locale-specific formatting
		let percent4 = 50%
		let formatted4 = percent4.formatted(.percent.locale(Locale(identifier: "fr_FR")))
		XCTAssertTrue(formatted4.contains("50")) // French uses different formatting
	}
}
