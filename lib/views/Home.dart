import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:remessa/models/Auth.dart';
import 'package:remessa/models/IgrejaFirebase.dart';
import 'package:remessa/models/pdf/DistritoPdf.dart';
import 'package:remessa/models/widgets/Button.dart';
import 'package:remessa/models/widgets/CheckBoxTile.dart';
import 'package:remessa/models/widgets/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:remessa/views/Rank.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  StreamController<QuerySnapshot> _controllerDistritos =
      StreamController.broadcast();
  StreamController<QuerySnapshot> _controllerIgrejas =
      StreamController.broadcast();
  StreamController<QuerySnapshot> _controllerRank =
      StreamController.broadcast();
  ScrollController _controllerScroll = ScrollController();
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  List<IgrejaPdf> igrejas = [];
  String _data = DateFormat("dd/MM/yyyy").format(DateTime.now());
  bool _distrito = false;
  String? escolhido;
  String? usuario;

  save() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _pegarDados();
    }
  }

  Stream<QuerySnapshot>? _pegarDados() {
    igrejas = [];
    Query query = db
        .collection("igrejas")
        .where("distrito", isEqualTo: escolhido)
        .orderBy('nome');

    Stream<QuerySnapshot> stream = query.snapshots();

    db
        .collection("igrejas")
        .where("distrito", isEqualTo: escolhido)
        .orderBy('data')
        .orderBy('nome')
        .get()
        .then(
      (value) {
        value.docs.forEach(
          (element) {
            igrejas.add(
              IgrejaPdf(
                element["nome"].toString(),
                element["data"] != null ? element["data"].toString() : "Falta",
              ),
            );
          },
        );
      },
    );

    Stream<QuerySnapshot> rank = db
        .collectionGroup("igrejas")
        .where("distrito", isEqualTo: escolhido)
        .where("marcado", isEqualTo: false)
        .snapshots();

    stream.listen((event) {
      _controllerIgrejas.add(event);
    });

    rank.listen((event) {
      _controllerRank.add(event);
    });
    return null;
  }

  String currentUser() {
    String nome;
    nome = auth.currentUser!.email!.contains("pastor")
        ? "pastor"
        : auth.currentUser!.email!.contains("adm")
            ? "adm"
            : "gerenciador";
    usuario = auth.currentUser!.email!.contains("_")
        ? '${auth.currentUser!.email!.split("_")[0].substring(0, 1).toUpperCase()}${auth.currentUser!.email!.split("_")[0].substring(1)} ${auth.currentUser!.email!.split("_")[1].split("@")[0].substring(0, 1).toUpperCase()}${auth.currentUser!.email!.split("_")[1].split("@")[0].substring(1)}'
        : auth.currentUser!.email!.split("@")[0];
    Stream<QuerySnapshot> pastor = nome == "pastor"
        ? db
            .collectionGroup("distritos")
            .where("pastor", isEqualTo: usuario)
            .snapshots()
        : db.collectionGroup("distritos").snapshots();

    pastor.listen((event) {
      _controllerDistritos.add(event);
    });
    return nome;
  }

  @override
  void initState() {
    currentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool mobile = width <= 750;
    Auth _auth = context.read<Auth>();
    return Scaffold(
      appBar: AppBar(
        title: Text("$usuario"),
        actions: mobile
            ? null
            : actions(
                currentUser(),
                context,
                'home',
                auth: _auth,
              ),
      ),
      drawer: mobile ? drawer(currentUser(), context, 'home') : null,
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                            escolhido = value;
                          });
                        },
                        hint: Text("Distritos"),
                        onSaved: (dynamic newValue) {
                          setState(() {
                            _distrito = true;
                          });
                        },
                        items: distritos,
                        value: escolhido,
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
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Button(
                      padding: EdgeInsets.all(10),
                      color: Colors.blue,
                      onPressed: () {
                        save();
                      },
                      label: "Procurar",
                    ),
                  ),
                  _distrito
                      ? Align(
                          alignment: FractionalOffset.centerRight,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _controllerRank.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                QuerySnapshot querySnapshot = snapshot.data!;
                                db
                                    .collection("distritos")
                                    .doc(escolhido)
                                    .update(
                                        {"faltam": querySnapshot.docs.length});

                                return Container(
                                  margin: EdgeInsets.only(
                                      top: 10, right: 10, left: 10),
                                  padding: EdgeInsets.all(10),
                                  width: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.blue, width: 3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      querySnapshot.docs.length.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        )
                      : Container(),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Button(
                      padding: EdgeInsets.all(10),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Rank(_data, currentUser()),
                            ));
                      },
                      label: "Rank",
                      color: Colors.blue,
                    ),
                    flex: 3,
                  ),
                  _distrito
                      ? SizedBox(
                          width: 20,
                        )
                      : Container(),
                  _distrito
                      ? Expanded(
                          child: Button(
                            padding: EdgeInsets.all(10),
                            onPressed: () {
                              Printing.layoutPdf(
                                name: 'Distrito $escolhido Dia $_data',
                                onLayout: (format) {
                                  return buildPdfDistrito(
                                    igrejas: igrejas,
                                    distrito: escolhido,
                                    data: _data,
                                  );
                                },
                              );
                            },
                            label: "Listar",
                            color: Colors.blue,
                          ),
                          flex: 2)
                      : Container()
                ],
              ),
              _distrito
                  ? StreamBuilder<QuerySnapshot>(
                      stream: _controllerIgrejas.stream,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          case ConnectionState.active:
                          case ConnectionState.done:
                            if (!snapshot.hasError) {
                              if (snapshot.hasData) {
                                QuerySnapshot querySnapshot = snapshot.data!;
                                return Expanded(
                                  child: Scrollbar(
                                    controller: _controllerScroll,
                                    showTrackOnHover: true,
                                    isAlwaysShown: true,
                                    child: ListView.builder(
                                      controller: _controllerScroll,
                                      shrinkWrap: true,
                                      itemCount: querySnapshot.docs.length,
                                      itemBuilder: (context, index) {
                                        List<DocumentSnapshot> igrejas =
                                            querySnapshot.docs.toList();
                                        DocumentSnapshot documentSnapshot =
                                            igrejas[index];
                                        IgrejaFB igreja =
                                            IgrejaFB.toCheckBoxModel(
                                          documentSnapshot,
                                        );
                                        return Card(
                                          child: CheckBoxTile(igreja,
                                              documentSnapshot, currentUser()),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }
                            }
                            break;
                        }
                        return Container();
                      },
                    )
                  : Container(
                      child: Image.asset(
                        'assets/logo_app.png',
                      ),
                      constraints:
                          BoxConstraints(maxWidth: 500, maxHeight: 444),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
