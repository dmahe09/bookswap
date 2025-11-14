import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/user_settings.dart';

class UserSettingsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  CollectionReference get _settingsRef => _db.collection('user_settings');

  // Get user settings
  Future<UserSettings> getUserSettings(String userId) async {
    try {
      final doc = await _settingsRef.doc(userId).get();
      if (doc.exists) {
        return UserSettings.fromMap({
          ...doc.data() as Map<String, dynamic>,
          'userId': userId,
        });
      }
      return UserSettings(userId: userId);
    } catch (e) {
      // Return default settings if there's an error
      return UserSettings(userId: userId);
    }
  }

  // Update user settings
  Future<void> updateUserSettings(UserSettings settings) async {
    await _settingsRef.doc(settings.userId).set(settings.toMap(), SetOptions(merge: true));
    
    if (settings.pushNotificationsEnabled) {
      await _requestNotificationPermissions();
    }
  }

  // Request notification permissions and save token
  Future<void> _requestNotificationPermissions() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        final token = await _messaging.getToken();
        if (token != null) {
          // Store the FCM token
          await _settingsRef.doc('fcm_tokens').set({
            token: {
              'lastUpdated': FieldValue.serverTimestamp(),
            }
          }, SetOptions(merge: true));
        }
      }
    } catch (e) {
      // Handle or log the error
      print('Error setting up notifications: $e');
    }
  }

  // Subscribe to topics based on settings
  Future<void> updateSubscriptions(String userId, bool emailUpdatesEnabled) async {
    if (emailUpdatesEnabled) {
      await _messaging.subscribeToTopic('email_updates_$userId');
    } else {
      await _messaging.unsubscribeFromTopic('email_updates_$userId');
    }
  }
}