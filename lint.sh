#!/usr/bin/env bash
echo "Autocorrect first"
Tools/SwiftLint/swiftlint autocorrect --config ./.swiftlint.yml &> /dev/null

echo "Now look for errors"
Tools/SwiftLint/swiftlint --config ./.swiftlint.yml