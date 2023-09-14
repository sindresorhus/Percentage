// swift-tools-version:5.9
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
