import 'package:flutter/material.dart';

class RadioDeposito extends StatelessWidget {
  const RadioDeposito({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChange,
  }) : super(key: key);

  final String value;
  final String groupValue;
  final void Function(String?) onChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChange,
        ),
        Text(value),
      ],
    );
  }
}
