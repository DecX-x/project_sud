import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/bin_provider.dart';
import '../widgets/stats_card.dart';
import '../widgets/bin_list_item.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final binsAsync = ref.watch(binsProvider);
    final stats = ref.watch(binStatsProvider);

    // Monitor bins for notifications
    ref.watch(binMonitorProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('SmartBin Monitor'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(binsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Statistics Section
            const Text(
              'Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    title: 'Total Bins',
                    value: stats.total.toString(),
                    icon: Icons.delete_outline,
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: StatsCard(
                    title: 'Full',
                    value: stats.full.toString(),
                    icon: Icons.warning,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    title: 'Warning',
                    value: stats.warning.toString(),
                    icon: Icons.error_outline,
                    color: Colors.orange,
                  ),
                ),
                Expanded(
                  child: StatsCard(
                    title: 'Avg Fill',
                    value: '${stats.averageFillLevel.toStringAsFixed(0)}%',
                    icon: Icons.analytics,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Bins List Section
            const Text(
              'All Bins',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            binsAsync.when(
              data: (bins) {
                if (bins.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('No bins available'),
                    ),
                  );
                }

                return Column(
                  children: bins.map((bin) => BinListItem(bin: bin)).toList(),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text('Error: $error'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
