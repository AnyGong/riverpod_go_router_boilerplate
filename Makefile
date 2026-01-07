.PHONY: clean format gen watch test prepare

# 🧹 Clean everything (delete build artifacts and fetch fresh deps)
clean:
	./scripts/clean.sh
	flutter pub get

# 🔨 Run code generation (build_runner) once
gen:
	dart run build_runner build --delete-conflicting-outputs

# 👀 Run code generation in watch mode (updates as you save)
watch:
	dart run build_runner watch --delete-conflicting-outputs

# 🎨 Format and fix lint issues
format:
	dart format .
	dart fix --apply

# 🧪 Run all tests
test:
	flutter test

# 🚀 Fresh setup (Good for new team members or CI)
prepare: clean gen