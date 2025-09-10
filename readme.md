# Percentage

> A percentage type for Swift

Makes percentages more readable and type-safe, for example, for APIs that currently accept a fraction `Double`.

```diff
-.opacity(0.45)
+.opacity(45%)
```

## Install

Add the following to `Package.swift`:

```swift
.package(url: "https://github.com/sindresorhus/Percentage", from: "1.2.0")
```

[Or add the package in Xcode.](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)

## Usage

See the [source](Sources/Percentage/Percentage.swift) for docs.

```swift
import Percentage

10% + 5.5%
//=> 15.5%

-10% / 2
//=> -5%

(40% + 93%) * 3
//=> 399%

50% * 50%
//=> 25%

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

print("\(1%)")
//=> "1%"

Percent.random(in: 10%...20%)
//=> "14.3%"
```

The type conforms to `Hashable`, `Codable`, `RawRepresentable`, `Comparable`, `ExpressibleByFloatLiteral`, `ExpressibleByIntegerLiteral`, `Numeric`, and supports all the arithmetic operators.

### Codable

The percentage value is encoded as a single value:

```swift
struct Foo: Codable {
	let alpha: Percentage
}

let foo = Foo(alpha: 1%)
let data = try! JSONEncoder().encode(foo)
let string = String(data: data, encoding: .utf8)!

print(string)
//=> "{\"alpha\":1}"
```

## FAQ

#### Can you support Carthage and CocoaPods?

No, but you can still use Swift Package Manager for this package even though you mainly use Carthage or CocoaPods.

## Related

- [Defaults](https://github.com/sindresorhus/Defaults) - Swifty and modern UserDefaults
- [KeyboardShortcuts](https://github.com/sindresorhus/KeyboardShortcuts) - Add user-customizable global keyboard shortcuts to your macOS app
- [LaunchAtLogin](https://github.com/sindresorhus/LaunchAtLogin) - Add "Launch at Login" functionality to your macOS app
- [More…](https://github.com/search?q=user%3Asindresorhus+language%3Aswift+archived%3Afalse&type=repositories)
