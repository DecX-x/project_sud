import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    _loadSettings();
    return AppSettings();
  }

  Future<void> _loadSettings() async {
    final box = await Hive.openBox('settings');
    state = AppSettings(
      thresholdLevel: box.get('thresholdLevel', defaultValue: 80.0),
      notificationsEnabled: box.get('notificationsEnabled', defaultValue: true),
    );
  }

  Future<void> setThresholdLevel(double level) async {
    final box = await Hive.openBox('settings');
    await box.put('thresholdLevel', level);
    state = state.copyWith(thresholdLevel: level);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final box = await Hive.openBox('settings');
    await box.put('notificationsEnabled', enabled);
    state = state.copyWith(notificationsEnabled: enabled);
  }
}

class AppSettings {
  final double thresholdLevel;
  final bool notificationsEnabled;

  AppSettings({this.thresholdLevel = 80.0, this.notificationsEnabled = true});

  AppSettings copyWith({double? thresholdLevel, bool? notificationsEnabled}) {
    return AppSettings(
      thresholdLevel: thresholdLevel ?? this.thresholdLevel,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);
