import 'package:hive/hive.dart';

part 'bin_model.g.dart';

@HiveType(typeId: 0)
enum BinStatus {
  @HiveField(0)
  normal,
  @HiveField(1)
  warning,
  @HiveField(2)
  full,
}

@HiveType(typeId: 1)
class BinModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String location;

  @HiveField(3)
  final double fillLevel; // 0-100

  @HiveField(4)
  final BinStatus status;

  @HiveField(5)
  final DateTime lastUpdated;

  @HiveField(6)
  final List<HistoryEntry> history;

  BinModel({
    required this.id,
    required this.name,
    required this.location,
    required this.fillLevel,
    required this.status,
    required this.lastUpdated,
    this.history = const [],
  });

  BinModel copyWith({
    String? id,
    String? name,
    String? location,
    double? fillLevel,
    BinStatus? status,
    DateTime? lastUpdated,
    List<HistoryEntry>? history,
  }) {
    return BinModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      fillLevel: fillLevel ?? this.fillLevel,
      status: status ?? this.status,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      history: history ?? this.history,
    );
  }
}

@HiveType(typeId: 2)
class HistoryEntry {
  @HiveField(0)
  final DateTime timestamp;

  @HiveField(1)
  final double fillLevel;

  HistoryEntry({required this.timestamp, required this.fillLevel});
}
