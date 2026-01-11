import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/core/feedback/feedback_service.dart';

part 'permission_service.g.dart';

/// Result of a permission request.
enum PermissionResult {
  /// Permission was granted.
  granted,

  /// Permission was denied but can be requested again.
  denied,

  /// Permission was permanently denied (must open settings).
  permanentlyDenied,

  /// Permission is restricted by the system (e.g., parental controls).
  restricted,

  /// Permission request is limited (iOS only).
  limited,
}

/// Extension to convert [PermissionStatus] to [PermissionResult].
extension PermissionStatusX on PermissionStatus {
  /// Convert to [PermissionResult].
  PermissionResult toResult() {
    switch (this) {
      case PermissionStatus.granted:
        return PermissionResult.granted;
      case PermissionStatus.denied:
        return PermissionResult.denied;
      case PermissionStatus.permanentlyDenied:
        return PermissionResult.permanentlyDenied;
      case PermissionStatus.restricted:
        return PermissionResult.restricted;
      case PermissionStatus.limited:
        return PermissionResult.limited;
      case PermissionStatus.provisional:
        return PermissionResult.granted; // Treat provisional as granted
    }
  }
}

/// Configuration for a permission request dialog.
class PermissionDialogConfig {
  /// Creates a [PermissionDialogConfig] instance.
  const PermissionDialogConfig({
    required this.title,
    required this.message,
    this.icon,
    this.confirmLabel = 'Allow',
    this.cancelLabel = 'Cancel',
    this.settingsLabel = 'Open Settings',
  });

  /// Dialog title.
  final String title;

  /// Explanation message for why the permission is needed.
  final String message;

  /// Optional icon to display.
  final IconData? icon;

  /// Label for the confirm/allow button.
  final String confirmLabel;

  /// Label for the cancel button.
  final String cancelLabel;

  /// Label for the "open settings" button.
  final String settingsLabel;
}

/// Service for handling runtime permissions with a clean API.
///
/// Abstracts the complexity of permission handling with:
/// - Status checking
/// - Request with rationale dialogs
/// - Automatic "Open Settings" prompts for permanently denied permissions
///
/// Example:
/// ```dart
/// final permissionService = ref.read(permissionServiceProvider);
///
/// // Simple check and request
/// final cameraGranted = await permissionService.request(Permission.camera);
///
/// // Request with rationale dialog
/// final locationGranted = await permissionService.requestWithRationale(
///   Permission.location,
///   config: PermissionDialogConfig(
///     title: 'Location Permission',
///     message: 'We need your location to show nearby stores.',
///     icon: Icons.location_on,
///   ),
/// );
///
/// // Request multiple permissions
/// final allGranted = await permissionService.requestMultiple([
///   Permission.camera,
///   Permission.microphone,
/// ]);
/// ```
class PermissionService {
  /// Creates a [PermissionService] instance.
  PermissionService(this._ref);

  final Ref _ref;

  FeedbackService get _feedback => _ref.read(feedbackServiceProvider);

  /// Check the current status of a permission.
  Future<PermissionResult> check(final Permission permission) async {
    final status = await permission.status;
    return status.toResult();
  }

  /// Check if a permission is granted.
  Future<bool> isGranted(final Permission permission) async {
    return permission.isGranted;
  }

  /// Request a single permission.
  ///
  /// Returns true if granted, false otherwise.
  Future<bool> request(final Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  /// Request a permission with a rationale dialog shown first.
  ///
  /// If the permission was previously denied, shows an explanation dialog
  /// before requesting again. If permanently denied, offers to open settings.
  Future<bool> requestWithRationale(
    final Permission permission, {
    required final PermissionDialogConfig config,
  }) async {
    final currentStatus = await permission.status;

    // Already granted
    if (currentStatus.isGranted) {
      return true;
    }

    // Permanently denied - offer to open settings
    if (currentStatus.isPermanentlyDenied) {
      return _handlePermanentlyDenied(config);
    }

    // Show rationale if previously denied
    if (currentStatus.isDenied) {
      final shouldProceed = await _showRationaleDialog(config);
      if (!shouldProceed) {
        return false;
      }
    }

    // Request the permission
    final newStatus = await permission.request();

    // If now permanently denied, offer settings
    if (newStatus.isPermanentlyDenied) {
      return _handlePermanentlyDenied(config);
    }

    return newStatus.isGranted;
  }

  /// Request multiple permissions at once.
  ///
  /// Returns a map of permission to result.
  Future<Map<Permission, PermissionResult>> requestMultiple(
    final List<Permission> permissions,
  ) async {
    final statuses = await permissions.request();

    return statuses.map(
      (final permission, final status) => MapEntry(
        permission,
        status.toResult(),
      ),
    );
  }

  /// Check if all specified permissions are granted.
  Future<bool> areAllGranted(final List<Permission> permissions) async {
    for (final permission in permissions) {
      if (!await permission.isGranted) {
        return false;
      }
    }
    return true;
  }

  /// Open the app settings page.
  ///
  /// Returns true if settings were opened successfully.
  Future<bool> openSettings() {
    return openAppSettings();
  }

  /// Handle permanently denied permissions by offering to open settings.
  Future<bool> _handlePermanentlyDenied(
    final PermissionDialogConfig config,
  ) async {
    final shouldOpenSettings = await _feedback.showConfirmDialog(
      title: config.title,
      message:
          '${config.message}\n\n'
          'This permission was previously denied. '
          'Please enable it in Settings.',
      confirmLabel: config.settingsLabel,
      cancelLabel: config.cancelLabel,
    );

    if (shouldOpenSettings) {
      await openSettings();
    }

    return false;
  }

  /// Show a rationale dialog before requesting permission.
  Future<bool> _showRationaleDialog(
    final PermissionDialogConfig config,
  ) async {
    return _feedback.showConfirmDialog(
      title: config.title,
      message: config.message,
      confirmLabel: config.confirmLabel,
      cancelLabel: config.cancelLabel,
    );
  }
}

/// Provider for [PermissionService].
@Riverpod(keepAlive: true)
PermissionService permissionService(final Ref ref) {
  return PermissionService(ref);
}

/// Common permission dialog configurations.
abstract class PermissionDialogs {
  /// Camera permission dialog.
  static const camera = PermissionDialogConfig(
    title: 'Camera Permission',
    message: 'We need camera access to take photos.',
    icon: Icons.camera_alt,
  );

  /// Microphone permission dialog.
  static const microphone = PermissionDialogConfig(
    title: 'Microphone Permission',
    message: 'We need microphone access to record audio.',
    icon: Icons.mic,
  );

  /// Location permission dialog.
  static const location = PermissionDialogConfig(
    title: 'Location Permission',
    message: 'We need your location to provide relevant local content.',
    icon: Icons.location_on,
  );

  /// Storage permission dialog.
  static const storage = PermissionDialogConfig(
    title: 'Storage Permission',
    message: 'We need storage access to save files.',
    icon: Icons.folder,
  );

  /// Photos permission dialog.
  static const photos = PermissionDialogConfig(
    title: 'Photos Permission',
    message: 'We need access to your photos to let you choose images.',
    icon: Icons.photo_library,
  );

  /// Notification permission dialog.
  static const notification = PermissionDialogConfig(
    title: 'Notification Permission',
    message: 'Enable notifications to stay updated.',
    icon: Icons.notifications,
  );

  /// Contacts permission dialog.
  static const contacts = PermissionDialogConfig(
    title: 'Contacts Permission',
    message: 'We need access to your contacts.',
    icon: Icons.contacts,
  );

  /// Calendar permission dialog.
  static const calendar = PermissionDialogConfig(
    title: 'Calendar Permission',
    message: 'We need calendar access to manage your events.',
    icon: Icons.calendar_today,
  );
}
