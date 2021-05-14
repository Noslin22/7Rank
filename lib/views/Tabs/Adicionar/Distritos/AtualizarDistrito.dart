import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:remessa/models/widgets/consts.dart';

class AtualizarDistrito extends StatefulWidget {
  @override
  _AtualizarDistritoState createState() => _AtualizarDistritoState();
}

class _AtualizarDistritoState extends State<AtualizarDistrito> {
  TextEditingController _controllerDistrito = TextEditingController();
  TextEditingController _controllerPastor = TextEditingController();
  TextEditingController _controllerRegiao = TextEditingController();
  final _controllerDistritos = StreamController.broadcast();
  final _formKey = GlobalKey<FormState>();
  String antigoDistrito;
  String novoDistrito;
  String pastor;
  String regiao;

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

  void getDistrito() {
    db.collection("distritos").doc(antigoDistrito).get().then((value) {
      _controllerDistrito.text = value.id;
      _controllerPastor.text = value.get("pastor");
      _controllerRegiao.text = value.get("regiao");
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
                  StreamBuilder(
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
                          for (var i = 0; i < snapshot.data.docs.length; i++) {
                            distritos.add(
                              DropdownMenuItem(
                                value: snapshot.data.docs[i].id,
                                child: Text(
                                  snapshot.data.docs[i].id,
                                ),
                              ),
                            );
                          }
                          return DropdownButtonFormField(
                            decoration: inputDecoration,
                            onChanged: (value) {
                              setState(() {
                                antigoDistrito = value;
                                getDistrito();
                              });
                            },
                            hint: Text("Distritos"),
                            onSaved: (newValue) {
                              antigoDistrito = newValue;
                            },
                            items: distritos,
                            value: antigoDistrito,
                            validator: (value) {
                              if (value == null) {
                                return "Escolha algum distrito";
                              }
                              return null;
                            },
                          );
                        }
                        return Container();
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _controllerDistrito,
                    validator: (value) {
                      if (value == null || value == '') {
                        return "Digite o novo Distrito";
                      }
                      return null;
                    },
                    onChanged: (newValue) {
                      setState(() => novoDistrito = newValue);
                    },
                    decoration: inputDecoration.copyWith(labelText: "Distrito"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _controllerPastor,
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
                    controller: _controllerRegiao,
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
                      db.collection("distritos").doc(antigoDistrito).delete();
                      db.collection("distritos").doc(novoDistrito).set({
                        "faltam": 0,
                        "pastor": pastor,
                        "regiao": regiao,
                      });
                      var snackbar = SnackBar(
                          content: Text(
                              "${"Distrito $novoDistrito foi atualizado com sucesso"}"));
                      Scaffold.of(context).showSnackBar(snackbar);
                      Timer(Duration(seconds: 6), () {
                        Navigator.pushReplacementNamed(context, 'home');
                      });
                    }
                  },
                  color: Colors.blue,
                  child: Text(
                    "Atualizar",
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
