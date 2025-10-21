import 'package:hive_flutter/hive_flutter.dart';
import '../models/bin_model.dart';

class BinRepository {
  static const String _boxName = 'bins';

  static Future<Box<BinModel>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<BinModel>(_boxName);
    }
    return Hive.box<BinModel>(_boxName);
  }

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
        ),
        BinModel(
          id: '2',
          name: 'Bin B - Cafeteria',
          location: 'Building B, Floor 2',
          fillLevel: 95,
          status: BinStatus.full,
          lastUpdated: now,
          history: _generateHistory(95, now),
        ),
        BinModel(
          id: '3',
          name: 'Bin C - Parking Lot',
          location: 'Outdoor Area',
          fillLevel: 45,
          status: BinStatus.normal,
          lastUpdated: now,
          history: _generateHistory(45, now),
        ),
        BinModel(
          id: '4',
          name: 'Bin D - Office Wing',
          location: 'Building C, Floor 3',
          fillLevel: 30,
          status: BinStatus.normal,
          lastUpdated: now,
          history: _generateHistory(30, now),
        ),
        BinModel(
          id: '5',
          name: 'Bin E - Garden Area',
          location: 'Outdoor Garden',
          fillLevel: 60,
          status: BinStatus.normal,
          lastUpdated: now,
          history: _generateHistory(60, now),
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

  static Future<List<BinModel>> getAllBins() async {
    final box = await _getBox();
    return box.values.toList();
  }

  static Future<BinModel?> getBinById(String id) async {
    final box = await _getBox();
    return box.get(id);
  }

  static Future<void> updateBin(BinModel bin) async {
    final box = await _getBox();
    await box.put(bin.id, bin);
  }

  static Stream<List<BinModel>> watchAllBins() async* {
    final box = await _getBox();
    yield box.values.toList();

    await for (var _ in box.watch()) {
      yield box.values.toList();
    }
  }
}
