import 'package:flutter/material.dart';

import 'package:remessa/views/deposito/radio_deposito.dart';

class RadioGroupDeposito extends StatelessWidget {
  const RadioGroupDeposito({
    Key? key,
    required this.groupValue,
    required this.onChange,
  }) : super(key: key);

  final String groupValue;
  final void Function(String?) onChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RadioDeposito(
          value: "128076-7",
          groupValue: groupValue,
          onChange: onChange,
        ),
        RadioDeposito(
          value: "41500-6",
          groupValue: groupValue,
          onChange: onChange,
        ),
        RadioDeposito(
          value: "43266-0",
          groupValue: groupValue,
          onChange: onChange,
        ),
        RadioDeposito(
          value: "136385-1",
          groupValue: groupValue,
          onChange: onChange,
        ),
        RadioDeposito(
          value: "342-5",
          groupValue: groupValue,
          onChange: onChange,
        ),
        RadioDeposito(
          value: "Recibo Caixa",
          groupValue: groupValue,
          onChange: onChange,
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }
}
