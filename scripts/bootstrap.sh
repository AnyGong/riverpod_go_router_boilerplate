#!/usr/bin/env bash
set -e

echo "🚀 Bootstrapping Flutter project..."

echo "📦 Getting dependencies..."
flutter pub get

echo "🔍 Running analyzer..."
flutter analyze

echo "🧪 Running tests..."
flutter test

echo "✅ Bootstrap complete!"
