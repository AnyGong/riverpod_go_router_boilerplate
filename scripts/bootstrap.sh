#!/usr/bin/env bash
set -e

flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
