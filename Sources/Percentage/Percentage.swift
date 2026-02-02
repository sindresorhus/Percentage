import Foundation

/**
```
import Percentage

10% + 5.5%
//=> 15.5%

-10% / 2
//=> -5%

(40% + 93%) * 3
//=> 399%

30% > 25%
//=> true

50%.of(200)
//=> 100

Percentage(50)
//=> 50%

Percentage(fraction: 0.5)
//=> 50%

Percentage.from(100, of: 200)
//=> 50%

Percentage.change(from: 100, to: 150)
//=> 50%

50%.fraction
//=> 0.5

10%.rawValue
//=> 10

50%.isWithinStandardRange
//=> true

150%.clamped(to: 0%...100%)
//=> 100%

110%.clampedZeroToHundred
//=> 100%

100.increased(by: 20%)
//=> 120

100.decreased(by: 20%)
//=> 80

40%.originalValueBeforeIncrease(finalValue: 120)
//=> 85.71428571428571

12%.originalValueBeforeDecrease(finalValue: 106)
//=> 120.45454545454545

90%.isPercentOf(67)
//=> 74.44444444444444

33.333%.formatted(decimalPlaces: 1)
//=> "33.3%"

// With locale (macOS 12.0+/iOS 15.0+)
50%.formatted(decimalPlaces: 1, locale: Locale(languageCode: .french))
//=> "50,0 %"

print("\(1%)")
//=> "1%"

Percentage.random(in: 10%...20%)
//=> "14.3%"
```
*/
public struct Percentage: Hashable, Codable, Sendable {
	/**
	The raw percentage number.

	```
	10%.rawValue
	//=> 10
	```
	*/
	public let rawValue: Double

	/**
	Get the percentage as a fraction.

	```
	50%.fraction
	//=> 0.5
	```
	*/
	public var fraction: Double { rawValue / 100 }

	/**
	Clamp the percentage to a value between 0% and 100%.

	```
	110%.clampedZeroToHundred
	//=> 100%

	-1%.clampedZeroToHundred
	//=> 0%

	60%.clampedZeroToHundred
	//=> 60%
	```
	*/
	public var clampedZeroToHundred: Self {
		if rawValue > 100 {
			100%
		} else if rawValue < 0 {
			0%
		} else {
			self
		}
	}

	/**
	Check if the percentage is within the standard 0-100% range.

	```
	50%.isWithinStandardRange
	//=> true

	150%.isWithinStandardRange
	//=> false

	(-10%).isWithinStandardRange
	//=> false
	```
	*/
	public var isWithinStandardRange: Bool {
		rawValue >= 0 && rawValue <= 100
	}

	/**
	Create a `Percentage` from a `BinaryFloatingPoint`, for example, `Double` or `CGFloat`.

	```
	let cgFloat: CGFloat = 50.5
	Percentage(cgFloat)
	//=> 50.5%
	```
	*/
	public init(_ percentage: some BinaryFloatingPoint) {
		self.init(rawValue: Double(percentage))
	}

	/**
	Create a `Percentage` from a `BinaryInteger`, for example, `Int`.

	```
	let int = 50
	Percentage(int)
	//=> 50%
	```
	*/
	public init(_ percentage: some BinaryInteger) {
		self.init(rawValue: Double(percentage))
	}

	/**
	Create a `Percentage` from a fraction.

	```
	Percentage(fraction: 0.5)
	//=> "50%"
	```
	*/
	public init(fraction: Double) {
		self.init(rawValue: fraction * 100)
	}

	/**
	Returns how much the percentage of the given integer value is.

	```
	50%.of(200)
	//=> 100
	```
	*/
	public func of<Value: BinaryInteger>(_ value: Value) -> Value {
		value * Value(rawValue.rounded()) / 100
	}

	/**
	Returns how much the percentage of the given integer value is exactly, represented as floating-point.

	```
	50%.of(201) as Double
	//=> 100.5
	```
	*/
	public func of<ReturnValue: BinaryFloatingPoint>(
		_ value: some BinaryInteger
	) -> ReturnValue {
		ReturnValue(value) * ReturnValue(rawValue) / 100
	}

	/**
	Returns how much the percentage of the given floating-point value is.

	```
	50%.of(250.5)
	//=> 125.25
	```
	*/
	public func of<Value: BinaryFloatingPoint>(_ value: Value) -> Value {
		value * Value(rawValue) / 100
	}
}

extension Percentage {
	/**
	Returns a random value within the given range.

	```
	Percentage.random(in: 10%...20%)
	//=> Can be 10%, 11%, 12%, 19.98%, etc.
	```
	*/
	public static func random(in range: ClosedRange<Self>) -> Self {
		self.init(fraction: .random(in: range.lowerBound.fraction...range.upperBound.fraction))
	}

	/**
	Create a `Percentage` from a value and a total.

	```
	Percentage.from(100, of: 200)
	//=> 50%

	Percentage.from(75, of: 300)
	//=> 25%
	```
	*/
	public static func from(
		_ value: some BinaryInteger,
		of total: some BinaryInteger
	) -> Self {
		guard total != 0 else {
			return self.init(0)
		}

		return self.init(Double(value) / Double(total) * 100)
	}

	/**
	Create a `Percentage` from a value and a total.

	```
	Percentage.from(50.5, of: 101)
	//=> 50%

	Percentage.from(12.5, of: 50.0)
	//=> 25%
	```
	*/
	public static func from(
		_ value: some BinaryFloatingPoint,
		of total: some BinaryFloatingPoint
	) -> Self {
		guard total != 0 else {
			return self.init(0)
		}

		return self.init(Double(value) / Double(total) * 100)
	}

	/**
	Find the original value before a percentage increase.

	For example, if a value is 120 after a 40% increase, this returns the original value (85.714...).

	```
	40%.originalValueBeforeIncrease(finalValue: 120)
	//=> 85.714...

	50%.originalValueBeforeIncrease(finalValue: 150)
	//=> 100
	```
	*/
	public func originalValueBeforeIncrease(
		finalValue: some BinaryFloatingPoint
	) -> Double {
		Double(finalValue) / (1 + fraction)
	}

	/**
	Find the original value before a percentage increase.

	For example, if a value is 120 after a 40% increase, this returns the original value (85.714...).

	```
	40%.originalValueBeforeIncrease(finalValue: 120)
	//=> 85.714...

	50%.originalValueBeforeIncrease(finalValue: 150)
	//=> 100
	```
	*/
	public func originalValueBeforeIncrease(
		finalValue: some BinaryInteger
	) -> Double {
		Double(finalValue) / (1 + fraction)
	}

	/**
	Find the original value before a percentage decrease.

	For example, if a value is 106 after a 12% decrease, this returns the original value (120.454...).

	```
	12%.originalValueBeforeDecrease(finalValue: 106)
	//=> 120.454...

	20%.originalValueBeforeDecrease(finalValue: 80)
	//=> 100
	```
	*/
	public func originalValueBeforeDecrease(
		finalValue: some BinaryFloatingPoint
	) -> Double {
		guard fraction < 1 else {
			// Cannot have a decrease of 100% or more
			return .infinity
		}

		return Double(finalValue) / (1 - fraction)
	}

	/**
	Find the original value before a percentage decrease.

	For example, if a value is 106 after a 12% decrease, this returns the original value (120.454...).

	```
	12%.originalValueBeforeDecrease(finalValue: 106)
	//=> 120.454...

	20%.originalValueBeforeDecrease(finalValue: 80)
	//=> 100
	```
	*/
	public func originalValueBeforeDecrease(
		finalValue: some BinaryInteger
	) -> Double {
		guard fraction < 1 else {
			// Cannot have a decrease of 100% or more
			return .infinity
		}

		return Double(finalValue) / (1 - fraction)
	}

	/**
	Find what value this percentage is of.

	For example, "67 is 90% of what?" returns 74.444...

	```
	90%.isPercentOf(67)
	//=> 74.444...

	50%.isPercentOf(50)
	//=> 100
	```
	*/
	public func isPercentOf(_ value: some BinaryFloatingPoint) -> Double {
		guard fraction != 0 else {
			return .infinity
		}

		return Double(value) / fraction
	}

	/**
	Find what value this percentage is of.

	For example, "67 is 90% of what?" returns 74.444...

	```
	90%.isPercentOf(67)
	//=> 74.444...

	50%.isPercentOf(50)
	//=> 100
	```
	*/
	public func isPercentOf(_ value: some BinaryInteger) -> Double {
		guard fraction != 0 else {
			return .infinity
		}

		return Double(value) / fraction
	}

	/**
	Clamp the percentage to a specific range.

	```
	150%.clamped(to: 0%...100%)
	//=> 100%

	(-50%).clamped(to: 0%...100%)
	//=> 0%

	50%.clamped(to: 25%...75%)
	//=> 50%
	```
	*/
	public func clamped(to range: ClosedRange<Self>) -> Self {
		if self < range.lowerBound {
			return range.lowerBound
		} else if self > range.upperBound {
			return range.upperBound
		} else {
			return self
		}
	}

	/**
	Calculate the percentage change between two values.

	```
	Percentage.change(from: 100, to: 150)
	//=> 50%

	Percentage.change(from: 150, to: 100)
	//=> -33.33%

	Percentage.change(from: 100, to: 200)
	//=> 100%
	```
	*/
	public static func change<T: BinaryInteger>(
		from originalValue: T,
		to newValue: T
	) -> Self {
		guard originalValue != 0 else {
			if newValue == 0 {
				return self.init(0)
			}

			return self.init(Double.infinity)
		}

		let change = Double(Int(newValue) - Int(originalValue)) / Double(originalValue) * 100
		return self.init(change)
	}

	/**
	Calculate the percentage change between two values.

	```
	Percentage.change(from: 100.0, to: 150.0)
	//=> 50%

	Percentage.change(from: 50.5, to: 75.75)
	//=> 50%
	```
	*/
	public static func change(
		from originalValue: some BinaryFloatingPoint,
		to newValue: some BinaryFloatingPoint
	) -> Self {
		guard originalValue != 0 else {
			if newValue == 0 {
				return self.init(0)
			}
			return self.init(Double.infinity)
		}

		let change = (Double(newValue) - Double(originalValue)) / Double(originalValue) * 100
		return self.init(change)
	}

	/**
	Format the percentage with a specific number of decimal places.

	```
	33.333%.formatted(decimalPlaces: 1)
	//=> "33.3%"

	33.333%.formatted(decimalPlaces: 0)
	//=> "33%"

	50%.formatted(decimalPlaces: 2)
	//=> "50.00%"

	// With specific locale (macOS 12.0+/iOS 15.0+)
	50.5%.formatted(decimalPlaces: 1, locale: Locale(languageCode: .french))
	//=> "50,5 %" (French formatting)
	```
	*/
	public func formatted(decimalPlaces: Int, locale: Locale = .current) -> String {
		if #available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
			return fraction.formatted(
				.percent
					.precision(.fractionLength(decimalPlaces))
					.locale(locale)
			)
		} else {
			// Fallback for older OS versions
			let formatter = NumberFormatter()
			formatter.numberStyle = .percent
			formatter.minimumFractionDigits = decimalPlaces
			formatter.maximumFractionDigits = decimalPlaces
			formatter.locale = locale
			return formatter.string(for: fraction) ?? "\(String(format: "%g", rawValue))%"
		}
	}
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension Percentage {
	/**
	Format the percentage using a FormatStyle.

	```
	33.333%.formatted(.percent.precision(.fractionLength(1)))
	//=> "33.3%"

	50%.formatted(.percent.precision(.fractionLength(0)))
	//=> "50%"
	```
	*/
	public func formatted<F: FormatStyle>(
		_ style: F
	) -> F.FormatOutput where F.FormatInput == Double {
		style.format(fraction)
	}
}

extension BinaryInteger {
	/**
	Increase the value by a percentage.

	```
	100.increased(by: 20%)
	//=> 120

	50.increased(by: 100%)
	//=> 100
	```
	*/
	public func increased(by percentage: Percentage) -> Self {
		self + percentage.of(self)
	}

	/**
	Decrease the value by a percentage.

	```
	100.decreased(by: 20%)
	//=> 80

	50.decreased(by: 50%)
	//=> 25
	```
	*/
	public func decreased(by percentage: Percentage) -> Self {
		self - percentage.of(self)
	}
}

extension BinaryFloatingPoint {
	/**
	Increase the value by a percentage.

	```
	100.0.increased(by: 20%)
	//=> 120.0

	50.5.increased(by: 100%)
	//=> 101.0
	```
	*/
	public func increased(by percentage: Percentage) -> Self {
		self + percentage.of(self)
	}

	/**
	Decrease the value by a percentage.

	```
	100.0.decreased(by: 20%)
	//=> 80.0

	50.5.decreased(by: 50%)
	//=> 25.25
	```
	*/
	public func decreased(by percentage: Percentage) -> Self {
		self - percentage.of(self)
	}
}

extension Percentage: RawRepresentable {
	public init(rawValue: Double) {
		self.rawValue = rawValue
	}
}

extension Percentage: Comparable {
	public static func < (lhs: Self, rhs: Self) -> Bool {
		lhs.rawValue < rhs.rawValue
	}
}

extension Percentage: CustomStringConvertible {
	public var description: String {
		formatted(decimalPlaces: 2)
	}
}

// swiftlint:disable static_operator
prefix operator -

public prefix func - (percentage: Percentage) -> Percentage {
	Percentage(-percentage.rawValue)
}

postfix operator %

public postfix func % (value: Int) -> Percentage {
	Percentage(Double(value))
}

public postfix func % (value: some BinaryFloatingPoint) -> Percentage {
	Percentage(Double(value))
}
// swiftlint:enable static_operator

extension Percentage: ExpressibleByFloatLiteral {
	@_disfavoredOverload
	public init(floatLiteral value: Double) {
		self.init(rawValue: value)
	}
}

extension Percentage: ExpressibleByIntegerLiteral {
	@_disfavoredOverload
	public init(integerLiteral value: Double) {
		self.init(rawValue: value)
	}
}

extension Percentage: Numeric {
	public typealias Magnitude = Double.Magnitude

	public static var zero: Self { 0 }

	public static func + (lhs: Self, rhs: Self) -> Self {
		self.init(lhs.rawValue + rhs.rawValue)
	}

	public static func += (lhs: inout Self, rhs: Self) {
		lhs = lhs + rhs
	}

	public static func - (lhs: Self, rhs: Self) -> Self {
		self.init(lhs.rawValue - rhs.rawValue)
	}

	public static func -= (lhs: inout Self, rhs: Self) {
		lhs = lhs - rhs
	}

	// Uses fraction multiplication for percent-to-percent math.
	@_disfavoredOverload
	public static func * (lhs: Self, rhs: Self) -> Self {
		self.init(fraction: lhs.fraction * rhs.fraction)
	}

	@_disfavoredOverload
	public static func *= (lhs: inout Self, rhs: Self) {
		lhs = lhs * rhs
	}

	public var magnitude: Magnitude { rawValue.magnitude }

	public init?(exactly source: some BinaryInteger) {
		guard let value = Double(exactly: source) else {
			return nil
		}

		self.init(value)
	}
}

extension Percentage {
	public static func * (lhs: Self, rhs: Int) -> Self {
		self.init(lhs.rawValue * Double(rhs))
	}

	public static func * (lhs: Int, rhs: Self) -> Self {
		self.init(Double(lhs) * rhs.rawValue)
	}

	public static func * (lhs: Self, rhs: Double) -> Self {
		self.init(lhs.rawValue * rhs)
	}

	public static func * (lhs: Double, rhs: Self) -> Self {
		self.init(lhs * rhs.rawValue)
	}

	public static func * (lhs: Self, rhs: some BinaryInteger) -> Self {
		self.init(lhs.rawValue * Double(rhs))
	}

	public static func * (lhs: some BinaryInteger, rhs: Self) -> Self {
		self.init(Double(lhs) * rhs.rawValue)
	}

	public static func * (lhs: Self, rhs: some BinaryFloatingPoint) -> Self {
		self.init(lhs.rawValue * Double(rhs))
	}

	public static func * (lhs: some BinaryFloatingPoint, rhs: Self) -> Self {
		self.init(Double(lhs) * rhs.rawValue)
	}

	public static func *= (lhs: inout Self, rhs: Int) {
		lhs = lhs * rhs
	}

	public static func *= (lhs: inout Self, rhs: Double) {
		lhs = lhs * rhs
	}

	public static func *= (lhs: inout Self, rhs: some BinaryInteger) {
		lhs = lhs * rhs
	}

	public static func *= (lhs: inout Self, rhs: some BinaryFloatingPoint) {
		lhs = lhs * rhs
	}

	@_disfavoredOverload
	public static func / (lhs: Self, rhs: Self) -> Self {
		self.init(fraction: lhs.fraction / rhs.fraction)
	}

	@_disfavoredOverload
	public static func /= (lhs: inout Self, rhs: Self) {
		lhs = lhs / rhs
	}

	public static func / (lhs: Self, rhs: Int) -> Self {
		self.init(lhs.rawValue / Double(rhs))
	}

	public static func / (lhs: Self, rhs: Double) -> Self {
		self.init(lhs.rawValue / rhs)
	}

	public static func / (lhs: Self, rhs: some BinaryInteger) -> Self {
		self.init(lhs.rawValue / Double(rhs))
	}

	public static func / (lhs: Self, rhs: some BinaryFloatingPoint) -> Self {
		self.init(lhs.rawValue / Double(rhs))
	}

	public static func /= (lhs: inout Self, rhs: Int) {
		lhs = lhs / rhs
	}

	public static func /= (lhs: inout Self, rhs: Double) {
		lhs = lhs / rhs
	}

	public static func /= (lhs: inout Self, rhs: some BinaryInteger) {
		lhs = lhs / rhs
	}

	public static func /= (lhs: inout Self, rhs: some BinaryFloatingPoint) {
		lhs = lhs / rhs
	}
}

#if canImport(SwiftUI)
import SwiftUI

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension View {
	/**
	Sets the transparency of this view.

	```
	Text("Hello")
		.opacity(45%)
	```
	*/
	@inlinable
	public func opacity(_ percentage: Percentage) -> some View {
		opacity(percentage.fraction)
	}

	/**
	Brightens this view by the given percentage.

	```
	Text("Hello")
		.brightness(20%)
	```
	*/
	@inlinable
	public func brightness(_ percentage: Percentage) -> some View {
		brightness(percentage.fraction)
	}

	/**
	Sets the contrast for this view.

	```
	Text("Hello")
		.contrast(80%)
	```
	*/
	@inlinable
	public func contrast(_ percentage: Percentage) -> some View {
		contrast(percentage.fraction)
	}

	/**
	Adjusts the color saturation of this view.

	```
	Text("Hello")
		.saturation(50%)
	```
	*/
	@inlinable
	public func saturation(_ percentage: Percentage) -> some View {
		saturation(percentage.fraction)
	}

	/**
	Adds a grayscale effect to this view.

	```
	Text("Hello")
		.grayscale(100%)
	```
	*/
	@inlinable
	public func grayscale(_ percentage: Percentage) -> some View {
		grayscale(percentage.fraction)
	}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Color {
	/**
	Multiplies the opacity of the color by the given percentage.

	```
	Color.red.opacity(50%)
	```
	*/
	@inlinable
	public func opacity(_ percentage: Percentage) -> Color {
		opacity(percentage.fraction)
	}
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension ShapeStyle {
	/**
	Multiplies the opacity of the shape style by the given percentage.

	```
	Rectangle()
		.fill(.red.opacity(50%))
	```
	*/
	@inlinable
	public func opacity(_ percentage: Percentage) -> some ShapeStyle {
		opacity(percentage.fraction)
	}
}
#endif

#if canImport(UIKit)
import UIKit

extension UIColor {
	/**
	Creates a new color with the given alpha component as a percentage.

	```
	UIColor.red.withAlphaComponent(50%)
	```
	*/
	@inlinable
	public func withAlphaComponent(_ percentage: Percentage) -> UIColor {
		withAlphaComponent(percentage.fraction)
	}
}
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension NSColor {
	/**
	Creates a new color with the given alpha component as a percentage.

	```
	NSColor.red.withAlphaComponent(50%)
	```
	*/
	@inlinable
	public func withAlphaComponent(_ percentage: Percentage) -> NSColor {
		withAlphaComponent(percentage.fraction)
	}
}
#endif
