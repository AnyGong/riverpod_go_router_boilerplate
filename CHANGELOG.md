# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-01-08

### Added

- Initial production-ready Flutter boilerplate with Riverpod 3.x
- GoRouter 17.x with declarative routing and AppRoute enum
- Dio with native adapters for HTTP/3 and Brotli support
- Drift (SQLite) for type-safe offline caching
- Freezed models with JSON serialization
- Clean Architecture (data → domain → presentation)
- Comprehensive localization (English & Bengali) with ARB files
- Result pattern for error handling
- Network layer with interceptors and caching
- Startup event system for app initialization
- Biometric authentication support
- Firebase Crashlytics integration
- GitHub Actions CI/CD pipeline
- Unit and widget tests with proper test structure
- Codecov integration for coverage tracking
- GitHub Copilot instructions for consistent code generation
- Production-ready README with architecture diagrams
- Comprehensive code style guidelines

### Security

- Implemented scoped GitHub Actions permissions
- Secure storage for sensitive data (biometric tokens)
- API key management through environment configuration
- SSL pinning ready via Dio interceptors

### Documentation

- Production-ready README with full architecture explanation
- GitHub Copilot instructions with code patterns
- Inline code documentation for key components
- Architecture diagrams and decision rationale
- Contributing guidelines and code standards

## [Unreleased]

### Planned

- AAB (Android App Bundle) support for Google Play
- iOS IPA building and distribution
- Web platform support
- Desktop platform support (Windows, macOS, Linux)
- Advanced error tracking and analytics
- Feature flags system
- A/B testing infrastructure
- Push notifications system
- Image caching and optimization
- Local database migrations
