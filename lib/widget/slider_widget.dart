import 'package:flutter/material.dart';

class SliderWidget extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? secondaryActiveColor;
  final double? height;
  final Color? thumbColor;
  final int? divisions;
  const SliderWidget({
    super.key,
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.secondaryActiveColor,
    this.height,
    this.thumbColor,
    this.divisions,
  });

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  double _currentValue = 0.0;
  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  void _onChanged(double value) {
    setState(() {
      _currentValue = value;
    });
    widget.onChanged(_currentValue);
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentValue,
      min: widget.min,
      max: widget.max,
      onChanged: _onChanged,
      label: widget.label,
      activeColor: widget.activeColor,
      inactiveColor: widget.inactiveColor,
      secondaryActiveColor: widget.secondaryActiveColor,
      divisions: widget.divisions,
      thumbColor: widget.thumbColor,
    );
  }
}
