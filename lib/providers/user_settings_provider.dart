import 'package:flutter/foundation.dart';
import '../models/user_settings.dart';
import '../services/user_settings_service.dart';

class UserSettingsProvider extends ChangeNotifier {
  final UserSettingsService _service = UserSettingsService();
  UserSettings? _settings;
  bool _isLoading = true;

  UserSettings? get settings => _settings;
  bool get isLoading => _isLoading;

  // Load settings for a user
  Future<void> loadSettings(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _settings = await _service.getUserSettings(userId);
    } catch (e) {
      // Handle error - could set an error state
      print('Error loading settings: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Update push notification settings
  Future<void> updatePushNotifications(bool enabled) async {
    if (_settings == null) return;

    try {
      final newSettings = _settings!.copyWith(pushNotificationsEnabled: enabled);
      await _service.updateUserSettings(newSettings);
      _settings = newSettings;
      notifyListeners();
    } catch (e) {
      // Handle error - could revert the change
      print('Error updating push notifications: $e');
    }
  }

  // Update email settings
  Future<void> updateEmailUpdates(bool enabled) async {
    if (_settings == null) return;

    try {
      final newSettings = _settings!.copyWith(emailUpdatesEnabled: enabled);
      await _service.updateUserSettings(newSettings);
      await _service.updateSubscriptions(_settings!.userId, enabled);
      _settings = newSettings;
      notifyListeners();
    } catch (e) {
      // Handle error - could revert the change
      print('Error updating email settings: $e');
    }
  }
}