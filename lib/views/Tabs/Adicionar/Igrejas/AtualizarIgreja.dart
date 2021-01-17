import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:remessa/models/widgets/consts.dart';

class AtualizarIgreja extends StatefulWidget {
  @override
  _AtualizarIgrejaState createState() => _AtualizarIgrejaState();
}

class _AtualizarIgrejaState extends State<AtualizarIgreja> {
  final _controllerDistritos = StreamController.broadcast();
  final _controllerIgrejas = StreamController.broadcast();
  final _formKey = GlobalKey<FormState>();
  String antigoDistrito;
  String novoDistrito;
  String antigoNome;
  String novoNome;
  int novoContrato;
  int novoMatricula;

  getData() {
    Stream<QuerySnapshot> distritos = db.collection("distritos").snapshots();

    distritos.listen((event) {
      _controllerDistritos.add(event);
    });
    Stream<QuerySnapshot> igrejas =
        db.collection("igrejas").orderBy('nome').snapshots();

    igrejas.listen((event) {
      _controllerIgrejas.add(event);
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Column(
                children: [
                  StreamBuilder(
                      stream: _controllerIgrejas.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<DropdownMenuItem> distritos = [
                            DropdownMenuItem(
                              child: Text(
                                "Antigo Nome",
                              ),
                            ),
                          ];
                          for (var i = 0; i < snapshot.data.docs.length; i++) {
                            distritos.add(
                              DropdownMenuItem(
                                value: snapshot.data.docs[i]["nome"],
                                child: Text(
                                  snapshot.data.docs[i]["nome"],
                                ),
                              ),
                            );
                          }
                          return DropdownButtonFormField(
                            validator: (value) {
                          if (value == null) {
                            return "Selecione uma Igreja";
                          }
                          return null;
                        },
                            decoration: inputDecoration,
                            onChanged: (value) {
                              setState(() {
                                antigoNome = value;
                              });
                            },
                            hint: Text("Antigo Nome"),
                            onSaved: (newValue) {
                              antigoNome = newValue;
                            },
                            items: distritos,
                            value: antigoNome,
                          );
                        }
                        return Container();
                      }),
                  SizedBox(
                    height: 14,
                  ),
                  TextFormField(
                    onChanged: (newValue) {
                      setState(() => novoNome = newValue);
                    },
                    decoration:
                        inputDecoration.copyWith(labelText: "Novo Nome"),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  StreamBuilder(
                      stream: _controllerDistritos.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<DropdownMenuItem> distritos = [
                            DropdownMenuItem(
                              child: Text(
                                "Antigo Distrito",
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
                              });
                            },
                            hint: Text("Antigo Distrito"),
                            onSaved: (newValue) {
                              antigoDistrito = newValue;
                            },
                            items: distritos,
                            value: antigoDistrito,
                          );
                        }
                        return Container();
                      }),
                  SizedBox(
                    height: 14,
                  ),
                  StreamBuilder(
                      stream: _controllerDistritos.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<DropdownMenuItem> distritos = [
                            DropdownMenuItem(
                              child: Text(
                                "Novo Distrito",
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
                                novoDistrito = value;
                              });
                            },
                            hint: Text("Novo Distrito"),
                            onSaved: (newValue) {
                              novoDistrito = newValue;
                            },
                            items: distritos,
                            value: novoDistrito,
                          );
                        }
                        return Container();
                      }),
                  SizedBox(
                    height: 14,
                  ),
                  TextFormField(
                    onChanged: (newValue) {
                      setState(() => novoContrato = int.parse(newValue));
                    },
                    decoration:
                        inputDecoration.copyWith(labelText: "Novo Contrato"),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  TextFormField(
                    onChanged: (newValue) {
                      setState(() => novoMatricula = int.parse(newValue));
                    },
                    decoration:
                        inputDecoration.copyWith(labelText: "Nova Matricula"),
                  ),
                ],
              ),
            ),
            Builder(
              builder: (context) {
                return RaisedButton(
                  padding: EdgeInsets.all(10),
                  onPressed: () {
                    if (_formKey.currentState != null &&
                        _formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      db
                          .collection("igrejas")
                          .where('nome', isEqualTo: antigoNome)
                          .get()
                          .then((value) {
                        db.collection('igrejas').doc(value.docs.first.id).update({
                          'nome': novoNome,
                          'distrito': novoDistrito,
                          'contrato': novoContrato,
                          'matricula': novoMatricula,
                          'data': null,
                          'marcado': false
                        });
                      });
                      var snackbar = SnackBar(
                          content: Text(
                              "${"Igreja $novoNome foi atualizada com sucesso"}"));
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
    ),
    );
  }
}
