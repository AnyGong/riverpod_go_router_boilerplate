#!/bin/bash

# Check if feature name is provided
if [ -z "$1" ]; then
    echo "❌ Error: Feature name is required."
    echo "Usage: ./scripts/create_feature.sh <feature_name>"
    exit 1
fi

FEATURE_NAME=$1
BASE_DIR="lib/features/$FEATURE_NAME"

# Check if feature already exists
if [ -d "$BASE_DIR" ]; then
    echo "❌ Error: Feature '$FEATURE_NAME' already exists."
    exit 1
fi

echo "🚀 Creating feature: $FEATURE_NAME"

# Create directory structure
mkdir -p "$BASE_DIR/data/repositories"
mkdir -p "$BASE_DIR/data/datasources"
mkdir -p "$BASE_DIR/data/models"
mkdir -p "$BASE_DIR/domain/entities"
mkdir -p "$BASE_DIR/domain/repositories"
mkdir -p "$BASE_DIR/presentation/pages"
mkdir -p "$BASE_DIR/presentation/widgets"
mkdir -p "$BASE_DIR/presentation/providers"

# Create placeholder entity
cat > "$BASE_DIR/domain/entities/${FEATURE_NAME}_entity.dart" <<EOL
import 'package:flutter/foundation.dart';

@immutable
class ${FEATURE_NAME^}Entity {
  const ${FEATURE_NAME^}Entity({required this.id});

  final String id;
}
EOL

# Create placeholder repository interface
cat > "$BASE_DIR/domain/repositories/${FEATURE_NAME}_repository.dart" <<EOL
import 'package:riverpod_go_router_boilerplate/core/result/result.dart';
import '../entities/${FEATURE_NAME}_entity.dart';

abstract class ${FEATURE_NAME^}Repository {
  Future<Result<${FEATURE_NAME^}Entity>> getData();
}
EOL

# Create placeholder repository implementation
cat > "$BASE_DIR/data/repositories/${FEATURE_NAME}_repository_impl.dart" <<EOL
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/core/result/result.dart';
import '../../domain/entities/${FEATURE_NAME}_entity.dart';
import '../../domain/repositories/${FEATURE_NAME}_repository.dart';

part '${FEATURE_NAME}_repository_impl.g.dart';

// Repository Provider
@Riverpod(keepAlive: true)
${FEATURE_NAME^}Repository ${FEATURE_NAME}Repository(Ref ref) {
  return ${FEATURE_NAME^}RepositoryImpl();
}

class ${FEATURE_NAME^}RepositoryImpl implements ${FEATURE_NAME^}Repository {
  @override
  Future<Result<${FEATURE_NAME^}Entity>> getData() async {
    // TODO: Implement
    return const Success(${FEATURE_NAME^}Entity(id: '1'));
  }
}
EOL

# Create placeholder provider
cat > "$BASE_DIR/presentation/providers/${FEATURE_NAME}_notifier.dart" <<EOL
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/${FEATURE_NAME}_entity.dart';
import '../../data/repositories/${FEATURE_NAME}_repository_impl.dart';

part '${FEATURE_NAME}_notifier.g.dart';

@riverpod
class ${FEATURE_NAME^}Notifier extends _\$${FEATURE_NAME^}Notifier {
  @override
  FutureOr<${FEATURE_NAME^}Entity> build() async {
    // Fetch data from repository
    final repository = ref.watch(${FEATURE_NAME}RepositoryProvider);
    final result = await repository.getData();
    
    return result.fold(
      onSuccess: (data) => data,
      onFailure: (error) => throw error, // Handle error appropriately
    );
  }
}
EOL

# Create placeholder page
cat > "$BASE_DIR/presentation/pages/${FEATURE_NAME}_page.dart" <<EOL
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/${FEATURE_NAME}_notifier.dart';

class ${FEATURE_NAME^}Page extends ConsumerWidget {
  const ${FEATURE_NAME^}Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(${FEATURE_NAME}NotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('${FEATURE_NAME^}')),
      body: state.when(
        data: (data) => Center(child: Text('Data: \${data.id}')),
        error: (e, _) => Center(child: Text('Error: \$e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
EOL

# Create barrel file
cat > "$BASE_DIR/${FEATURE_NAME}.dart" <<EOL
/// ${FEATURE_NAME^} feature.
library;

export 'presentation/pages/${FEATURE_NAME}_page.dart';
EOL

echo "✅ Feature structure created at $BASE_DIR"
echo "👉 Don't forget to run 'make gen' to generate providers!"
