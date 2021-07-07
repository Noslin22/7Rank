import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:remessa/models/widgets/Button.dart';
import 'package:remessa/models/widgets/consts.dart';

class DeletarDistrito extends StatefulWidget {
  @override
  _DeletarDistritoState createState() => _DeletarDistritoState();
}

class _DeletarDistritoState extends State<DeletarDistrito> {
  StreamController<QuerySnapshot> _controllerDistritos =
      StreamController.broadcast();
  final _formKey = GlobalKey<FormState>();
  String? antigoDistrito;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    Stream<QuerySnapshot> distritos = db.collection("distritos").snapshots();

    distritos.listen((event) {
      _controllerDistritos.add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    getData();
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
                  StreamBuilder<QuerySnapshot>(
                      stream: _controllerDistritos.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<DropdownMenuItem> distritos = [
                            DropdownMenuItem(
                              child: Text(
                                "Distrito",
                              ),
                            ),
                          ];
                          for (var i = 0; i < snapshot.data!.docs.length; i++) {
                            distritos.add(
                              DropdownMenuItem(
                                value: snapshot.data!.docs[i].id,
                                child: Text(
                                  snapshot.data!.docs[i].id,
                                ),
                              ),
                            );
                          }
                          return DropdownButtonFormField(
                            decoration: inputDecoration,
                            onChanged: (dynamic value) {
                              setState(() {
                                antigoDistrito = value;
                              });
                            },
                            hint: Text("Distritos"),
                            onSaved: (dynamic newValue) {},
                            items: distritos,
                            value: antigoDistrito,
                            validator: (dynamic value) {
                              if (value == null) {
                                return "Escolha algum distrito";
                              }
                              return null;
                            },
                          );
                        }
                        return Container();
                      }),
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
                      db.collection("distritos").doc(antigoDistrito).delete();
                      var snackbar = SnackBar(
                          content: Text(
                              "${"Distrito $antigoDistrito foi deletado com sucesso"}"));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      Timer(Duration(seconds: 6), () {
                        Navigator.pushReplacementNamed(context, 'home');
                      });
                    }
                  },
                  label: "Deletar",
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
