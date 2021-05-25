import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcache/dcache.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import 'package:remessa/models/pdf/EtiquetaPdf.dart';
import 'package:remessa/models/pdf/LicaoPdf.dart';
import 'package:remessa/views/CoelbaEmbasa.dart';
import 'package:remessa/views/Home.dart';
import 'package:remessa/views/depositos.dart';
import 'package:remessa/views/dinheiro.dart';
import 'package:remessa/views/wrappers/Adicionar.dart';
import 'package:remessa/views/wrappers/WrappersAutenticate/Login.dart';
import 'package:remessa/views/wrappers/WrappersAutenticate/Registro.dart';

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
  String _dataFormatada =
      _listaData != null ? _listaData.reversed.join("-") : null;
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

List<Widget> actions(String gerenciador, BuildContext context, String tela,
    {auth, Function setDistrito, bool igreja, kisWeb}) {
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
                      bool loading = false;
                      return AlertDialog(
                        title: Text(
                          "Escolha um distrito",
                          textAlign: TextAlign.center,
                        ),
                        content: Column(
                          children: [
                            DropdownButtonFormField(
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
                            loading ? LinearProgressIndicator() : Container()
                          ],
                        ),
                        actions: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: StatefulBuilder(
                                  builder: (context, setState) {
                                    return TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.lightGreen,
                                      ),
                                      child: Text(
                                        "Gerar",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          loading = true;
                                        });
                                        Printing.layoutPdf(
                                          onLayout: (format) {
                                            return buildPdfEtiqueta(
                                              distritoEtiqueta,
                                              currentDate(dataAtual: true)
                                                  .split("/")[2],
                                            );
                                          },
                                        );
                                        Navigator.of(context).pop();
                                        distritoEtiqueta = "";
                                        loading = false;
                                      },
                                    );
                                  },
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 1,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: Text(
                                    "Cancelar",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  );
                }),
          )
        : Container(),
    tela == "home"
        ? kisWeb
            ? Tooltip(
                message: 'Conciliação Bancária',
                child: IconButton(
                  icon: Icon(Icons.insert_drive_file_rounded),
                  onPressed: () async {
                    FilePickerResult result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowMultiple: true,
                      allowedExtensions: [
                        'csv',
                      ],
                    );
                    if (result != null) {
                      List<PlatformFile> files = result.files;
                      bool n = false;
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
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.orange,
                                          ),
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
                                        ),
                                      ),
                                      Spacer(),
                                      Expanded(
                                        flex: 1,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.lightGreen,
                                          ),
                                          child: Text(
                                            "Gerar",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          onPressed: () async {
                                            List<Conciliacao> csvList = [];
                                            for (var file in files) {
                                              String csvData =
                                                  File.fromRawPath(file.bytes)
                                                      .path;
                                              List<String> datas =
                                                  csvData.split("\r");
                                              datas[0] = datas[0]
                                                  .replaceFirst("\n", "");
                                              String conta = datas.first
                                                  .split(" ")[6]
                                                  .split("-")[0];
                                              datas.removeRange(0, 3);
                                              String part;
                                              for (var element in datas) {
                                                if (element.split(";")[0] !=
                                                    "Total") {
                                                  List<String> list =
                                                      element.split(";");
                                                  csvList.add(
                                                    Conciliacao(
                                                      conta,
                                                      list[0],
                                                      list[1],
                                                      list[2],
                                                      list[3] != ""
                                                          ? list[3] != null
                                                              ? list[3]
                                                                  .replaceAll(
                                                                      ".", "")
                                                                  .replaceAll(
                                                                      ",", "")
                                                              : list[4]
                                                                  .replaceAll(
                                                                      ".", "")
                                                                  .replaceAll(
                                                                      ",", "")
                                                          : list[4]
                                                              .replaceAll(
                                                                  ".", "")
                                                              .replaceAll(
                                                                  ",", ""),
                                                    ),
                                                  );
                                                } else {
                                                  part = element;
                                                  break;
                                                }
                                              }
                                              datas.removeRange(
                                                  datas.indexOf(part),
                                                  datas.length);
                                            }
                                            String jsonCsvEncoded =
                                                jsonEncode(csvList);
                                            List<Map<String, String>>
                                                jsonCsvDecoded =
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
                                            final bytes =
                                                utf8.encode(text.join("\n"));
                                            final blob = html.Blob([bytes]);
                                            url = html.Url
                                                .createObjectUrlFromBlob(blob);
                                            anchor = html.document
                                                    .createElement('a')
                                                as html.AnchorElement
                                              ..href = url
                                              ..style.display = 'none'
                                              ..download = 'Conciliacao.txt';
                                            html.document.body.children
                                                .add(anchor);

                                            // download
                                            anchor.click();

                                            // cleanup
                                            html.document.body.children
                                                .remove(anchor);
                                            html.Url.revokeObjectUrl(url);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                      Spacer(),
                                      Expanded(
                                        flex: 1,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                          ),
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
                  },
                ),
              )
            : Container()
        : Container(),
    tela == "home"
        ? kisWeb
            ? Tooltip(
                message: 'Lições',
                child: IconButton(
                  icon: Icon(Icons.menu_book),
                  onPressed: () async {
                    String escolhido;
                    showDialog(
                      context: context,
                      builder: (context) {
                        List<DropdownMenuItem> distritos = [
                          DropdownMenuItem(
                            child: Text(
                              "Trimestre",
                            ),
                          ),
                        ];
                        for (var i = 0; i < 4; i++) {
                          distritos.add(
                            DropdownMenuItem(
                              value: "${i + 1}º Trimestre",
                              child: Text(
                                "${i + 1}º Trimestre",
                              ),
                            ),
                          );
                        }
                        return AlertDialog(
                          title: Text("Escolha o trimestre:"),
                          content: DropdownButtonFormField(
                            decoration: inputDecoration,
                            onChanged: (value) {
                              escolhido = value;
                              Printing.layoutPdf(
                                onLayout: (format) => generateLicaoPdf(
                                  format,
                                  escolhido,
                                ),
                              );
                            },
                            hint: Text("Trimestre"),
                            items: distritos,
                            value: escolhido,
                            validator: (value) {
                              if (value == null) {
                                return "Escolha algum trimestre";
                              }
                              return null;
                            },
                          ),
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
            message: 'Pesquisa por conta',
            child: IconButton(
                icon: Icon(
                  Icons.search,
                ),
                onPressed: () async {
                  String result = await DefaultAssetBundle.of(context)
                      .loadString('assets/contas.json');
                  String conta = "";
                  String searched = "espera";
                  String igrejaCod = "";
                  bool bancaria = true;
                  if (result != null) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: Text(
                                searched == "espera"
                                    ? bancaria
                                        ? "Conta Bancária"
                                        : "Código Igreja"
                                    : searched == "achou"
                                        ? igrejaCod
                                        : bancaria
                                            ? "Conta não existente"
                                            : "Código não existente",
                                textAlign: TextAlign.center,
                              ),
                              content: TextField(
                                focusNode: FocusNode(),
                                onSubmitted: (value) {
                                  List<Map<String, String>> jsonList =
                                      json.decode(result.toString());
                                  if (jsonList.indexWhere((element) =>
                                          element["conta"].split("-")[0] ==
                                              value &&
                                          bancaria) !=
                                      -1) {
                                    setState(() {
                                      igrejaCod =
                                          "${jsonList[jsonList.indexWhere((element) => element["conta"].split("-")[0] == value)]["cod"]} - ${jsonList[jsonList.indexWhere((element) => element["conta"].split("-")[0] == value)]["nome"]}";
                                      searched = "achou";
                                    });
                                  } else if (jsonList.indexWhere(
                                            (element) =>
                                                element["cod"] == value,
                                          ) !=
                                          -1 &&
                                      !bancaria) {
                                    setState(() {
                                      igrejaCod =
                                          "${jsonList[jsonList.indexWhere((element) => element["cod"] == value)]["conta"]} - ${jsonList[jsonList.indexWhere((element) => element["cod"] == value)]["nome"]}";
                                      searched = "achou";
                                    });
                                  } else {
                                    setState(() {
                                      searched = "erro";
                                    });
                                  }
                                },
                                onChanged: (value) {
                                  setState(() {
                                    conta = value;
                                  });
                                },
                                textAlign: TextAlign.center,
                                decoration: inputDecoration,
                              ),
                              actions: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            searched = "espera";
                                            bancaria = !bancaria;
                                          });
                                        },
                                        child: Text(
                                          bancaria
                                              ? "Conta Banc."
                                              : "Cod. Igreja",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Expanded(
                                      flex: 1,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.lightGreen,
                                        ),
                                        child: Text(
                                          "Pesquisar",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onPressed: () async {
                                          List<Map<String, String>> jsonList =
                                              json.decode(result.toString());
                                          if (jsonList.indexWhere((element) =>
                                                  element["conta"]
                                                          .split("-")[0] ==
                                                      conta &&
                                                  bancaria) !=
                                              -1) {
                                            setState(() {
                                              igrejaCod =
                                                  "${jsonList[jsonList.indexWhere((element) => element["conta"].split("-")[0] == conta)]["cod"]} - ${jsonList[jsonList.indexWhere((element) => element["conta"].split("-")[0] == conta)]["nome"]}";
                                              searched = "achou";
                                            });
                                          } else if (jsonList.indexWhere(
                                                      (element) =>
                                                          element["cod"] ==
                                                          conta) !=
                                                  -1 &&
                                              !bancaria) {
                                            setState(() {
                                              igrejaCod =
                                                  "${jsonList[jsonList.indexWhere((element) => element["cod"] == conta)]["conta"]} - ${jsonList[jsonList.indexWhere((element) => element["cod"] == conta)]["nome"]}";
                                              searched = "achou";
                                            });
                                          } else {
                                            setState(() {
                                              searched = "erro";
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    Spacer(),
                                    Expanded(
                                      flex: 1,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                        ),
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
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  }
                }),
          )
        : Container(),
    tela == 'adicionar'
        ? Tooltip(
            message: igreja ? 'Igreja' : 'Distrito',
            child: IconButton(
                icon: Icon(igreja ? Icons.account_balance : Icons.business),
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

class Conciliacao {
  final String conta;
  final String data;
  final String lancamento;
  final String documento;
  final String valor;

  Conciliacao(
      this.conta, this.data, this.lancamento, this.documento, this.valor);
  Map toJson() => {
        'conta': conta,
        'data': data,
        'lancamento': lancamento,
        'doc': documento,
        'valor': valor,
      };
}
