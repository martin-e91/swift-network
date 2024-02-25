#!/bin/sh

# Scheme's name.
SCHEME="Network-Package"

# Temporary folder for storing script's generated files
TMP_FOLDER=".scriptTemp"

# File name for Xcode build results file.
RESULT_BUNDLE="$TMP_FOLDER/CodeCoverage.xcresult"

# File containing JSON with coverage data.
RESULT_JSON="$TMP_FOLDER/CodeCoverage.json"

# Minimum code coverage threshold.
MIN_CODE_COVERAGE=99.0

if [ -d $TMP_FOLDER ]; then
	echo "Removing previous $TMP_FOLDER temporary folder"
	rm -rf $TMP_FOLDER
fi

# Create temp folder for temporary storage while executing the script.
echo "Created $TMP_FOLDER folder for storing script's generated files."
mkdir $TMP_FOLDER

# The run tests section is split into build the package for testing and then running tests without building.
# This will make easier to see which step failed.
# An alternative would be to use test argument instead of build-for-testing and test-without-building.

# Build
set -o pipefail && env NSUnbufferedIO=YES xcodebuild build-for-testing -scheme $SCHEME -destination "platform=iOS Simulator,OS=latest,name=iPhone 15" -enableCodeCoverage YES | xcbeautify

# Test
set -o pipefail && env NSUnbufferedIO=YES xcodebuild test-without-building -scheme $SCHEME -destination "platform=iOS Simulator,OS=latest,name=iPhone 15" -enableCodeCoverage YES -resultBundlePath $RESULT_BUNDLE | xcbeautify

# Fetch code coverage
set -o pipefail && env NSUnbufferedIO=YES xcrun xccov view --report --json $RESULT_BUNDLE > $RESULT_JSON

# Check code coverage.
./Scripts/check_code_coverage.swift $RESULT_JSON $MIN_CODE_COVERAGE

echo "Removing $TMP_FOLDER temporary folder"
rm -rf $TMP_FOLDER