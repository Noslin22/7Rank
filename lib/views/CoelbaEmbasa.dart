import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:remessa/models/widgets/consts.dart';
import 'package:url_launcher/url_launcher.dart';

class CoelbaEmbasa extends StatefulWidget {
  final String gerenciador;
  const CoelbaEmbasa(this.gerenciador);
  @override
  _CoelbaEmbasaState createState() => _CoelbaEmbasaState();
}

class _CoelbaEmbasaState extends State<CoelbaEmbasa> {
  TextEditingController _controllerPesquisa = TextEditingController();
  StreamController _controllerIgreja = StreamController.broadcast();
  StreamController _controllerRank = StreamController.broadcast();
  TextEditingController _controller = TextEditingController();
  List<String> igrejas = [];
  bool mostrar2 = false;
  bool mostrar = false;
  bool _coelba = true;
  String valor;

  void getIgrejas() {
    db.collection("igrejas").orderBy("cod").get().then((value) {
      List<String> values = value.docs
          .map((e) => "${e["cod"].toString()} - ${e["nome"].toString()}");
      igrejas.addAll(values);
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

    rank.listen((event) {
      _controllerRank.add(event);
    });

    return null;
  }

  void _getIgreja(String cod) {
    db
        .collection("igrejas")
        .where("cod", isEqualTo: int.parse(cod))
        .get()
        .then((value) {
      QueryDocumentSnapshot values = value.docs.first;
      setState(() {
        valor = values["cod"].toString();
      });
    });
  }

  Stream<QuerySnapshot> _pegarIgreja() {
    Stream<QuerySnapshot> igreja = db
        .collection("igrejas")
        .where('cod', isEqualTo: int.parse(valor))
        .snapshots();

    igreja.listen((event) {
      _controllerIgreja.add(event);
    });

    return null;
  }

  @override
  void initState() {
    getIgrejas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_coelba ? "Coelba" : "Embasa"),
        centerTitle: true,
        actions: actions(widget.gerenciador, context, 'coelba', kisWeb: kIsWeb),
      ),
      drawer: kIsWeb ? null : drawer(widget.gerenciador, context, 'coelba'),
      body: SingleChildScrollView(
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
                      mostrar2 = false;
                      _controller.text = "";
                      _controllerPesquisa.text = "";
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
                      mostrar2 = false;
                      _controller.text = "";
                      _controllerPesquisa.text = "";
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
                        ? setState(() {
                            mostrar = true;
                            mostrar2 = false;
                          })
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
                    _pegarIgreja();
                    setState(() {
                      mostrar2 = true;
                      mostrar = false;
                    });
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
                  child: TypeAheadField<String>(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _controllerPesquisa,
                      textAlign: TextAlign.end,
                      decoration: inputDecoration.copyWith(labelText: "Igreja"),
                    ),
                    debounceDuration: Duration(milliseconds: 600),
                    suggestionsCallback: (pattern) {
                      return igrejas.where((element) => element
                          .toLowerCase()
                          .contains(pattern.toLowerCase()));
                    },
                    onSuggestionSelected: (suggestion) {
                      _controllerPesquisa.text = suggestion;
                      _getIgreja(suggestion.split(" ")[0]);
                    },
                    itemBuilder: (context, itemData) => ListTile(
                      title: Text("$itemData"),
                    ),
                  ),
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      } else if (snapshot.hasData) {
                        QuerySnapshot querySnapshot = snapshot.data;
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2.5),
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
                    stream: _controllerIgreja.stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      } else if (snapshot.hasData) {
                        QuerySnapshot querySnapshot = snapshot.data;
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2.5),
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
                                        "Contrato: ${documentSnapshot["contrato"].toString()}"),
                                  ),
                                  ListTile(
                                    title: Text(
                                        "Matricula: ${documentSnapshot["matricula"].toString()}"),
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
      )),
    );
  }
}
