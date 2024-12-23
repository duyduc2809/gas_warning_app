import 'package:flutter/material.dart';
import 'package:gas_alert_app/widget/button_widget.dart';
import 'package:gas_alert_app/widget/slider_widget.dart';

import 'gas_alert_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _gasValue = 0.0;
  int _lightStatus = 0;
  int _runMode = 0;
  int _warningLevel = 0;
  int _warningStatus = 0;
  final _gasAlertService = GasAlertService();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _subscribeToDeviceData();
  }

  void _subscribeToDeviceData() {
    _gasAlertService.getDeviceData('device_id_1').listen(
      (deviceData) {
        setState(() {
          _gasValue = deviceData.gasValue;
          _lightStatus = deviceData.lights;
          _warningLevel = deviceData.warningLevel;
          _runMode = deviceData.runMode;
          _warningStatus = deviceData.warningStatus;
          _isLoading = false;
        });
      },
      onError: (error) {
        print('Error getting device data: $error');
        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Gas Alert App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedOpacity(
              opacity: _warningStatus == 1 ? 1.0 : 0.0,
              duration: const Duration(seconds: 1),
              child: _warningContainer(),
            ),
            _gasValueTitle(),
            _sliderValue(),
            _handleContainer(),
          ],
        ),
      ),
    );
  }

  Widget _gasValueTitle() => Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Center(
            child: Text(
              'Khí Gas: ${_gasValue.toStringAsFixed(2)} PPM',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );

  Widget _sliderValue() => _isLoading
      ? const Center(
          child: CircularProgressIndicator(),
        )
      : Column(
          children: [
            const SizedBox(height: 32),
            Text(
              'Mức độ cảnh báo: ${_warningLevel.toInt()} PPM',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Card(
              child: SliderWidget(
                value: _warningLevel.toDouble(),
                min: 0.0,
                max: 500.0,
                onChanged: (value) {
                  _gasAlertService.updateWarningLevel('device_id_1', value.toInt());
                  setState(() {
                    _warningLevel = value.toInt();
                  });
                },
                label: '${_warningLevel.toStringAsFixed(2)} PPM',
                thumbColor: Colors.green,
                activeColor: Colors.green,
              ),
            ),
          ],
        );

  Widget _handleContainer() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Điều khiển',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            _statusRow(
              title: 'Đèn:',
              status: _lightStatus == 1,
            ),
            _buttonAction(
              onTurnOn: () async {
                await _gasAlertService.updateLightStatus('device_id_1', 1);
                setState(() {
                  _lightStatus = 1;
                });
              },
              onTurnOff: () async {
                await _gasAlertService.updateLightStatus('device_id_1', 0);
                setState(() {
                  _lightStatus = 0;
                });
              },
            ),
            _statusRow(
              title: 'Chế độ cảnh báo:',
              status: _runMode == 1,
            ),
            _buttonAction(
              onTurnOn: () async {
                await _gasAlertService.updateRunMode('device_id_1', 1);
                setState(() {
                  _runMode = 1;
                });
              },
              onTurnOff: () async {
                await _gasAlertService.updateRunMode('device_id_1', 0);
                setState(() {
                  _runMode = 0;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _warningContainer() => const Card(
        elevation: 2,
        color: Colors.red,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'CẢNH BÁO! Mức khí gas vượt ngưỡng an toàn!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
  Widget _buttonAction({
    Function()? onTurnOn,
    Function()? onTurnOff,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ActionButton(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 8,
                ),
                text: 'Bật',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                backGroundColor: Colors.green,
                onTap: onTurnOn,
              ),
              const SizedBox(width: 16.0),
              ActionButton(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 8,
                ),
                text: 'Tắt',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                backGroundColor: Colors.red,
                onTap: onTurnOff,
              ),
            ],
          ),
        ],
      );

  Widget _statusRow({
    required String title,
    required bool status,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            Text(
              status == true ? 'Đang Bật' : 'Đang Tắt',
              style: TextStyle(
                color: status == true ? Colors.green : Colors.red,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
}
