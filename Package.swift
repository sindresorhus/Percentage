// swift-tools-version:5.1
import PackageDescription

let package = Package(
	name: "Percent",
	products: [
		.library(
			name: "Percent",
			targets: [
				"Percent"
			]
		),
	],
	targets: [
		.target(
			name: "Percent"
		),
		.testTarget(
			name: "PercentTests",
			dependencies: [
				"Percent"
			]
		)
	]
)
