import 'package:hive_flutter/hive_flutter.dart';
import '../models/bin_model.dart';
import '../../core/services/api_service.dart';

class BinRepository {
  static const String _boxName = 'bins';

  static Future<Box<BinModel>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<BinModel>(_boxName);
    }
    return Hive.box<BinModel>(_boxName);
  }

  // Fetch bins from API
  static Future<List<BinModel>> fetchBinsFromApi() async {
    try {
      final data = await ApiService.getBinsExtended();
      final bins = data.map((json) => BinModel.fromApiExtended(json)).toList();

      // Sort by ID descending (newest first)
      bins.sort((a, b) => int.parse(b.id).compareTo(int.parse(a.id)));

      // Cache to Hive
      await _cacheBins(bins);

      return bins;
    } catch (e) {
      // Return cached data if API fails
      return await getCachedBins();
    }
  }

  // Cache bins to Hive
  static Future<void> _cacheBins(List<BinModel> bins) async {
    final box = await _getBox();
    await box.clear();
    for (var bin in bins) {
      await box.put(bin.id, bin);
    }
  }

  // Get cached bins
  static Future<List<BinModel>> getCachedBins() async {
    final box = await _getBox();
    return box.values.toList();
  }

  // Get all bins (try API first, fallback to cache)
  static Future<List<BinModel>> getAllBins() async {
    try {
      return await fetchBinsFromApi();
    } catch (e) {
      return await getCachedBins();
    }
  }

  // Get bin by ID (use bins_extended to get fill level data)
  static Future<BinModel?> getBinById(String id) async {
    try {
      // Use bins_extended endpoint which has fill level data
      final allBinsData = await ApiService.getBinsExtended();
      final binData = allBinsData.firstWhere(
        (b) => b['id'].toString() == id,
        orElse: () => null,
      );

      if (binData == null) {
        final box = await _getBox();
        return box.get(id);
      }

      final bin = BinModel.fromApiExtended(binData);

      // Get measurements for history
      final measurements = await ApiService.getMeasurements(
        binId: id,
        limit: 24,
      );

      final history = measurements.map((m) {
        return HistoryEntry(
          timestamp: DateTime.parse(m['timestamp']),
          fillLevel: (m['fill_percent'] ?? 0.0).toDouble(),
        );
      }).toList();

      return bin.copyWith(history: history);
    } catch (e) {
      // Fallback to cache
      final box = await _getBox();
      return box.get(id);
    }
  }

  // Update bin
  static Future<void> updateBin(BinModel bin) async {
    final box = await _getBox();
    await box.put(bin.id, bin);
  }

  // Watch all bins (stream with periodic refresh every 10 seconds)
  static Stream<List<BinModel>> watchAllBins() async* {
    // Initial load
    yield await getAllBins();

    // Refresh every 3 seconds for real-time updates
    await for (var _ in Stream.periodic(const Duration(seconds: 3))) {
      try {
        final bins = await fetchBinsFromApi();
        yield bins;
      } catch (e) {
        yield await getCachedBins();
      }
    }
  }

  // Seed dummy data (for testing/fallback)
  static Future<void> seedDummyData() async {
    final box = await _getBox();

    if (box.isEmpty) {
      final now = DateTime.now();

      final bins = [
        BinModel(
          id: '1',
          name: 'Bin A - Main Entrance',
          location: 'Building A, Floor 1',
          fillLevel: 85,
          status: BinStatus.warning,
          lastUpdated: now,
          history: _generateHistory(85, now),
          heightCm: 50,
        ),
        BinModel(
          id: '2',
          name: 'Bin B - Cafeteria',
          location: 'Building B, Floor 2',
          fillLevel: 95,
          status: BinStatus.full,
          lastUpdated: now,
          history: _generateHistory(95, now),
          heightCm: 50,
        ),
        BinModel(
          id: '3',
          name: 'Bin C - Parking Lot',
          location: 'Outdoor Area',
          fillLevel: 45,
          status: BinStatus.normal,
          lastUpdated: now,
          history: _generateHistory(45, now),
          heightCm: 50,
        ),
        BinModel(
          id: '4',
          name: 'Bin D - Office Wing',
          location: 'Building C, Floor 3',
          fillLevel: 30,
          status: BinStatus.normal,
          lastUpdated: now,
          history: _generateHistory(30, now),
          heightCm: 50,
        ),
        BinModel(
          id: '5',
          name: 'Bin E - Garden Area',
          location: 'Outdoor Garden',
          fillLevel: 60,
          status: BinStatus.normal,
          lastUpdated: now,
          history: _generateHistory(60, now),
          heightCm: 50,
        ),
      ];

      for (var bin in bins) {
        await box.put(bin.id, bin);
      }
    }
  }

  static List<HistoryEntry> _generateHistory(
    double currentLevel,
    DateTime now,
  ) {
    final history = <HistoryEntry>[];
    for (int i = 24; i >= 0; i--) {
      final timestamp = now.subtract(Duration(hours: i));
      final level = (currentLevel - (24 - i) * 2).clamp(0, 100).toDouble();
      history.add(HistoryEntry(timestamp: timestamp, fillLevel: level));
    }
    return history;
  }
}
