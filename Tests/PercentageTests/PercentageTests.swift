import Testing
import Foundation
import CoreGraphics
@testable import Percentage

struct PercentageTests {
	@Test
	func percentage() {
		#expect(10% == 10%) // swiftlint:disable:this identical_operands
		#expect(1.1%.rawValue == 1.1)
		#expect(10% + 5.5% == 15.5%)
		#expect(10% * 2 == 20%)
		#expect(-10% / 2 == -5%)
		#expect(50%.of(200) == 100)
		#expect(Percentage(50.5) == 50.5%)
		#expect(Percentage(rawValue: 50.5) == 50.5%)

		let int = 50
		#expect(Percentage(int) == 50%)

		let int8: Int8 = 50
		#expect(Percentage(int8) == 50%)

		let cgFloat: CGFloat = 50.5
		#expect(Percentage(cgFloat) == 50.5%)

		let float: Float = 50.5
		#expect(Percentage(float) == 50.5%)

		#expect(Percentage(fraction: 0.5) == 50%)
		#expect(50%.fraction == 0.5)

		#expect(30% > 25%)
	}

	@Test
	func clampedZeroToHundred() {
		#expect(101%.clampedZeroToHundred == 100%)
		#expect((-1%).clampedZeroToHundred == 0%)
		#expect(40%.clampedZeroToHundred == 40%)
	}

	@Test
	func percentageOf() {
		#expect(50%.of(200) == 100)
		#expect(50%.of(201) == 100)
		#expect(50%.of(201) as Double == 100.5)
		#expect(50%.of(250.5) == 125.25)
		#expect(25%.of(Float64(200)) == Float64(50))
	}

	@Test
	func arithmetics() {
		#expect(1% + 1% == 2%)
		#expect(1% - 1% == 0%)
		#expect(50% * 50% == 25%)
		#expect(20% / 10% == 200%)
	}

	@Test
	func arithmeticsDouble() {
		#expect(1% + 1 == 2%)
		#expect(1% - 1 == 0%)
	}

	@Test
	func arithmeticsMutating() {
		var plus = 1%
		plus += 1%
		#expect(plus == 2%)

		var minus = 1%
		minus -= 1%
		#expect(minus == 0%)

		var divide = 20%
		divide /= 10%
		#expect(divide == 200%)
	}

	@Test
	func arithmeticsMutatingDouble() {
		var plus = 1%
		plus += 1
		#expect(plus == 2%)

		var minus = 1%
		minus -= 1
		#expect(minus == 0%)

		var divide = 20%
		divide /= 10
		#expect(divide == 2%)
	}

	@Test
	func scalarMultiplication() {
		#expect(10% * 2 == 20%)
		#expect(3 * 50% == 150%)
		#expect((40% + 93%) * 3 == 399%)

		// Double scalar
		#expect(10% * 2.5 == 25%)
		#expect(2.5 * 10% == 25%)

		// Typed Int variable
		let intScalar: Int = 3
		#expect(10% * intScalar == 30%)
		#expect(intScalar * 10% == 30%)

		// Typed Double variable
		let doubleScalar: Double = 2.5
		#expect(10% * doubleScalar == 25%)
		#expect(doubleScalar * 10% == 25%)

		// Other BinaryInteger types
		let int8Scalar: Int8 = 4
		#expect(10% * int8Scalar == 40%)
		#expect(int8Scalar * 10% == 40%)

		// Other BinaryFloatingPoint types
		let floatScalar: Float = 3.0
		#expect(10% * floatScalar == 30%)
		#expect(floatScalar * 10% == 30%)

		let cgFloatScalar: CGFloat = 2.0
		#expect(10% * cgFloatScalar == 20%)
		#expect(cgFloatScalar * 10% == 20%)
	}

	@Test
	func scalarDivision() {
		#expect(-10% / 2 == -5%)
		#expect(100% / 4 == 25%)
		#expect(75% / 2.5 == 30%)

		// Typed Int variable
		let intScalar: Int = 4
		#expect(100% / intScalar == 25%)

		// Typed Double variable
		let doubleScalar: Double = 2.5
		#expect(75% / doubleScalar == 30%)

		// Other BinaryInteger types
		let int8Scalar: Int8 = 2
		#expect(50% / int8Scalar == 25%)

		// Other BinaryFloatingPoint types
		let floatScalar: Float = 4.0
		#expect(100% / floatScalar == 25%)
	}

	@Test
	func scalarCompoundAssignment() {
		var value = 10%
		value *= 3
		#expect(value == 30%)

		value = 10%
		let intScalar: Int = 5
		value *= intScalar
		#expect(value == 50%)

		value = 10%
		let doubleScalar: Double = 2.5
		value *= doubleScalar
		#expect(value == 25%)

		value = 10%
		let int8Scalar: Int8 = 3
		value *= int8Scalar
		#expect(value == 30%)

		value = 100%
		value /= 4
		#expect(value == 25%)

		value = 100%
		value /= intScalar
		#expect(value == 20%)

		value = 75%
		value /= doubleScalar
		#expect(value == 30%)

		value = 90%
		value /= int8Scalar
		#expect(value == 30%)
	}

	@Test
	func percentOperatorWithFloatingPoint() {
		let cgFloat: CGFloat = 25.0
		#expect(cgFloat% == 25%)
	}

	@Test
	func codable() {
		struct Foo: Codable {
			let alpha: Percentage
		}

		let foo = Foo(alpha: 1%)
		let data = try! JSONEncoder().encode(foo)
		let string = String(data: data, encoding: .utf8)!

		#expect(string == "{\"alpha\":1}")
	}

	@Test
	func random() {
		let range = 10%...20%
		let random = Percentage.random(in: range)
		#expect(range.contains(random))
	}

	@Test
	func percentageFrom() {
		// Test: Percent.from(100, of: 200) //=> 50%
		#expect(Percentage.from(100, of: 200) == 50%)
		#expect(Percentage.from(50, of: 100) == 50%)
		#expect(Percentage.from(25, of: 50) == 50%)
		#expect(Percentage.from(75, of: 300) == 25%)
		#expect(Percentage.from(0, of: 100) == 0%)
		#expect(Percentage.from(100, of: 100) == 100%)
		#expect(Percentage.from(150, of: 100) == 150%)

		// Test with floating point values
		#expect(Percentage.from(50.5, of: 101) == 50%)
		#expect(Percentage.from(12.5, of: 50.0) == 25%)
	}

	@Test
	func originalValueBeforeIncrease() {
		// If a value is 120 after a 40% increase, what is the original value?
		// Formula: original = final / (1 + percentage)
		// 120 / 1.4 = 85.71428...
		#expect(abs(40%.originalValueBeforeIncrease(finalValue: 120) - 85.71428571428571) < 0.00001)
		#expect(abs(50%.originalValueBeforeIncrease(finalValue: 150) - 100.0) < 0.00001)
		#expect(abs(100%.originalValueBeforeIncrease(finalValue: 200) - 100.0) < 0.00001)
		#expect(abs(0%.originalValueBeforeIncrease(finalValue: 100) - 100.0) < 0.00001)
		#expect(abs(25%.originalValueBeforeIncrease(finalValue: 125) - 100.0) < 0.00001)
	}

	@Test
	func originalValueBeforeDecrease() {
		// If a value is 106 after a 12% decrease, what is the original value?
		// Formula: original = final / (1 - percentage)
		// 106 / 0.88 = 120.45454...
		#expect(abs(12%.originalValueBeforeDecrease(finalValue: 106) - 120.45454545454545) < 0.00001)
		#expect(abs(50%.originalValueBeforeDecrease(finalValue: 50) - 100.0) < 0.00001)
		#expect(abs(20%.originalValueBeforeDecrease(finalValue: 80) - 100.0) < 0.00001)
		#expect(abs(0%.originalValueBeforeDecrease(finalValue: 100) - 100.0) < 0.00001)
		#expect(abs(25%.originalValueBeforeDecrease(finalValue: 75) - 100.0) < 0.00001)
	}

	@Test
	func isPercentOf() {
		// "x IS y% OF what?" - 67 is 90% of what?
		// Formula: result = value / percentage
		// 67 / 0.9 = 74.44444...
		#expect(abs(90%.isPercentOf(67) - 74.44444444444444) < 0.00001)
		#expect(abs(50%.isPercentOf(50) - 100.0) < 0.00001)
		#expect(abs(100%.isPercentOf(100) - 100.0) < 0.00001)
		#expect(abs(25%.isPercentOf(25) - 100.0) < 0.00001)
		#expect(abs(200%.isPercentOf(200) - 100.0) < 0.00001)
	}

	@Test
	func isWithinStandardRange() {
		#expect(0%.isWithinStandardRange)
		#expect(50%.isWithinStandardRange)
		#expect(100%.isWithinStandardRange)
		#expect(!(-1%).isWithinStandardRange)
		#expect(!101%.isWithinStandardRange)
		#expect(!150%.isWithinStandardRange)
		#expect(!(-50%).isWithinStandardRange)
	}

	@Test
	func clampedToRange() {
		#expect(50%.clamped(to: 0%...100%) == 50%)
		#expect(150%.clamped(to: 0%...100%) == 100%)
		#expect((-50%).clamped(to: 0%...100%) == 0%)
		#expect(75%.clamped(to: 0%...100%) == 75%)

		// Custom ranges
		#expect(50%.clamped(to: 25%...75%) == 50%)
		#expect(20%.clamped(to: 25%...75%) == 25%)
		#expect(80%.clamped(to: 25%...75%) == 75%)
		#expect((-10%).clamped(to: (-20%)...20%) == -10%)
	}

	@Test
	func percentageChange() {
		// Percentage.change(from: 100, to: 150) //=> 50%
		#expect(Percentage.change(from: 100, to: 150) == 50%)
		#expect(abs(Percentage.change(from: 150, to: 100).rawValue - (-33.333333333333336)) < 0.00001)
		#expect(Percentage.change(from: 100, to: 100) == 0%)
		#expect(Percentage.change(from: 50, to: 75) == 50%)
		#expect(Percentage.change(from: 200, to: 100) == -50%)
		#expect(Percentage.change(from: 100, to: 0) == -100%)
		#expect(Percentage.change(from: 100, to: 200) == 100%)

		// Floating point values
		#expect(Percentage.change(from: 100.0, to: 150.0) == 50%)
		#expect(Percentage.change(from: 50.5, to: 75.75) == 50%)

		// Edge case: from 0
		#expect(Percentage.change(from: 0, to: 100).rawValue.isInfinite)
		#expect(Percentage.change(from: 0, to: 0) == 0%)
	}

	@Test(.disabled("Infinite recursion in Swift Testing framework"))
	func
	numericExtensionsInteger() {
		// Integer types - using explicit Int type to avoid ambiguity with Percentage literals
		let hundred: Int = 100
		let twentyPercent = Percentage(20)
		#expect(hundred.increased(by: twentyPercent) == 120)
		#expect(hundred.decreased(by: twentyPercent) == 80)

		let fifty: Int = 50
		let oneHundredPercent = Percentage(100)
		let fiftyPercent = Percentage(50)
		#expect(fifty.increased(by: oneHundredPercent) == 100)
		#expect(fifty.decreased(by: fiftyPercent) == 25)

		let twoHundred: Int = 200
		let zeroPercent = Percentage(0)
		#expect(twoHundred.increased(by: zeroPercent) == 200)
		#expect(twoHundred.decreased(by: zeroPercent) == 200)

		// Negative percentages
		#expect(hundred.increased(by: Percentage(-20)) == 80)
		#expect(hundred.decreased(by: Percentage(-20)) == 120)

		// Large percentages
		#expect(hundred.increased(by: Percentage(200)) == 300)
		#expect(hundred.decreased(by: Percentage(100)) == 0)

		// Test with Int8, Int16, etc.
		let int8: Int8 = 50
		#expect(int8.increased(by: Percentage(20)) == 60)
		#expect(int8.decreased(by: Percentage(20)) == 40)

		let int16: Int16 = 100
		#expect(int16.increased(by: Percentage(50)) == 150)
		#expect(int16.decreased(by: Percentage(25)) == 75)
	}

	@Test
	func numericExtensionsFloatingPoint() {
		// Floating point types
		#expect(abs(100.0.increased(by: 20%) - 120.0) < 0.00001)
		#expect(abs(100.0.decreased(by: 20%) - 80.0) < 0.00001)
		#expect(abs(50.5.increased(by: 100%) - 101.0) < 0.00001)
		#expect(abs(50.5.decreased(by: 50%) - 25.25) < 0.00001)

		// CGFloat
		let cgFloat: CGFloat = 100.0
		#expect(abs(cgFloat.increased(by: 25%) - 125.0) < 0.00001)
		#expect(abs(cgFloat.decreased(by: 10%) - 90.0) < 0.00001)

		// Float
		let float: Float = 200.0
		#expect(abs(Float(float.increased(by: 15%)) - 230.0) < 0.00001)
		#expect(abs(Float(float.decreased(by: 30%)) - 140.0) < 0.00001)
	}

	@Test
	func formatting() {
		if #available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
			// Basic formatting - use US locale for consistent testing
			let usLocale = Locale(identifier: "en_US")
			#expect(33.333%.formatted(decimalPlaces: 1, locale: usLocale) == "33.3%")
			#expect(33.333%.formatted(decimalPlaces: 0, locale: usLocale) == "33%")
			#expect(33.333%.formatted(decimalPlaces: 2, locale: usLocale) == "33.33%")
			#expect(33.336%.formatted(decimalPlaces: 2, locale: usLocale) == "33.34%")
			#expect(50%.formatted(decimalPlaces: 0, locale: usLocale) == "50%")
			#expect(50%.formatted(decimalPlaces: 2, locale: usLocale) == "50.00%")

			// Negative percentages
			#expect((-33.333%).formatted(decimalPlaces: 1, locale: usLocale) == "-33.3%")
			#expect((-50%).formatted(decimalPlaces: 0, locale: usLocale) == "-50%")

			// Large percentages - note: modern formatter uses grouping separator
			#expect(150%.formatted(decimalPlaces: 0, locale: usLocale) == "150%")
			#expect(1234.567%.formatted(decimalPlaces: 1, locale: usLocale) == "1,234.6%")

			// Edge cases
			#expect(0%.formatted(decimalPlaces: 0, locale: usLocale) == "0%")
			#expect(0.004%.formatted(decimalPlaces: 2, locale: usLocale) == "0.00%")
			#expect(0.005%.formatted(decimalPlaces: 2, locale: usLocale) == "0.00%") // Rounding: 0.005% = 0.00005 as fraction, rounds down

			// Test that it respects locale
			let frLocale = Locale(identifier: "fr_FR")
			let formattedFr = 50.5%.formatted(decimalPlaces: 1, locale: frLocale)
			#expect(formattedFr.contains("50")) // French formatting may differ

			// Test default locale (current)
			let defaultFormatted = 50%.formatted(decimalPlaces: 0)
			#expect(!defaultFormatted.isEmpty)
		} else {
			// Test legacy formatting for older OS versions
			let usLocale = Locale(identifier: "en_US")
			#expect(33.333%.formatted(decimalPlaces: 1, locale: usLocale) == "33.3%")
			#expect(50%.formatted(decimalPlaces: 0, locale: usLocale) == "50%")
		}
	}

	@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
	@Test
	func formattedWithFormatStyle() {
		// Test with FormatStyle using modern locale API
		let usLocale = Locale(identifier: "en_US")

		let percent1 = 33.333%
		let formatted1 = percent1.formatted(.percent.precision(.fractionLength(1)).locale(usLocale))
		#expect(formatted1 == "33.3%")

		let percent2 = 50%
		let formatted2 = percent2.formatted(.percent.precision(.fractionLength(0)).locale(usLocale))
		#expect(formatted2 == "50%")

		let percent3 = 0.5%
		let formatted3 = percent3.formatted(.percent.precision(.fractionLength(2)).locale(usLocale))
		#expect(formatted3 == "0.50%")

		// Test locale-specific formatting
		let frLocale = Locale(identifier: "fr_FR")
		let percent4 = 50%
		let formatted4 = percent4.formatted(.percent.locale(frLocale))
		#expect(formatted4.contains("50")) // French uses different formatting

		// Test using the formatted extension method directly
		let percent5 = 75.5%
		let formatted5 = percent5.formatted(.percent.precision(.fractionLength(1)))
		#expect(!formatted5.isEmpty)
	}

	// MARK: - Additional comprehensive tests

	@Test
	func originalValueBeforeIncreaseWithIntegers() {
		// Test BinaryInteger overload
		#expect(abs(40%.originalValueBeforeIncrease(finalValue: 140) - 100.0) < 0.00001)
		#expect(abs(25%.originalValueBeforeIncrease(finalValue: 125) - 100.0) < 0.00001)
		#expect(abs(100%.originalValueBeforeIncrease(finalValue: 200) - 100.0) < 0.00001)
	}

	@Test
	func originalValueBeforeDecreaseWithIntegers() {
		// Test BinaryInteger overload
		#expect(abs(20%.originalValueBeforeDecrease(finalValue: 80) - 100.0) < 0.00001)
		#expect(abs(50%.originalValueBeforeDecrease(finalValue: 50) - 100.0) < 0.00001)
		#expect(abs(25%.originalValueBeforeDecrease(finalValue: 75) - 100.0) < 0.00001)
	}

	@Test
	func isPercentOfWithIntegers() {
		// Test BinaryInteger overload
		#expect(abs(50%.isPercentOf(50) - 100.0) < 0.00001)
		#expect(abs(25%.isPercentOf(25) - 100.0) < 0.00001)
		#expect(abs(90%.isPercentOf(90) - 100.0) < 0.00001)
	}

	@Test
	func percentageFromFloatingPoint() {
		// Test BinaryFloatingPoint overload
		#expect(Percentage.from(50.5, of: 101.0) == 50%)
		#expect(Percentage.from(25.25, of: 101.0) == 25%)
		#expect(abs(Percentage.from(33.333, of: 99.999).rawValue - 33.333333333333336) < 0.00001)
	}

	@Test
	func percentageChangeWithIntegers() {
		// Test BinaryInteger overload specifically
		#expect(Percentage.change(from: 100, to: 150) == 50%)
		#expect(Percentage.change(from: 50, to: 75) == 50%)
		#expect(Percentage.change(from: 200, to: 100) == -50%)
	}

	@Test
	func description() {
		// Test the description property
		let fifty = 50%
		let description = fifty.description
		#expect(description.contains("50"))
		#expect(description.contains("%"))

		let decimal = 33.5%
		let decimalDescription = decimal.description
		#expect(decimalDescription.contains("33"))
		#expect(decimalDescription.contains("%"))
	}

	@Test
	func comparableProtocol() {
		// Test Comparable conformance thoroughly
		#expect(10% < 20%)
		#expect(50% > 25%)
		#expect(100% >= 100%) // swiftlint:disable:this identical_operands
		#expect(0% <= 0%) // swiftlint:disable:this identical_operands
		#expect(!(50% < 25%))
		#expect(!(25% > 50%))

		// Test with negative percentages
		#expect((-10%) < 10%)
		#expect(10% > (-10%))
		#expect((-50%) < (-25%))
	}

	@Test
	func arithmeticOperators() {
		// Test all arithmetic operators comprehensively
		#expect(50% + 25% == 75%)
		#expect(75% - 25% == 50%)
		#expect(50% * 2 == 100%)
		#expect(100% / 2 == 50%)

		// Test with zero
		#expect(50% + 0% == 50%)
		#expect(50% - 0% == 50%)
		#expect(50% * 0% == 0%)
		#expect(50% * 50% == 25%)

		// Test negative arithmetic
		#expect(50% + (-25%) == 25%)
		#expect(50% - (-25%) == 75%)
	}

	@Test
	func edgeCases() {
		// Test edge cases and boundary conditions

		// Very large percentages
		let large = Percentage(1_000_000)
		#expect(large.rawValue == 1_000_000)

		// Very small percentages
		let tiny = Percentage(0.0001)
		#expect(tiny.rawValue == 0.0001)

		// Negative percentages
		let negative = Percentage(-50)
		#expect(negative.rawValue == -50)
		#expect(!negative.isWithinStandardRange)

		// Test percentage of zero
		#expect(50%.of(0) == 0)
		#expect(100%.of(0) == 0)

		// Test zero percentage
		let zero = Percentage(0)
		#expect(zero.of(100) == 0)
		#expect(zero.of(250.5) == 0.0)
	}

	@Test
	func fractionProperty() {
		// Test fraction property specifically
		#expect(0%.fraction == 0.0)
		#expect(50%.fraction == 0.5)
		#expect(100%.fraction == 1.0)
		#expect(200%.fraction == 2.0)
		#expect((-50%).fraction == -0.5)

		// Test with decimal percentages
		#expect(25.5%.fraction == 0.255)
		#expect(abs(33.333%.fraction - 0.33333) < 0.00001)
	}

	@Test
	func protocolConformances() {
		// Test Hashable conformance
		let p1 = 50%
		let p2 = 50%
		let p3 = 75%

		#expect(p1.hashValue == p2.hashValue)
		#expect(p1.hashValue != p3.hashValue)

		// Test that equal percentages are hashable-equal
		let set: Set = [p1, p2, p3]
		#expect(set.count == 2) // p1 and p2 should be considered equal
	}

	@Test
	func literalConformances() {
		// Test ExpressibleByIntegerLiteral
		let intLiteral: Percentage = 50
		#expect(intLiteral.rawValue == 50)

		// Test ExpressibleByFloatLiteral
		let floatLiteral: Percentage = 50.5
		#expect(floatLiteral.rawValue == 50.5)

		// Test that percentage literals work
		let percentLiteral = 50%
		#expect(percentLiteral.rawValue == 50)
	}

	@Test
	func numericProtocolConformance() {
		// Test Numeric protocol conformance
		#expect(Percentage.zero == 0%)

		var mutable = 50%
		mutable += 25%
		#expect(mutable == 75%)

		mutable -= 25%
		#expect(mutable == 50%)

		mutable *= 2
		#expect(mutable == 100%)

		// Test magnitude
		#expect(50%.magnitude == 50.0)
		#expect((-50%).magnitude == 50.0)
	}
}
