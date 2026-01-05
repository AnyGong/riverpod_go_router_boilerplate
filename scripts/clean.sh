#!/usr/bin/env bash
set -e

echo "🧹 Cleaning Flutter project..."

flutter clean
rm -rf .dart_tool
rm -rf build

echo "📦 Getting dependencies..."
flutter pub get

echo "✅ Clean complete!"
