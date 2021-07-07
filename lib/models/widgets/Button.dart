import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Color? color;
  final String? label;
  final TextStyle? style;
  final Widget? child;
  final EdgeInsets? padding;
  final VoidCallback onPressed;
  const Button({
    this.color,
    this.label,
    required this.onPressed,
    this.style,
    this.child,
    this.padding = const EdgeInsets.all(10),
  });
  Button.blue10({
    this.color = Colors.blue,
    this.label,
    this.style,
    this.child,
    this.padding = const EdgeInsets.all(10),
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: child ??
              Text(
                label!,
                style: style ??
                    TextStyle(
                      color: Colors.white,
                    ),
              ),
        ),
      ),
    );
  }
}
