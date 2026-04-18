import 'package:isar/isar.dart';

part 'sensor_data.g.dart';

/// Source of the sensor data.
enum SensorDataSource {
  /// Mobility (GPS/WiFi).
  mobility,
  /// Physical activity (Pedometer).
  activity,
  /// Social interaction (Communication metadata).
  social,
}

@collection
class SensorData {
  /// Isar Id.
  Id id = Isar.autoIncrement;

  /// Time of the measurement.
  late DateTime timestamp;

  /// Latitude for mobility.
  double? latitude;

  /// Longitude for mobility.
  double? longitude;

  /// Step count for activity.
  int? stepCount;

  /// Social activity count (e.g., number of calls/messages).
  int? socialActivityCount;

  /// Source of the data.
  @enumerated
  late SensorDataSource source;
}
