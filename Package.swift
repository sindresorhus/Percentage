// swift-tools-version:6.1
import PackageDescription

let package = Package(
	name: "Percentage",
	products: [
		.library(
			name: "Percentage",
			targets: [
				"Percentage"
			]
		)
	],
	targets: [
		.target(
			name: "Percentage"
		),
		.testTarget(
			name: "PercentageTests",
			dependencies: [
				"Percentage"
			]
		)
	]
)
