import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:remessa/models/widgets/Button.dart';
import 'package:remessa/models/widgets/consts.dart';

class AdicionarDistrito extends StatefulWidget {
  @override
  _AdicionarDistritoState createState() => _AdicionarDistritoState();
}

class _AdicionarDistritoState extends State<AdicionarDistrito> {
  final _formKey = GlobalKey<FormState>();
  String? distrito;
  String? pastor;
  String? regiao;

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
                return Button.blue10(
                  onPressed: () {
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      int faltam = 0;
                      db
                          .collection("distritos")
                          .where("distrito", isEqualTo: distrito)
                          .get()
                          .then((value) {
                        faltam = value.docs.length;
                      });
                      db.collection("distritos").doc(distrito).set({
                        "faltam": faltam,
                        "pastor": pastor,
                        "regiao": regiao,
                        "data": Timestamp.now(),
                      });
                      var snackbar = SnackBar(
                          content: Text(
                              "${"Distrito $distrito foi adicionado com sucesso"}"));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      Timer(Duration(seconds: 6), () {
                        Navigator.pushReplacementNamed(context, 'home');
                      });
                    }
                  },
                  label: "Adicionar",
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
