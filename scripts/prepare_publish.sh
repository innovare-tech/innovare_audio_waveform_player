#!/bin/bash

# Script to prepare the package for publishing to pub.dev

set -e

echo "🚀 Preparing Innovare Audio Waveform Player for publication..."

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: pubspec.yaml not found. Please run this script from the package root."
    exit 1
fi

# Check if package name is correct
if ! grep -q "name: innovare_audio_waveform_player" pubspec.yaml; then
    echo "❌ Error: Package name doesn't match expected name."
    exit 1
fi

echo "📦 Installing dependencies..."
flutter pub get

echo "🔍 Running static analysis..."
dart analyze --fatal-infos

echo "📝 Checking formatting..."
dart format --output=none --set-exit-if-changed .

echo "🧪 Running tests..."
flutter test

echo "📋 Running pub publish dry run..."
dart pub publish --dry-run

echo "🔄 Building example app..."
cd example
flutter pub get
flutter build web --release
cd ..

echo "✅ All checks passed! Package is ready for publication."
echo ""
echo "To publish to pub.dev, run:"
echo "  dart pub publish"
echo ""
echo "Make sure you have:"
echo "  1. Updated the version in pubspec.yaml"
echo "  2. Updated CHANGELOG.md"
echo "  3. Committed all changes to git"
echo "  4. Created a git tag for the version"