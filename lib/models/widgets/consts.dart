import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:dcache/dcache.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:remessa/models/pdf/EtiquetaPdf.dart';
import 'package:remessa/views/CoelbaEmbasa.dart';
import 'package:remessa/views/Home.dart';
import 'package:remessa/views/LicaoPreview.dart';
import 'package:remessa/views/depositos.dart';
import 'package:remessa/views/dinheiro.dart';
import 'package:remessa/views/wrappers/Adicionar.dart';
import 'package:remessa/views/wrappers/WrappersAutenticate/Login.dart';
import 'package:remessa/views/wrappers/WrappersAutenticate/Registro.dart';
import 'package:file_picker/file_picker.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

var inputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 3),
    borderRadius: BorderRadius.circular(10),
  ),
);

Cache<String, List> c = new SimpleCache<String, List<List<String>>>(
  storage: InMemoryStorage(3),
);

final navigatorKey = GlobalKey<NavigatorState>();

currentDate({String date, bool dateTime = true, bool dataAtual = false}) {
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

actions(String gerenciador, BuildContext context, String tela,
    {auth, Function setDistrito, distrito, kisWeb}) {
  List<DropdownMenuItem> distritos = [];
  String distritoEtiqueta;
  db.collection("distritos").get().then((value) {
    value.docs.forEach((element) {
      distritos.add(
        DropdownMenuItem(
          child: Text(element.id),
          value: element.id,
        ),
      );
    });
  });
  return [
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
    tela == 'home'
        ? Tooltip(
            message: 'Etiqueta',
            child: IconButton(
                icon: Icon(Icons.local_offer),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Escolha um distrito"),
                        content: DropdownButtonFormField(
                          onChanged: (value) {
                            distritoEtiqueta = value;
                          },
                          onSaved: (value) {
                            distritoEtiqueta = value;
                          },
                          hint: Text("Distritos"),
                          items: distritos,
                          value: distritoEtiqueta,
                        ),
                        actions: [
                          FlatButton(
                            child: Text("Gerar"),
                            onPressed: () {
                              Printing.layoutPdf(
                                onLayout: (format) {
                                  return buildPdfEtiqueta(
                                    distritoEtiqueta,
                                    currentDate(dataAtual: true).split("/")[2],
                                  );
                                },
                              );
                              distritoEtiqueta = "";
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text("Cancelar"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }),
          )
        : Container(),
    tela == 'home'
        ? Tooltip(
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
                        return AlertDialog(
                          title: Text("Confirme o(s) arquivo(s)"),
                          content: Text("${files[0].name} e outros"),
                          actions: [
                            FlatButton(
                              child: Text("Gerar"),
                              onPressed: () async {
                                List<Csv> csvList = [];
                                for (var file in files) {
                                  String csvData =
                                      File.fromRawPath(file.bytes).path;
                                  List<String> datas = csvData.split("\r");
                                  datas[0] = datas[0].replaceFirst("\n", "");
                                  String conta =
                                      datas.first.split(" ")[6].split("-")[0];
                                  datas.removeRange(0, 3);
                                  String part;
                                  for (var element in datas) {
                                    if (element.split(";")[0] != "Total") {
                                      List<String> list = element.split(";");
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
                                      " 237          	               ${element["conta"]}          	              ${element["data"]}    	              ${element["lancamento"]} - ${element["doc"]}           	               ${element["valor"]}");
                                });
                                var anchor;
                                var url;
                                // prepare
                                final bytes = utf8.encode(text.join("\n"));
                                final blob = html.Blob([bytes]);
                                url = html.Url.createObjectUrlFromBlob(blob);
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
                              child: Text("Cancelar"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
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
    /*tela != 'nada' ? 
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
          ) : Container(),*/
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
    tela == 'home' && kisWeb
        ? gerenciador == 'gerenciador'
            ? Tooltip(
                message: 'Depositos Manuais',
                child: IconButton(
                    icon: Icon(Icons.monetization_on_sharp),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Deposito(c),
                        ),
                      );
                    }),
              )
            : Container()
        : Container(),
    tela == 'home' && kisWeb
        ? gerenciador == 'gerenciador'
            ? Tooltip(
                message: 'Protocolo Caixa',
                child: IconButton(
                    icon: Icon(Icons.calculate),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Dinheiro(c),
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

class Csv {
  final String conta;
  final String data;
  final String lancamento;
  final String documento;
  final String valor;

  Csv(this.conta, this.data, this.lancamento, this.documento, this.valor);
  Map toJson() => {
        'conta': conta,
        'data': data,
        'lancamento': lancamento,
        'doc': documento,
        'valor': valor,
      };
}
