#!/usr/bin/env swift

import Foundation

/// Code coverage information gathered by Xcode.
struct CodeCoverage: Decodable {
	/// Percentage of lines covered with tests.
	let lineCoverage: Double
	/// Number of lines of lines covered with tests.
	let coveredLines: Int
	/// Number of executable lines.
	let executableLines: Int
}

let coverageFileName = CommandLine.arguments[1]
guard let minimumCoverageValue = Double(CommandLine.arguments[2]) else {
	printError("Invalid argument. Minimum coverage value needs to be a number.")
	exit(-1)
}
let fileManager = FileManager.default

if !fileManager.fileExists(atPath: coverageFileName) {
	printError("File `\(coverageFileName)` does not exist.")
	exit(-1)
}

guard let codeCoverageData = fileManager.contents(atPath: coverageFileName) else {
	printError("Couldn't read content of file `\(coverageFileName)`")
	exit(-1)
}

do {
	let information = try JSONDecoder().decode(CodeCoverage.self, from: codeCoverageData)

	guard information.executableLines > 0 else {
		print("\033[0;32mNo code line to cover.\033[0m")
		exit(0)
	}

	let lineCoveragePercentage = information.lineCoverage * 100

	if lineCoveragePercentage >= minimumCoverageValue {
		print(String(format: "Code coverage is %.2f%", lineCoveragePercentage).inGreen)
		exit(0)
	} else {
		printError(String(format: "Code coverage is %.2f% is less than required %.2f%", lineCoveragePercentage, minimumCoverageValue).inRed)
		exit(-1)
	}
} catch {
	printError("Error opening file at `\(coverageFileName)\n \(error)`")
	exit(-1)
}

// MARK: - Utils

private func printError(_ message: String) {
	print(message.inRed)
}

private extension String {
	var inGreen: String {
		"\u{001B}[0;32m\(self)"
	}
	var inRed: String {
		"\u{001B}[0;31m\(self)"
	}
}
