// swift-tools-version:4.0
// Generated automatically by Perfect Assistant
// Date: 2018-08-23 09:11:37 +0000
import PackageDescription

let package = Package(
	name: "GSON",
	products: [
		.library(name: "GSON", targets: ["GSON"])
	],
	dependencies: [
		.package(url: "https://github.com/PerfectlySoft/PerfectLib.git", "3.0.0"..<"4.0.0")
	],
	targets: [
		.target(name: "GSON", dependencies: ["PerfectLib"]),
		.testTarget(name: "GSONTests", dependencies: ["GSON"])
	]
)
