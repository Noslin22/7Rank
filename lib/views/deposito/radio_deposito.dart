import 'package:flutter/material.dart';
import 'package:remessa/models/widgets/consts.dart';
import 'package:remessa/views/deposito/common_deposito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RadioDeposito extends StatelessWidget {
  RadioDeposito({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.preferences,
    required this.onChange,
  }) : super(key: key);

  final String value;
  final String groupValue;
  final void Function(String?) onChange;
  final TextEditingController controller = TextEditingController();
  final SharedPreferences? preferences;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Gerenciar Conta"),
            content: TextField(
              controller: controller..text = value,
              decoration: inputDecoration.copyWith(
                hintText: "Digite a conta",
              ),
            ),
            actions: [
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: () {
                      contas.remove(value);
                      preferences!.setStringList("contas", contas);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Text("Excluir"),
                        Icon(Icons.delete),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      contas.add(controller.text);
                      preferences!.setStringList("contas", contas);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Text("Novo"),
                        Icon(Icons.add),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    onPressed: () {
                      contas[contas.indexOf(value)] = controller.text;
                      preferences!.setStringList("contas", contas);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Text("Salvar"),
                        Icon(Icons.check),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: groupValue,
            onChanged: onChange,
          ),
          Text(value),
        ],
      ),
    );
  }
}
