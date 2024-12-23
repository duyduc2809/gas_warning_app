import 'package:firebase_database/firebase_database.dart';

import 'device_data.dart';

class GasAlertService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Stream<DeviceData> getDeviceData(String deviceId) {
    return _database.ref().child('devices').child(deviceId).onValue.map((event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        return DeviceData.fromMap(Map<String, dynamic>.from(dataSnapshot.value as Map<dynamic, dynamic>));
      } else {
        throw Exception('No data available for device $deviceId');
      }
    });
  }

  Future<void> updateSingleField(String deviceId, String field, dynamic value) {
    return _database.ref().child('devices').child(deviceId).update({
      field: value,
    });
  }

  Future<void> updateLightStatus(String deviceId, int status) {
    return updateSingleField(deviceId, 'lights', status);
  }

  Future<void> updateRunMode(String deviceId, int mode) {
    return updateSingleField(deviceId, 'run_mode', mode);
  }

  Future<void> updateWarningLevel(String deviceId, int level) {
    return updateSingleField(deviceId, 'warning_level', level);
  }
}
