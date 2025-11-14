class UserSettings {
  final bool pushNotificationsEnabled;
  final bool emailUpdatesEnabled;
  final String userId;

  UserSettings({
    required this.userId,
    this.pushNotificationsEnabled = true,
    this.emailUpdatesEnabled = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'pushNotificationsEnabled': pushNotificationsEnabled,
      'emailUpdatesEnabled': emailUpdatesEnabled,
    };
  }

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      userId: map['userId'] as String,
      pushNotificationsEnabled: map['pushNotificationsEnabled'] as bool? ?? true,
      emailUpdatesEnabled: map['emailUpdatesEnabled'] as bool? ?? true,
    );
  }

  UserSettings copyWith({
    bool? pushNotificationsEnabled,
    bool? emailUpdatesEnabled,
  }) {
    return UserSettings(
      userId: userId,
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      emailUpdatesEnabled: emailUpdatesEnabled ?? this.emailUpdatesEnabled,
    );
  }
}