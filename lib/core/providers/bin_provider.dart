import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/bin_model.dart';
import '../../data/repositories/bin_repository.dart';
import '../services/notification_service.dart';
import 'settings_provider.dart';

final binsProvider = StreamProvider<List<BinModel>>((ref) {
  return BinRepository.watchAllBins();
});

final binByIdProvider = FutureProvider.family<BinModel?, String>((
  ref,
  id,
) async {
  return await BinRepository.getBinById(id);
});

final binStatsProvider = Provider<BinStats>((ref) {
  final binsAsync = ref.watch(binsProvider);

  return binsAsync.when(
    data: (bins) {
      final total = bins.length;
      final full = bins.where((b) => b.status == BinStatus.full).length;
      final warning = bins.where((b) => b.status == BinStatus.warning).length;
      final normal = bins.where((b) => b.status == BinStatus.normal).length;
      final avgFillLevel = bins.isEmpty
          ? 0.0
          : bins.map((b) => b.fillLevel).reduce((a, b) => a + b) / bins.length;

      return BinStats(
        total: total,
        full: full,
        warning: warning,
        normal: normal,
        averageFillLevel: avgFillLevel,
      );
    },
    loading: () => BinStats(),
    error: (_, __) => BinStats(),
  );
});

class BinStats {
  final int total;
  final int full;
  final int warning;
  final int normal;
  final double averageFillLevel;

  BinStats({
    this.total = 0,
    this.full = 0,
    this.warning = 0,
    this.normal = 0,
    this.averageFillLevel = 0.0,
  });
}

// Monitor bins and send notifications
final binMonitorProvider = Provider<void>((ref) {
  final binsAsync = ref.watch(binsProvider);
  final settings = ref.watch(settingsProvider);

  binsAsync.whenData((bins) {
    if (!settings.notificationsEnabled) return;

    for (var bin in bins) {
      if (bin.fillLevel >= settings.thresholdLevel) {
        NotificationService.showBinFullNotification(
          binId: bin.id,
          binName: bin.name,
          fillLevel: bin.fillLevel,
        );
      }
    }
  });
});
