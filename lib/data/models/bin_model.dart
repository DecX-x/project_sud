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

  @HiveField(7)
  final double? heightCm;

  @HiveField(8)
  final double? distanceCm;

  BinModel({
    required this.id,
    required this.name,
    required this.location,
    required this.fillLevel,
    required this.status,
    required this.lastUpdated,
    this.history = const [],
    this.heightCm,
    this.distanceCm,
  });

  // Factory constructor from API response (single bin)
  factory BinModel.fromApi(Map<String, dynamic> json) {
    // Single bin endpoint may have different field names
    double fillLevel = 0.0;
    if (json['last_fill_percent'] != null) {
      fillLevel = (json['last_fill_percent'] as num).toDouble();
    } else if (json['fill_percent'] != null) {
      fillLevel = (json['fill_percent'] as num).toDouble();
    }

    final status = _getStatusFromFillLevel(fillLevel);

    DateTime lastUpdated = DateTime.now();
    if (json['last_update'] != null) {
      lastUpdated = DateTime.parse(json['last_update']);
    } else if (json['last_measurement_time'] != null) {
      lastUpdated = DateTime.parse(json['last_measurement_time']);
    }

    return BinModel(
      id: json['id'].toString(),
      name: json['name'] ?? 'Unknown Bin',
      location: json['location'] ?? 'Unknown Location',
      fillLevel: fillLevel,
      status: status,
      lastUpdated: lastUpdated,
      heightCm: json['height_cm']?.toDouble(),
      distanceCm: (json['last_distance_cm'] ?? json['distance_cm'])?.toDouble(),
      history: [],
    );
  }

  // Factory constructor from API extended response
  factory BinModel.fromApiExtended(Map<String, dynamic> json) {
    // API returns: last_fill_percent, last_distance_cm, last_update
    double fillLevel = 0.0;
    if (json['last_fill_percent'] != null) {
      fillLevel = (json['last_fill_percent'] as num).toDouble();
    } else if (json['fill_percent'] != null) {
      fillLevel = (json['fill_percent'] as num).toDouble();
    }

    final status = _getStatusFromFillLevel(fillLevel);

    // API returns: last_update
    DateTime lastUpdated = DateTime.now();
    if (json['last_update'] != null) {
      lastUpdated = DateTime.parse(json['last_update']);
    } else if (json['last_measurement_time'] != null) {
      lastUpdated = DateTime.parse(json['last_measurement_time']);
    }

    return BinModel(
      id: json['id'].toString(),
      name: json['name'] ?? 'Unknown Bin',
      location: json['location'] ?? 'Unknown Location',
      fillLevel: fillLevel,
      status: status,
      lastUpdated: lastUpdated,
      heightCm: json['height_cm']?.toDouble(),
      distanceCm: (json['last_distance_cm'] ?? json['distance_cm'])?.toDouble(),
      history: [],
    );
  }

  static BinStatus _getStatusFromFillLevel(double fillLevel) {
    if (fillLevel >= 80) {
      return BinStatus.full;
    } else if (fillLevel >= 60) {
      return BinStatus.warning;
    } else {
      return BinStatus.normal;
    }
  }

  BinModel copyWith({
    String? id,
    String? name,
    String? location,
    double? fillLevel,
    BinStatus? status,
    DateTime? lastUpdated,
    List<HistoryEntry>? history,
    double? heightCm,
    double? distanceCm,
  }) {
    return BinModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      fillLevel: fillLevel ?? this.fillLevel,
      status: status ?? this.status,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      history: history ?? this.history,
      heightCm: heightCm ?? this.heightCm,
      distanceCm: distanceCm ?? this.distanceCm,
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
