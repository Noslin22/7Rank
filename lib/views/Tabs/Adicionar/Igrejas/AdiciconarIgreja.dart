import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:remessa/models/widgets/consts.dart';

class AdicionarIgreja extends StatefulWidget {
  @override
  _AdicionarIgrejaState createState() => _AdicionarIgrejaState();
}

class _AdicionarIgrejaState extends State<AdicionarIgreja> {
  final _controllerDistrito = StreamController.broadcast();
  final _formKey = GlobalKey<FormState>();
  String nome;
  String cod;
  String matricula;
  String contrato;
  String distrito;

  getData() {
    Stream<QuerySnapshot> distritos = db.collection("distritos").snapshots();

    distritos.listen((event) {
      _controllerDistrito.add(event);
    });
  }

  @override
  void initState() {
    super.initState();
    // widget.setName('Adicionar Igreja');
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
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value == '') {
                          return "Digite o Código da Igreja";
                        }
                        return null;
                      },
                      onChanged: (newValue) {
                        setState(() => cod = newValue);
                      },
                      decoration: inputDecoration.copyWith(labelText: "Código"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value == '') {
                          return "Digite o Nome da Igreja";
                        }
                        return null;
                      },
                      onChanged: (newValue) {
                        setState(() => nome = newValue);
                      },
                      decoration: inputDecoration.copyWith(labelText: "Nome"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    StreamBuilder(
                        stream: _controllerDistrito.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<DropdownMenuItem> distritos = [
                              DropdownMenuItem(
                                child: Text(
                                  "Distrito",
                                ),
                              ),
                            ];
                            for (var i = 0;
                                i < snapshot.data.docs.length;
                                i++) {
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
                                  distrito = value;
                                });
                              },
                              hint: Text("Distritos"),
                              onSaved: (newValue) {},
                              items: distritos,
                              value: distrito,
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
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value == '') {
                    return "Digite a Conta Contrato";
                  }
                  return null;
                },
                onChanged: (newValue) {
                  setState(() => contrato = newValue);
                },
                decoration: inputDecoration.copyWith(labelText: "Contrato"),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value == '') {
                    return "Digite a Matrícula";
                  }
                  return null;
                },
                onChanged: (newValue) {
                  setState(() => matricula = newValue);
                },
                decoration: inputDecoration.copyWith(labelText: "Matricula"),
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
                        db.collection("igrejas").add({
                          'cod': int.parse(cod),
                          'nome': nome,
                          'matricula': int.parse(matricula),
                          'contrato': int.parse(contrato),
                          'distrito': distrito,
                          'data': null,
                          'marcado': false,
                        });
                        var snackbar = SnackBar(
                            content: Text(
                                "${"Igreja $nome foi adicionada com sucesso"}"));
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
      ),
    );
  }
}
