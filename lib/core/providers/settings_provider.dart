import 'package:flutter/material.dart';
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
      themeMode: ThemeMode.values[box.get('themeMode', defaultValue: 0)],
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

  Future<void> setThemeMode(ThemeMode mode) async {
    final box = await Hive.openBox('settings');
    await box.put('themeMode', mode.index);
    state = state.copyWith(themeMode: mode);
  }
}

class AppSettings {
  final double thresholdLevel;
  final bool notificationsEnabled;
  final ThemeMode themeMode;

  AppSettings({
    this.thresholdLevel = 80.0,
    this.notificationsEnabled = true,
    this.themeMode = ThemeMode.system,
  });

  AppSettings copyWith({
    double? thresholdLevel,
    bool? notificationsEnabled,
    ThemeMode? themeMode,
  }) {
    return AppSettings(
      thresholdLevel: thresholdLevel ?? this.thresholdLevel,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);
