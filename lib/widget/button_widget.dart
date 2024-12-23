import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;

  final Color? backGroundColor;
  final Color? textColor;
  final TextStyle? style;
  final Function()? onTap;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  const ActionButton({
    super.key,
    required this.text,
    BuildContext? context,
    this.backGroundColor,
    this.textColor,
    this.onTap,
    this.style,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
        decoration: BoxDecoration(
          color: backGroundColor,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: style,
          ),
        ),
      ),
    );
  }
}
