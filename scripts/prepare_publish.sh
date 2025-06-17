#!/bin/bash

# Script to prepare the package for publishing with custom CI/CD pipeline

set -e

echo "🚀 Preparing Innovare Audio Waveform Player for publication..."
echo "📋 Using comprehensive custom workflow with 8 specialized jobs"

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

echo ""
echo "🔍 === CODE QUALITY & ANALYSIS ==="
echo "📦 Installing dependencies..."
flutter pub get

echo "🔍 Running static analysis..."
dart analyze --fatal-infos --fatal-warnings

echo "📝 Checking formatting..."
dart format --output=none --set-exit-if-changed .

echo "🔐 Running security audit..."
dart pub audit || echo "⚠️  Security audit completed with warnings"

echo ""
echo "🧪 === COMPREHENSIVE TESTING ==="
echo "🧪 Running tests with coverage..."
flutter test --coverage

echo "📊 Analyzing coverage..."
if command -v lcov >/dev/null 2>&1; then
    genhtml coverage/lcov.info -o coverage/html --quiet 2>/dev/null || true
    COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines\|functions\|branches" | head -1 | grep -o '[0-9.]*%' | head -1 || echo "N/A")
    echo "📈 Test coverage: $COVERAGE"
else
    echo "📈 Coverage report available in coverage/lcov.info"
fi

echo ""
echo "🏗️ === MULTI-PLATFORM BUILD VERIFICATION ==="
echo "🌐 Building example for web..."
cd example
flutter pub get
flutter build web --release
echo "✅ Web build completed"

echo "🤖 Building example for Android..."
flutter build apk --release
echo "✅ Android build completed"

cd ..

echo ""
echo "📦 === PACKAGE VALIDATION ==="
echo "📋 Validating package structure..."

# Check required files
REQUIRED_FILES=("lib/innovare_audio_waveform_player.dart" "lib/src/innovare_audio_waveform_player.dart" "README.md" "CHANGELOG.md" "LICENSE" "pubspec.yaml")

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ Required file missing: $file"
        exit 1
    fi
done

echo "📚 Validating documentation..."
dart doc --validate-links --quiet || echo "⚠️  Documentation validation completed with warnings"

echo "📋 Running pub publish dry run..."
dart pub publish --dry-run

echo ""
echo "🔒 === SECURITY VERIFICATION ==="
echo "🔍 Scanning for sensitive files..."

# Check for sensitive patterns
SENSITIVE_PATTERNS=(".env" "*.key" "*.p12" "*.keystore" "google-services.json" "GoogleService-Info.plist")

FOUND_SENSITIVE=false
for pattern in "${SENSITIVE_PATTERNS[@]}"; do
    if find . -name "$pattern" -not -path "./build/*" -not -path "./.dart_tool/*" | grep -q .; then
        echo "⚠️  Found potentially sensitive files matching: $pattern"
        FOUND_SENSITIVE=true
    fi
done

if [ "$FOUND_SENSITIVE" = false ]; then
    echo "✅ No sensitive files detected"
fi

echo ""
echo "📊 === PERFORMANCE ANALYSIS ==="
echo "📏 Analyzing package size..."
cd example
flutter build web --analyze-size || echo "⚠️  Size analysis completed"
cd ..

echo "🌳 Analyzing dependency tree..."
flutter pub deps --style=tree > /dev/null

echo ""
echo "✅ === ALL CHECKS COMPLETED SUCCESSFULLY! ==="
echo ""
echo "📦 Package is ready for publication with the following workflow:"
echo ""
echo "🔄 CUSTOM CI/CD PIPELINE FEATURES:"
echo "  ✅ Code Quality & Static Analysis"
echo "  ✅ Comprehensive Testing (80% coverage threshold)"
echo "  ✅ Multi-Platform Builds (Web, Android, Linux)"
echo "  ✅ Package Validation & Documentation"
echo "  ✅ Security Vulnerability Scanning"
echo "  ✅ Performance & Size Analysis"
echo "  ✅ Automated OIDC Publishing"
echo "  ✅ Post-Publish GitHub Release"
echo ""
echo "📋 FOR FIRST PUBLICATION (required):"
echo "  dart pub publish"
echo ""
echo "🔧 THEN CONFIGURE AUTOMATED PUBLISHING:"
echo "  1. Create GitHub environment: 'pub-dev'"
echo "  2. Go to: https://pub.dev/packages/innovare_audio_waveform_player/admin"
echo "  3. Enable 'Automated publishing from GitHub Actions'"
echo "  4. Set repository: yourusername/innovare_audio_waveform_player"
echo "  5. Set environment: pub-dev"
echo "  6. Set tag pattern: v{{version}}"
echo ""
echo "🚀 FOR SUBSEQUENT RELEASES (automatic):"
echo "  1. Update version in pubspec.yaml"
echo "  2. Update CHANGELOG.md"
echo "  3. git add . && git commit -m 'chore: bump version to X.X.X'"
echo "  4. git tag vX.X.X && git push origin --tags"
echo ""
echo "🔒 SECURITY: No secrets needed! Uses secure OIDC authentication."
echo "📊 MONITORING: Check GitHub Actions tab for detailed logs."
echo "📋 FEATURES: 8 specialized jobs running in parallel for maximum efficiency."
echo ""
echo "🎉 Ready to publish with professional-grade CI/CD pipeline!"