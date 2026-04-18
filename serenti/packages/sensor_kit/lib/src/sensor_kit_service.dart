import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:pedometer/pedometer.dart';
import 'package:phone_state/phone_state.dart';

/// Types of sensor data collected.
enum SensorType {
  /// Mobility (GPS).
  mobility,
  /// Physical activity (Steps).
  activity,
  /// Social interaction (Call events).
  social,
}

/// Data event from sensors.
class SensorEvent {
  /// Constructor.
  const SensorEvent({
    required this.type,
    required this.timestamp,
    this.latitude,
    this.longitude,
    this.stepCount,
    this.socialActivityCount,
  });

  /// Type of sensor.
  final SensorType type;

  /// Time of event.
  final DateTime timestamp;

  /// Latitude (for mobility).
  final double? latitude;

  /// Longitude (for mobility).
  final double? longitude;

  /// Step count (for activity).
  final int? stepCount;

  /// Social activity count.
  final int? socialActivityCount;
}

/// {@template sensor_kit_service}
/// Service responsible for collecting sensor data in background.
/// {@endtemplate}
class SensorKitService {
  /// {@macro sensor_kit_service}
  SensorKitService();

  final _controller = StreamController<SensorEvent>.broadcast();

  /// Stream of sensor events.
  Stream<SensorEvent> get sensorEvents => _controller.stream;

  StreamSubscription<Position>? _positionSubscription;
  StreamSubscription<StepCount>? _pedometerSubscription;
  StreamSubscription<PhoneState>? _phoneStateSubscription;

  /// Starts collecting data.
  Future<void> start() async {
    // 1. Mobility
    final locationSettings = AppleSettings(
      accuracy: LocationAccuracy.medium,
      distanceFilter: 100,
      pauseLocationUpdatesAutomatically: true,
      showBackgroundLocationIndicator: false,
    );
    // Note: AndroidSettings might be needed for more specific config, 
    // but balanced accuracy works well for battery.
    
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((position) {
      _controller.add(
        SensorEvent(
          type: SensorType.mobility,
          timestamp: DateTime.now(),
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
    });

    // 2. Activity (Pedometer)
    _pedometerSubscription = Pedometer.stepCountStream.listen((event) {
      _controller.add(
        SensorEvent(
          type: SensorType.activity,
          timestamp: DateTime.now(),
          stepCount: event.steps,
        ),
      );
    }, onError: (error) {
      // Handle error (e.g., permission denied)
    });

    // 3. Social (Phone State)
    _phoneStateSubscription = PhoneState.stream.listen((event) {
      // We only count transitions to CALL_STARTED as a "social event" 
      // representing a conversation started.
      if (event.status == PhoneStateStatus.CALL_STARTED) {
        _controller.add(
          SensorEvent(
            type: SensorType.social,
            timestamp: DateTime.now(),
            socialActivityCount: 1,
          ),
        );
      }
    });
  }

  /// Stops collecting data.
  Future<void> stop() async {
    await _positionSubscription?.cancel();
    await _pedometerSubscription?.cancel();
    await _phoneStateSubscription?.cancel();
  }

  /// Closes the service.
  void dispose() {
    _controller.close();
  }
}
