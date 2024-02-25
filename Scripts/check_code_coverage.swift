#!/usr/bin/env swift

import Foundation

// Run
checkCodeCoverage()

// MARK: - Types

struct Target: Decodable, CustomStringConvertible {
    let name: String
    let lineCoverage: Double

    var description: String {
        "\(name)        |       \(String(format: "%.2f%%", lineCoverage * 100))"
    }
}

/// Code coverage information gathered by Xcode.
struct CodeCoverage: Decodable, CustomStringConvertible {
	/// Number of lines of lines covered with tests.
	let coveredLines: Int
	/// Number of executable lines.
    let executableLines: Int
    /// Analyzed targets.
	let targets: [Target]
    /// Percentage of lines covered with tests.
    private let lineCoverage: Double

    var coveragePercentage: Double {
        lineCoverage * 100
    }

    var description: String {
        String(format: "Code coverage is %.2f%%", coveragePercentage) + " (targets: \(targets.map(\.name).joined(separator: " ,")))"
    }

    var targetsDescription: String {
        """
        ------------------------------
        | COVERAGE BY TARGET         |
        ------------------------------
        \(targets.map(\.description).joined(separator: "\n"))
        ------------------------------
        """
    }
}

struct Arguments {
    /// Path to the json file with coverage data.
    let pathToCoverageFile: String
    /// Minimum required coverage for the check to pass.
    let requiredCoverage: Double

    init(fromCommandLineArgs args: [String]) {
        self.pathToCoverageFile = CommandLine.arguments[1]
        guard let minimumCoverageValue = Double(CommandLine.arguments[2]) else {
            fatalError("Invalid argument. Minimum coverage value needs to be a number.".inRed)
        }
        self.requiredCoverage = minimumCoverageValue
    }
}

// MARK: - Functions

func checkCodeCoverage() {
    let arguments = Arguments(fromCommandLineArgs: CommandLine.arguments)
    guard let coverageData = coverageData(for: arguments) else {
        exit(-1)
    }

    print("Checking coverage for \(arguments.pathToCoverageFile)".inCyan)

    do {
        let information = try JSONDecoder().decode(CodeCoverage.self, from: coverageData)

        guard information.executableLines > 0 else {
            print("No code line to cover.".inYellow)
            exit(0)
        }

        if information.coveragePercentage >= arguments.requiredCoverage {
            print(information.targetsDescription)
            print(information.description.inGreen)
            exit(0)
        } else {
            print(String(format: "\(information.description) is less than required %.2f%%", arguments.requiredCoverage).inRed)
            exit(1)
        }
    } catch {
        print("Error while parsing report: \n\(error)`".inRed)
        exit(1)
    }
}

private func coverageData(for arguments: Arguments) -> Data? {
    let fileManager = FileManager.default
    let coverageFileName = arguments.pathToCoverageFile
    if !fileManager.fileExists(atPath: coverageFileName) {
        fatalError("File `\(coverageFileName)` does not exist.".inRed)
    }

    guard let codeCoverageData = fileManager.contents(atPath: coverageFileName) else {
        fatalError("Couldn't read content of file `\(coverageFileName)`".inRed)
    }
    return codeCoverageData
}

// MARK: - Utils

private func printError(_ message: String) {
	print(message.inRed)
}

private extension String {
    var inCyan: String {
        "\u{001B}[0;36m" + self + resetCharacter
    }
	var inGreen: String {
		"\u{001B}[0;32m" + self + resetCharacter
	}
    var inYellow: String {
        "\u{001B}[0;33m" + self + resetCharacter
    }
	var inRed: String {
		"\u{001B}[0;31m" + self + resetCharacter
	}
    private var resetCharacter: String {
        "\u{001B}[0;0m"
    }
}
