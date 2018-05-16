import 'package:flutter/material.dart';
import 'dashboardSensor.dart';
import 'audioSensor.dart';
import 'lockSensor.dart';

class SensorsWidget extends StatelessWidget {
  static const String _AUDIO = 'audio';
  static const String _LOCK = 'door';
  static const String _DASHBOARD_LIGHT = 'dashboard_light';

  SensorsWidget({
    this.sensorType,
    this.active,
    this.value
  });

  final String sensorType;
  final bool active;
  final String value;

  @override
  Widget build(BuildContext context) {
    switch (sensorType) {
      case _AUDIO :
        return AudioSensor(
          active: active,
          value: value
        );
      case _LOCK :
        return LockSensor(
          active: active,
          value: value
        );
      case _DASHBOARD_LIGHT :
        return DashboardSensor(
          active: active,
          value: value
        );
      default:
        return null;
    }
  }
}

