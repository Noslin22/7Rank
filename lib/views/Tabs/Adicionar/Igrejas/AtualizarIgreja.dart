import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:remessa/models/widgets/consts.dart';

class AtualizarIgreja extends StatefulWidget {
  @override
  _AtualizarIgrejaState createState() => _AtualizarIgrejaState();
}

class _AtualizarIgrejaState extends State<AtualizarIgreja> {
  final _controllerDistritos = StreamController.broadcast();
  TextEditingController _controllerCod = TextEditingController();
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerContrato = TextEditingController();
  TextEditingController _controllerMatricula = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> igrejas = [];
  String distrito;
  String nome;
  String contrato;
  String matricula;

  getData() {
    Stream<QuerySnapshot> distritos = db.collection("distritos").snapshots();

    distritos.listen((event) {
      _controllerDistritos.add(event);
    });
  }

  void getIgrejas() {
    db.collection("igrejas").orderBy("cod").get().then((value) {
      List<String> values = value.docs
          .map((e) => "${e["cod"].toString()} - ${e["nome"].toString()}");
      igrejas.addAll(values);
    });
  }

  void getIgreja(String cod) {
    db
        .collection("igrejas")
        .where("cod", isEqualTo: int.parse(cod))
        .get()
        .then((value) {
      QueryDocumentSnapshot values = value.docs.first;
      setState(() {
        _controllerNome.text = values.get("nome");
        distrito = values.get("distrito");
        _controllerContrato.text = values.get("contrato").toString();
        _controllerMatricula.text = values.get("matricula").toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    getIgrejas();
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
                    TypeAheadField<String>(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _controllerCod,
                        decoration:
                            inputDecoration.copyWith(labelText: "Código"),
                      ),
                      debounceDuration: Duration(milliseconds: 600),
                      suggestionsCallback: (pattern) {
                        return igrejas.where((element) => element
                            .toLowerCase()
                            .contains(pattern.toLowerCase()));
                      },
                      onSuggestionSelected: (suggestion) {
                        _controllerCod.text = suggestion.split(" ")[0];
                        getIgreja(suggestion.split(" ")[0]);
                      },
                      itemBuilder: (context, itemData) => ListTile(
                        title: Text("$itemData"),
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    TextFormField(
                      controller: _controllerNome,
                      onChanged: (newValue) {
                        setState(() => nome = newValue);
                      },
                      decoration: inputDecoration.copyWith(labelText: "Nome"),
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
                              hint: Text("Distrito"),
                              onSaved: (newValue) {
                                distrito = newValue;
                              },
                              items: distritos,
                              value: distrito,
                            );
                          }
                          return Container();
                        }),
                    SizedBox(
                      height: 14,
                    ),
                    TextFormField(
                      controller: _controllerContrato,
                      onChanged: (newValue) {
                        setState(() => contrato = newValue);
                      },
                      decoration:
                          inputDecoration.copyWith(labelText: "Contrato"),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    TextFormField(
                      controller: _controllerMatricula,
                      onChanged: (newValue) {
                        setState(() => matricula = newValue);
                      },
                      decoration:
                          inputDecoration.copyWith(labelText: "Matricula"),
                    ),
                    SizedBox(
                      height: 14,
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
                            .where('cod',
                                isEqualTo: int.parse(_controllerCod.text))
                            .get()
                            .then((value) {
                          db
                              .collection('igrejas')
                              .doc(value.docs.first.id)
                              .update({
                            'nome': nome,
                            'distrito': distrito,
                            'contrato': int.parse(contrato),
                            'matricula': int.parse(matricula),
                            'data': null,
                            'marcado': false
                          });
                        });
                        var snackbar = SnackBar(
                            content: Text(
                                "${"Igreja $nome foi atualizada com sucesso"}"));
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
