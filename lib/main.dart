import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/router/app_router.dart';
import 'core/services/notification_service.dart';
import 'core/providers/settings_provider.dart';
import 'data/models/bin_model.dart';
import 'data/repositories/bin_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(BinModelAdapter());
  Hive.registerAdapter(BinStatusAdapter());
  Hive.registerAdapter(HistoryEntryAdapter());

  // Initialize notifications
  await NotificationService.initialize();

  // Try to fetch from API, fallback to dummy data if fails
  try {
    await BinRepository.fetchBinsFromApi();
    print('✅ Successfully loaded bins from API');
  } catch (e) {
    print('⚠️ API not available, using dummy data: $e');
    await BinRepository.seedDummyData();
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(settingsProvider);

    return MaterialApp.router(
      title: 'SmartBin Monitor',
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(elevation: 2, margin: const EdgeInsets.all(8)),
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(elevation: 2, margin: const EdgeInsets.all(8)),
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      routerConfig: router,
    );
  }
}
