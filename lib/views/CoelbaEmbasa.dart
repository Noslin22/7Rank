import 'dart:async';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:remessa/models/widgets/consts.dart';
import 'package:url_launcher/url_launcher.dart';

class CoelbaEmbasa extends StatefulWidget {
  final String gerenciador;
  const CoelbaEmbasa(this.gerenciador);
  @override
  _CoelbaEmbasaState createState() => _CoelbaEmbasaState();
}

class _CoelbaEmbasaState extends State<CoelbaEmbasa> {
  TextEditingController _controller = TextEditingController();
  String valor = 'Igreja';
  GlobalKey<AutoCompleteTextFieldState<String>> key =
      new GlobalKey<AutoCompleteTextFieldState<String>>();
  final _controllerIgrejas = StreamController.broadcast();
  final _controllerIgreja = StreamController.broadcast();
  final _controllerRank = StreamController.broadcast();
  final _formKey = GlobalKey<FormState>();
  bool _coelba = true;
  bool mostrar = false;
  bool mostrar2 = false;

  save() {
    if (_formKey.currentState != null && _formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
  }

  _igrejas() {
    Stream<QuerySnapshot> igrejas =
        db.collection("igrejas").orderBy('nome').snapshots();

    igrejas.listen((event) {
      _controllerIgrejas.add(event);
    });
  }

  Stream<QuerySnapshot> _pegarDados() {
    int i = int.parse(_controller.text);
    Stream<QuerySnapshot> rank = db
        .collection("igrejas")
        .where(_coelba ? "contrato" : "matricula",
            isEqualTo: _controller.text.contains(RegExp(r'A-Z'))
                ? _controller.text
                : i)
        .snapshots();
    Stream<QuerySnapshot> igreja =
        db.collection("igrejas").where('nome', isEqualTo: valor).snapshots();

    rank.listen((event) {
      _controllerRank.add(event);
    });
    igreja.listen((event) {
      _controllerIgreja.add(event);
    });

    return null;
  }

  @override
  void initState() {
    _igrejas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Coelba/Embasa"),
        centerTitle: true,
        actions: kIsWeb ? actions(widget.gerenciador, context, 'coelba') : [],
      ),
      drawer: kIsWeb ? null : drawer(widget.gerenciador, context, 'coelba'),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        _coelba = true;
                        mostrar = false;
                      });
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.wb_incandescent,
                          color: _coelba ? Colors.blue : Colors.black,
                        ),
                        Text("Coelba"),
                      ],
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        _coelba = false;
                        mostrar = false;
                      });
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.shopping_basket,
                          color: !_coelba ? Colors.blue : Colors.black,
                        ),
                        Text("Embasa"),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  RaisedButton(
                    onPressed: () {
                      _pegarDados();
                      _controllerRank.stream != null
                          ? setState(() => mostrar = true)
                          // ignore: unnecessary_statements
                          : null;
                    },
                    child: Text(
                      "Pesquisar",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _controller.text = value;
                        });
                      },
                      textAlign: TextAlign.end,
                      decoration: inputDecoration.copyWith(
                          labelText: _coelba ? "Contrato" : "Matricula"),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  RaisedButton(
                    onPressed: () {
                      _pegarDados();
                      save();
                      setState(() {
                        mostrar2 = true;
                      });
                      print(mostrar2);
                    },
                    child: Text(
                      "Pesquisar",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: StreamBuilder(
                        stream: _controllerIgrejas.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<DropdownMenuItem> distritos = [
                              DropdownMenuItem(
                                value: 'Igreja',
                                child: Text(
                                  "Igreja",
                                ),
                              ),
                            ];
                            for (var i = 0;
                                i < snapshot.data.docs.length;
                                i++) {
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
                                if (value == '' || value == null) {
                                  return 'Selecione uma Igreja';
                                }
                                return null;
                              },
                              icon: Container(),
                              decoration: inputDecoration,
                              onChanged: (value) {
                                setState(() {
                                  valor = value;
                                });
                              },
                              hint: Text("Igreja"),
                              onSaved: (newValue) {
                                setState(() {
                                  valor = newValue;
                                });
                              },
                              items: distritos,
                              value: valor,
                            );
                          }
                          return Container();
                        }),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              mostrar
                  ? StreamBuilder(
                      stream: _controllerRank.stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else if (snapshot.hasData) {
                          QuerySnapshot querySnapshot = snapshot.data;
                          return Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.blue, width: 2.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: querySnapshot.docs.length,
                              itemBuilder: (context, index) {
                                List<DocumentSnapshot> igrejas =
                                    querySnapshot.docs.toList();
                                DocumentSnapshot documentSnapshot =
                                    igrejas[index];
                                return ListView(
                                  shrinkWrap: true,
                                  children: [
                                    ListTile(
                                      title: Text(
                                          "Distrito: ${documentSnapshot["distrito"]}"),
                                    ),
                                    ListTile(
                                      title: Text(
                                          "Igreja: ${documentSnapshot["nome"]}"),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        } else {
                          var snackbar =
                              SnackBar(content: Text("Igreja não encontrada"));
                          Scaffold.of(context).showSnackBar(snackbar);
                        }
                        return Container();
                      },
                    )
                  : Container(),
              mostrar
                  ? SizedBox(
                      height: 20,
                    )
                  : Container(),
              mostrar2
                  ? StreamBuilder(
                      stream: _controllerIgrejas.stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else if (snapshot.hasData) {
                          QuerySnapshot querySnapshot = snapshot.data;
                          return Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.blue, width: 2.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: querySnapshot.docs.length,
                              itemBuilder: (context, index) {
                                List<DocumentSnapshot> igrejas =
                                    querySnapshot.docs.toList();
                                DocumentSnapshot documentSnapshot =
                                    igrejas[index];
                                return ListView(
                                  shrinkWrap: true,
                                  children: [
                                    ListTile(
                                      title: Text(
                                          "Distrito: ${documentSnapshot["distrito"]}"),
                                    ),
                                    ListTile(
                                      title: Text(
                                          "Igreja: ${documentSnapshot["contrato"]}"),
                                    ),
                                    ListTile(
                                      title: Text(
                                          "Igreja: ${documentSnapshot["matricula"]}"),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        } else {
                          var snackbar =
                              SnackBar(content: Text("Igreja não encontrada"));
                          Scaffold.of(context).showSnackBar(snackbar);
                        }
                        return Container();
                      },
                    )
                  : Container(),
              mostrar2
                  ? SizedBox(
                      height: 20,
                    )
                  : Container(),
              RaisedButton(
                onPressed: () async {
                  await launch(_coelba
                      ? "http://servicos.coelba.com.br/servicos-ao-cliente/Pages/login-av.aspx"
                      : "http://www.embasa2.ba.gov.br/novo/central-servicos/?mod=sua-conta&a=2via");
                },
                color: Colors.blue,
                child: Text(
                  "Ir para o Site",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
