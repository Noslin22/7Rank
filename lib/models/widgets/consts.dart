import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remessa/views/CoelbaEmbasa.dart';
import 'package:remessa/views/Home.dart';
import 'package:remessa/views/LicaoPreview.dart';
import 'package:remessa/views/wrappers/Adicionar.dart';
import 'package:remessa/views/wrappers/WrappersAutenticate/Login.dart';
import 'package:remessa/views/wrappers/WrappersAutenticate/Registro.dart';

var inputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 3),
    borderRadius: BorderRadius.circular(10),
  ),
);

final navigatorKey = GlobalKey<NavigatorState>();

final FirebaseFirestore db = FirebaseFirestore.instance;

formatDate({String date, bool dateTime = true, bool dataAtual = false}) {
  List _listaData = date != null ? date.split("/").toList() : null;
  String _dataFormatada = _listaData != null
      ? "${_listaData[2]}-${_listaData[1]}-${_listaData[0]}"
      : null;
  DateTime _dateTime =
      _dataFormatada != null ? DateTime.parse(_dataFormatada) : null;
  String _dataPronta =
      _dateTime != null ? DateFormat("dd/MM/yyyy").format(_dateTime) : null;
  return dataAtual
      ? DateFormat("dd/MM/yyyy").format(DateTime.now())
      : dateTime
          ? _dateTime
          : _dataPronta;
}

actions(String gerenciador, BuildContext context, String tela, {auth, Function setDistrito, distrito, kisWeb}) {
  return [
    tela == 'home'
        ? gerenciador == "gerenciador"
            ? Tooltip(
                message: 'Limpar o mapa',
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Confirmar"),
                          content: Text("Você deseja fechar o mapa?"),
                          actions: [
                            FlatButton(
                              child: new Text("Não"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: new Text("Sim"),
                              onPressed: () {
                                db.collection("distritos").get().then((value) {
                                  value.docs.forEach((element) async {
                                    db
                                        .collection("igrejas")
                                        .where("distrito",
                                            isEqualTo: element.id)
                                        .get()
                                        .then((value) {
                                      db
                                          .collection("distritos")
                                          .doc(element.id)
                                          .update(
                                              {"faltam": value.docs.length});
                                    });
                                  });
                                });
                                db.collection("igrejas").get().then((value) {
                                  value.docs.forEach((element) {
                                    db
                                        .collection("igrejas")
                                        .doc(element.id)
                                        .update(
                                            {"marcado": false, "data": null});
                                  });
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              )
            : Container()
        : Container(),
    tela == 'home'
        ? Tooltip(
            message: 'Sair',
            child: IconButton(
                icon: Icon(Icons.person),
                onPressed: () async {
                  await auth.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                }),
          )
        : Container(),
    tela == 'adicionar'
        ? Tooltip(
            message: distrito ? 'Igreja' : 'Distrito',
            child: IconButton(
                icon: Icon(distrito ? Icons.account_balance : Icons.business),
                onPressed: () {
                  setDistrito();
                }),
          )
        : Container(),
    tela != 'home' && kisWeb
        ? Tooltip(
            message: '7Rank',
            child: IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ),
                  );
                }),
          )
        : Container(),
        Tooltip(
            message: 'Lição',
            child: IconButton(
                icon: Icon(Icons.menu_book),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LicaoPreview(),
                    ),
                  );
                }),
          ),
    tela != 'coelba' && kisWeb
        ? gerenciador == 'gerenciador'
            ? Tooltip(
                message: 'Coelba/Embasa',
                child: IconButton(
                    icon: Icon(Icons.data_usage),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CoelbaEmbasa(
                            gerenciador,
                          ),
                        ),
                      );
                    }),
              )
            : Container()
        : Container(),
    tela != 'registrar' && kisWeb
        ? gerenciador == 'gerenciador'
            ? Tooltip(
                message: 'Registrar',
                child: IconButton(
                    icon: Icon(Icons.person_add),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Registro(
                              gerenciador,
                            ),
                          ));
                    }),
              )
            : Container()
        : Container(),
    tela != 'adicionar' && kisWeb
        ? gerenciador == 'gerenciador'
            ? Tooltip(
                message: 'Adicionar',
                child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Adicionar(
                            gerenciador,
                          ),
                        ),
                      );
                    }),
              )
            : Container()
        : Container(),
  ];
}

drawer(String gerenciador, BuildContext context, String tela) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text(
            'Coelba/Embasa',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          decoration: BoxDecoration(
            color: Colors.blue[400],
          ),
        ),
        tela != 'home'
            ? ListTile(
                title: Text('7Rank'),
                leading: Icon(Icons.home),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ));
                },
              )
            : Container(),
        tela != 'coelba'
            ? gerenciador != "pastor"
                ? ListTile(
                    title: Text('Coelba/Embasa'),
                    leading: Icon(Icons.data_usage),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoelbaEmbasa(gerenciador),
                          ));
                    },
                  )
                : Container()
            : Container(),
        tela != 'adicionar'
            ? gerenciador == 'gerenciador'
                ? ListTile(
                    title: Text('Adicionar'),
                    leading: Icon(Icons.add),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Adicionar(gerenciador),
                          ));
                    },
                  )
                : Container()
            : Container(),
        tela != 'registrar'
            ? gerenciador == "gerenciador"
                ? ListTile(
                    title: Text('Registrar'),
                    leading: Icon(Icons.person_add),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Registro(gerenciador),
                          ));
                    },
                  )
                : Container()
            : Container(),
      ],
    ),
  );
}
