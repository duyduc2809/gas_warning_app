class DeviceData {
  final double gasValue;
  final int lights;
  final String name;
  final int runMode;
  final int warningLevel;
  final int warningStatus;

  DeviceData({
    required this.gasValue,
    required this.lights,
    required this.name,
    required this.runMode,
    required this.warningLevel,
    required this.warningStatus,
  });

  factory DeviceData.fromMap(Map<String, dynamic> map) {
    return DeviceData(
      gasValue: map['gas_value']?.toDouble() ?? 0.0,
      lights: map['lights'] ?? 0,
      name: map['name'] ?? 'Unknown',
      runMode: map['run_mode'] ?? 0,
      warningLevel: map['warning_level'] ?? 0,
      warningStatus: map['warning_status'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gas_value': gasValue,
      'lights': lights,
      'name': name,
      'run_mode': runMode,
      'warning_level': warningLevel,
      'warning_status': warningStatus,
    };
  }
}
