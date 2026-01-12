.PHONY: clean format gen watch test prepare rename upgrade lint ci help

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

# 🔍 Analyze code for errors and lint warnings
lint:
	flutter analyze
	dart format --output=none --set-exit-if-changed .

# 🧪 Run all tests (unit and widget)
test:
	flutter test

# 🚀 Fresh setup (Good for new team members)
prepare: clean gen

# ⬆️ Upgrade dependencies
upgrade:
	flutter pub upgrade
	flutter pub get

# ⚡ Run CI checks (Lint + Test)
ci: lint test

# 🏷️ Rename project (Usage: make rename NAME=my_app ORG=com.company DISPLAY="My App")
rename:
ifndef NAME
	$(error NAME is required. Usage: make rename NAME=my_app ORG=com.company DISPLAY="My App")
endif
ifndef ORG
	$(error ORG is required. Usage: make rename NAME=my_app ORG=com.company DISPLAY="My App")
endif
	./scripts/rename_project.sh $(NAME) $(ORG) "$(DISPLAY)"

# ✨ Create a new feature (Usage: make feature NAME=my_feature)
feature:
ifndef NAME
	$(error NAME is required. Usage: make feature NAME=my_feature)
endif
	./scripts/create_feature.sh $(NAME)

# ❓ Show help
help:
	@echo "Available commands:"
	@echo "  make clean    - Clean project and dependencies"
	@echo "  make gen      - Run code generation once"
	@echo "  make watch    - Run code generation in watch mode"
	@echo "  make format   - Format code and fix lint issues"
	@echo "  make lint     - Run static analysis"
	@echo "  make test     - Run all tests"
	@echo "  make prepare  - Full setup (clean + gen)"
	@echo "  make upgrade  - Upgrade dependencies"
	@echo "  make ci       - Run CI checks (lint + test)"
	@echo "  make rename   - Rename project (requires NAME, ORG, DISPLAY)"
	@echo "  make feature  - Create a new feature (requires NAME)"