import Foundation
import CoreGraphics

/**
```
import Percent

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

Percent(50)
//=> 50%

Percent(fraction: 0.5)
//=> 50%

50%.fraction
//=> 0.5

10%.rawValue
//=> 10

print("\(1%)")
//=> "1%"
```
*/
public struct Percent: Hashable, Codable {
	/**
	The raw percent number.

	```
	10%.rawValue
	//=> 10
	```
	*/
	public let rawValue: Double

	/**
	Get the percent as a fraction.

	```
	50%.fraction
	//=> 0.5
	```
	*/
	public var fraction: Double { rawValue / 100 }

	/**
	Create a `Percent` from a `Double`.

	```
	Percent(50.5)
	//=> 50.5%
	```
	*/
	public init(_ percent: Double) {
		self.rawValue = percent
	}

	/**
	Create a `Percent` from a `CGFloat`.

	```
	let cgFloat: CGFloat = 50.5
	Percent(cgFloat)
	//=> 50.5%
	```
	*/
	public init(_ percent: CGFloat) {
		self.rawValue = Double(percent)
	}

	/**
	Create a `Percent` from an `Int`.

	```
	let int = 50
	Percent(int)
	//=> 50%
	```
	*/
	public init(_ percent: Int) {
		self.rawValue = Double(percent)
	}

	/**
	Create a `Percent` from a fraction.

	```
	Percent(fraction: 0.5)
	//=> "50%"
	```
	*/
	public init(fraction: Double) {
		self.rawValue = fraction * 100
	}

	/**
	Returns how much the percent of the given value is.

	```
	50%.of(200)
	//=> 100
	```
	*/
	public func of(_ value: Double) -> Double { value * rawValue / 100 }
}

extension Percent: RawRepresentable {
	public init(rawValue: Double) {
		self.rawValue = rawValue
	}
}

extension Percent: Comparable {
	public static func < (lhs: Self, rhs: Self) -> Bool {
		lhs.rawValue < rhs.rawValue
	}
}

extension Percent: CustomStringConvertible {
	internal static var formatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .percent
		return formatter
	}()

	public var description: String {
		Self.formatter.string(for: fraction) ?? "\(String(format: "%g", rawValue))%"
	}
}

// swiftlint:disable static_operator
prefix operator -

public prefix func - (percent: Percent) -> Percent {
	return Percent(-percent.rawValue)
}

postfix operator %

public postfix func % (value: Double) -> Percent {
	return Percent(value)
}

public postfix func % (value: Int) -> Percent {
	return Percent(Double(value))
}
// swiftlint:enable static_operator

extension Percent {
	public static func + (lhs: Self, rhs: Self) -> Self {
		Self(lhs.rawValue + rhs.rawValue)
	}

	public static func + (lhs: Self, rhs: Double) -> Self {
		Self(lhs.rawValue + rhs)
	}

	public static func - (lhs: Self, rhs: Self) -> Self {
		Self(lhs.rawValue - rhs.rawValue)
	}

	public static func - (lhs: Self, rhs: Double) -> Self {
		Self(lhs.rawValue - rhs)
	}

	public static func * (lhs: Self, rhs: Self) -> Self {
		Self(lhs.rawValue * rhs.rawValue)
	}

	public static func * (lhs: Self, rhs: Double) -> Self {
		Self(lhs.rawValue * rhs)
	}

	public static func / (lhs: Self, rhs: Self) -> Self {
		Self(lhs.rawValue / rhs.rawValue)
	}

	public static func / (lhs: Self, rhs: Double) -> Self {
		Self(lhs.rawValue / rhs)
	}

	// swiftlint:disable shorthand_operator
	public static func += (lhs: inout Self, rhs: Self) {
		lhs = lhs + rhs
	}

	public static func += (lhs: inout Self, rhs: Double) {
		lhs = lhs + rhs
	}

	public static func -= (lhs: inout Self, rhs: Self) {
		lhs = lhs - rhs
	}

	public static func -= (lhs: inout Self, rhs: Double) {
		lhs = lhs - rhs
	}

	public static func *= (lhs: inout Self, rhs: Self) {
		lhs = lhs * rhs
	}

	public static func *= (lhs: inout Self, rhs: Double) {
		lhs = lhs * rhs
	}

	public static func /= (lhs: inout Self, rhs: Self) {
		lhs = lhs / rhs
	}

	public static func /= (lhs: inout Self, rhs: Double) {
		lhs = lhs / rhs
	}
	// swiftlint:enable shorthand_operator
}
