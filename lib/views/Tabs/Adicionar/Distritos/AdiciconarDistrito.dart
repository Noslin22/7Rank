import 'dart:async';
import 'package:flutter/material.dart';
import 'package:remessa/models/widgets/consts.dart';

class AdicionarDistrito extends StatefulWidget {
  @override
  _AdicionarDistritoState createState() => _AdicionarDistritoState();
}

class _AdicionarDistritoState extends State<AdicionarDistrito> {
  final _formKey = GlobalKey<FormState>();
  String distrito;
  String pastor;
  String regiao;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value == '') {
                        return "Digite o Distrito";
                      }
                      return null;
                    },
                    onChanged: (newValue) {
                      setState(() => distrito = newValue);
                    },
                    decoration: inputDecoration.copyWith(labelText: "Distrito"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value == '') {
                        return "Digite o Nome do Pastor";
                      }
                      return null;
                    },
                    onChanged: (newValue) {
                      setState(() => pastor = newValue);
                    },
                    decoration: inputDecoration.copyWith(labelText: "Pastor"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value == '') {
                        return "Digite a Região";
                      }
                      return null;
                    },
                    onChanged: (newValue) {
                      setState(() => regiao = newValue);
                    },
                    decoration: inputDecoration.copyWith(labelText: "Região"),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Builder(
              builder: (context) {
                return RaisedButton(
                  padding: EdgeInsets.all(10),
                  onPressed: () {
                    if (_formKey.currentState != null &&
                        _formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      db.collection("distritos").doc(distrito).set({
                        "faltam": 0,
                        "pastor": pastor,
                        "regiao": regiao,
                      });
                      var snackbar = SnackBar(
                          content: Text(
                              "${"Distrito $distrito foi adicionado com sucesso"}"));
                      Scaffold.of(context).showSnackBar(snackbar);
                      Timer(Duration(seconds: 6), () {
                        Navigator.pushReplacementNamed(context, 'home');
                      });
                    }
                  },
                  color: Colors.blue,
                  child: Text(
                    "Adicionar",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
