import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/router/app_router.dart';
import 'core/services/notification_service.dart';
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

  // Seed dummy data
  await BinRepository.seedDummyData();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'SmartBin Monitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(elevation: 2, margin: const EdgeInsets.all(8)),
      ),
      routerConfig: router,
    );
  }
}
