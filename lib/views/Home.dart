import 'dart:convert';
import 'dart:io';
import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:remessa/models/Auth.dart';
import 'package:remessa/models/IgrejaFirebase.dart';
import 'package:remessa/models/pdf/DistritoPdf.dart';
import 'package:remessa/models/widgets/CheckBoxTile.dart';
import 'package:remessa/models/widgets/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:remessa/views/Rank.dart';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _controllerDistritos = StreamController.broadcast();
  final _controllerIgrejas = StreamController.broadcast();
  final _controllerRank = StreamController.broadcast();
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  List<IgrejaPdf> igrejas = [];
  String _data = DateFormat("dd/MM/yyyy").format(DateTime.now());
  bool _distrito = false;
  Auth _auth = Auth();
  String escolhido;
  String usuario;
  bool n = false;

  save() {
    if (_formKey.currentState != null && _formKey.currentState.validate()) {
      _formKey.currentState.save();
      _pegarDados();
    }
  }

  Stream<QuerySnapshot> _pegarDados() {
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
    nome = auth.currentUser.email.contains("pastor")
        ? "pastor"
        : auth.currentUser.email.contains("adm")
            ? "adm"
            : "gerenciador";
    usuario = auth.currentUser.email.contains("_")
        ? '${auth.currentUser.email.split("_")[0].substring(0, 1).toUpperCase()}${auth.currentUser.email.split("_")[0].substring(1)} ${auth.currentUser.email.split("_")[1].split("@")[0].substring(0, 1).toUpperCase()}${auth.currentUser.email.split("_")[1].split("@")[0].substring(1)}'
        : auth.currentUser.email.split("@")[0];
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

  List<Widget> action = [];

  @override
  Widget build(BuildContext context) {
    action =
        actions(currentUser(), context, 'home', auth: _auth, kisWeb: kIsWeb);
    action.add(
      Tooltip(
        message: 'Conciliação Bancária',
        child: IconButton(
            icon: Icon(Icons.insert_drive_file_rounded),
            onPressed: () async {
              FilePickerResult result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowMultiple: true,
                allowedExtensions: [
                  'csv',
                ],
              );
              if (result != null) {
                List<PlatformFile> files = result.files;
                showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: Text("Confirme o(s) arquivo(s)"),
                          content: Text("${files[0].name} e outros"),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      n = !n;
                                    });
                                  },
                                  child: Text(
                                    n ? "Poupança" : "Corrente",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  color: Colors.amber,
                                ),
                                FlatButton(
                                  color: Colors.lightGreen,
                                  child: Text(
                                    "Gerar",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () async {
                                    List<Csv> csvList = [];
                                    for (var file in files) {
                                      String csvData =
                                          File.fromRawPath(file.bytes).path;
                                      List<String> datas = csvData.split("\r");
                                      datas[0] =
                                          datas[0].replaceFirst("\n", "");
                                      String conta = datas.first
                                          .split(" ")[6]
                                          .split("-")[0];
                                      datas.removeRange(0, 3);
                                      String part;
                                      for (var element in datas) {
                                        if (element.split(";")[0] != "Total") {
                                          List<String> list =
                                              element.split(";");
                                          csvList.add(
                                            Csv(
                                              conta,
                                              list[0],
                                              list[1],
                                              list[2],
                                              list[3] != ""
                                                  ? list[3] != null
                                                      ? list[3]
                                                          .replaceAll(".", "")
                                                          .replaceAll(",", "")
                                                      : list[4]
                                                          .replaceAll(".", "")
                                                          .replaceAll(",", "")
                                                  : list[4]
                                                      .replaceAll(".", "")
                                                      .replaceAll(",", ""),
                                            ),
                                          );
                                        } else {
                                          part = element;
                                          break;
                                        }
                                      }
                                      datas.removeRange(
                                          datas.indexOf(part), datas.length);
                                    }
                                    String jsonCsvEncoded = jsonEncode(csvList);
                                    List<Map<String, String>> jsonCsvDecoded =
                                        jsonDecode(jsonCsvEncoded);
                                    List<String> text = [
                                      "Bank          	              BankAccountNumber           	              Date          	              Description   	              Value"
                                    ];
                                    jsonCsvDecoded.forEach((element) {
                                      text.add(
                                          " 237          	               ${element["conta"]}${n ? "1" : ""}          	              ${element["data"]}    	              ${element["lancamento"]} - ${element["doc"]}           	               ${element["valor"]}");
                                    });
                                    var anchor;
                                    var url;
                                    // prepare
                                    final bytes = utf8.encode(text.join("\n"));
                                    final blob = html.Blob([bytes]);
                                    url =
                                        html.Url.createObjectUrlFromBlob(blob);
                                    anchor = html.document.createElement('a')
                                        as html.AnchorElement
                                      ..href = url
                                      ..style.display = 'none'
                                      ..download = 'Conciliacao.txt';
                                    html.document.body.children.add(anchor);

                                    // download
                                    anchor.click();

                                    // cleanup
                                    html.document.body.children.remove(anchor);
                                    html.Url.revokeObjectUrl(url);
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  color: Colors.blue,
                                  child: Text(
                                    "Sair",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    );
                  },
                );
              }
            }),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("$usuario"),
        actions: action,
      ),
      drawer: kIsWeb ? null : drawer(currentUser(), context, 'home'),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                            escolhido = value;
                          });
                        },
                        hint: Text("Distritos"),
                        onSaved: (newValue) {
                          setState(() {
                            _distrito = true;
                          });
                        },
                        items: distritos,
                        value: escolhido,
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
              Row(
                children: [
                  Expanded(
                    child: RaisedButton(
                      padding: EdgeInsets.all(10),
                      color: Colors.blue,
                      onPressed: () {
                        save();
                      },
                      child: Text(
                        "Pesquisar",
                        style: TextStyle(color: Colors.white),
                      ),
                      disabledColor: Colors.green,
                    ),
                  ),
                  _distrito
                      ? Align(
                          alignment: FractionalOffset.centerRight,
                          child: StreamBuilder(
                            stream: _controllerRank.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                QuerySnapshot querySnapshot = snapshot.data;
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
                    child: RaisedButton(
                      padding: EdgeInsets.all(10),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Rank(_data, currentUser()),
                            ));
                      },
                      child: Text(
                        "Rank",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                    ),
                    flex: 3,
                  ),
                  _distrito
                      ? Expanded(
                          child: RaisedButton(
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
                            child: Text(
                              "Listar",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.blue,
                          ),
                          flex: 2)
                      : Container()
                ],
              ),
              SizedBox(
                height: 20,
              ),
              _distrito
                  ? StreamBuilder(
                      stream: _controllerIgrejas.stream,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                            break;
                          case ConnectionState.active:
                          case ConnectionState.done:
                            if (!snapshot.hasError) {
                              if (snapshot.hasData) {
                                QuerySnapshot querySnapshot = snapshot.data;
                                return Expanded(
                                  child: ListView.builder(
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
