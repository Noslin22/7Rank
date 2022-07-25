import 'package:flutter/material.dart';

import 'package:remessa/views/deposito/radio_deposito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RadioGroupDeposito extends StatelessWidget {
  const RadioGroupDeposito({
    Key? key,
    required this.groupValue,
    required this.onChange,
    required this.values,
    required this.preferences,
  }) : super(key: key);

  final String groupValue;
  final void Function(String?) onChange;
  final List<String> values;
  final SharedPreferences? preferences;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        values.length,
        (index) => RadioDeposito(
          value: values[index],
          groupValue: groupValue,
          onChange: onChange,
          preferences: preferences,
        ),
      ),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }
}
