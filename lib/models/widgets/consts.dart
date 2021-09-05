import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcache/dcache.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:remessa/models/pages/reconciliacao/config_reconciliacao.dart';

import 'package:remessa/models/pdf/EtiquetaPdf.dart';
import 'package:remessa/models/pdf/LicaoPdf.dart';
import 'package:remessa/models/widgets/Button.dart';
import 'package:remessa/views/CoelbaEmbasa.dart';
import 'package:remessa/views/Home.dart';
import 'package:remessa/views/depositos.dart';
import 'package:remessa/views/dinheiro.dart';
import 'package:remessa/views/wrappers/Adicionar.dart';
import 'package:remessa/views/wrappers/WrappersAutenticate/Login.dart';
import 'package:remessa/views/wrappers/WrappersAutenticate/Registro.dart';

import '../Auth.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

List<DropdownMenuItem> distritos = [];
String? distritoEtiqueta;
final inputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 3),
    borderRadius: BorderRadius.circular(10),
  ),
);

SimpleCache<String, List<String>?> c1 = SimpleCache<String, List<String>?>(
  storage: InMemoryStorage(3),
);
SimpleCache<String, List<List<String?>>?> c2 =
    SimpleCache<String, List<List<String?>>?>(
  storage: InMemoryStorage(3),
);

final navigatorKey = GlobalKey<NavigatorState>();
void initialize(BuildContext context) {
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
}

currentDate({String? date, bool dateTime = true, bool dataAtual = false}) {
  List? _listaData = date != null ? date.split("/").toList() : null;
  String? _dataFormatada =
      _listaData != null ? _listaData.reversed.join("-") : null;
  DateTime? _dateTime =
      _dataFormatada != null ? DateTime.parse(_dataFormatada) : null;
  String? _dataPronta =
      _dateTime != null ? DateFormat("dd/MM/yyyy").format(_dateTime) : null;
  return dataAtual
      ? DateFormat("dd/MM/yyyy").format(DateTime.now())
      : dateTime
          ? _dateTime
          : _dataPronta;
}

List<Widget> actions(String gerenciador, BuildContext context, String tela,
    {Auth? auth, Function? setDistrito, bool? igreja}) {
  initialize(context);
  return [
    tela != 'home'
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
    tela == 'home'
        ? Tooltip(
            message: 'Sair',
            child: IconButton(
                icon: Icon(Icons.person),
                onPressed: () async {
                  await auth!.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                }),
          )
        : Container(),
    Tooltip(
      message: 'Etiqueta',
      child: IconButton(
          icon: Icon(Icons.local_offer),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    "Escolha um distrito",
                    textAlign: TextAlign.center,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField(
                        onChanged: (dynamic value) {
                          distritoEtiqueta = value;
                        },
                        onSaved: (dynamic value) {
                          distritoEtiqueta = value;
                        },
                        hint: Text("Distritos"),
                        items: distritos,
                        value: distritoEtiqueta,
                      ),
                    ],
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Button(
                            color: Colors.lightGreen,
                            label: "Gerar",
                            onPressed: () {
                              Printing.layoutPdf(
                                onLayout: (format) {
                                  return buildPdfEtiqueta(
                                    distritoEtiqueta,
                                    currentDate(dataAtual: true).split("/")[2],
                                  );
                                },
                              );
                              Navigator.of(context).pop();
                              distritoEtiqueta = "";
                            },
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Expanded(
                          flex: 1,
                          child: Button(
                            color: Colors.blue,
                            label: "Cancelar",
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
    ),
    Tooltip(
      message: 'Conciliação Bancária',
      child: IconButton(
        icon: Icon(Icons.insert_drive_file_rounded),
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowMultiple: true,
            allowedExtensions: [
              'csv',
            ],
          );
          if (result != null) {
            List<PlatformFile> files = result.files;
            bool poupanca = false;
            bool acms = true;

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
                              child: Button(
                                color: Colors.deepOrange,
                                onPressed: () {
                                  setState(() {
                                    poupanca = !poupanca;
                                  });
                                },
                                label: poupanca ? "Poupança" : "Corrente",
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Expanded(
                              flex: 1,
                              child: Button(
                                color: Colors.orange,
                                onPressed: () {
                                  setState(() {
                                    acms = !acms;
                                  });
                                },
                                label: acms ? "ACMS" : "AASI",
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Expanded(
                              flex: 1,
                              child: Button(
                                color: Colors.lightGreen,
                                label: "Gerar",
                                onPressed: () async {
                                  List<Conciliacao> csvList = [];
                                  for (var file in files) {
                                    String csvData =
                                        File.fromRawPath(file.bytes!).path;
                                    List<String> datas = csvData
                                        .replaceAll('\r\n', '\r')
                                        .replaceAll('\n', '\r')
                                        .split("\r");
                                    datas.removeAt(0);
                                    String conta =
                                        datas.first.split(' ')[6].split('-')[0];
                                    datas.removeRange(0, 2);
                                    datas.removeWhere((element) =>
                                        element == ' ' ||
                                        element == '' ||
                                        element == '\r' ||
                                        element.split(";")[0] == "Total" ||
                                        element.split(";")[0] == "Data" ||
                                        element.split(" ")[0].split(';')[1] ==
                                            "�ltimos" ||
                                        element.split(" ")[0] == ";Saldos" ||
                                        element.split(';')[1].split(' ')[0] ==
                                            'SALDO');
                                    for (var element in datas) {
                                      List<String?> list = element.split(";");
                                      if(element[0] != null || element[0] != "" || element[0] != " "){
                                        csvList.add(
                                        Conciliacao(
                                          conta,
                                          list[0]!,
                                          list[1]!,
                                          list[2] != null || list[2] != "" ? list[2]! : "",
                                          list[3] != ""
                                              ? list[3] != null
                                                  ? list[3]!
                                                      .replaceAll(".", "")
                                                      .replaceAll(",", "")
                                                  : list[4]!
                                                      .replaceAll(".", "")
                                                      .replaceAll(",", "")
                                              : list[4]!
                                                  .replaceAll(".", "")
                                                  .replaceAll(",", ""),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                  String jsonCsvEncoded = jsonEncode(csvList);
                                  List<dynamic> jsonCsvDecoded =
                                      jsonDecode(jsonCsvEncoded);
                                  List<String> text = acms
                                      ? [
                                          "Bank	BankAccountNumber	Date	Description	Value"
                                        ]
                                      : [];
                                  for (var element in jsonCsvDecoded) {
                                    if (acms) {
                                      text.add(
                                          "237	${element["conta"]}${poupanca ? "1" : ""}	${element["data"]}	${element["lancamento"]} - ${element["doc"]}	${element["valor"]}");
                                    } else {
                                      List<String> letters = element["valor"]!
                                          .split('')
                                          .reversed
                                          .toList();
                                      letters.insert(2, ',');
                                      text.add(
                                          "${element["data"]};${element["lancamento"]};${element["doc"]};${element["valor"]!.contains('-') ? '' : letters.reversed.join()};${element["valor"]!.contains('-') ? letters.reversed.join().replaceAll("-", '') : ''}");
                                    }
                                  }
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
                                    ..download =
                                        'Conciliacao.${acms ? 'txt' : 'csv'}';
                                  html.document.body!.children.add(anchor);

                                  // download
                                  anchor.click();

                                  // cleanup
                                  html.document.body!.children.remove(anchor);
                                  html.Url.revokeObjectUrl(url);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Expanded(
                              flex: 1,
                              child: Button(
                                color: Colors.blue,
                                label: "Sair",
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
    ),
    Tooltip(
      message: 'Reconciliação',
      child: IconButton(
        icon: Icon(Icons.plagiarism_rounded),
        onPressed: () async {
          PlatformFile? file;
          showDialog(
            context: context,
            builder: (context) {
              List<String> entidades = ["134811", "134893", "134812", "134821"];
              String entidade = "134811";

              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: Row(
                      children: [
                        Text("Reconciliação"),
                        Expanded(
                          child: Container(),
                        ),
                        DropdownButton<String>(
                          value: entidade,
                          onChanged: (value) {
                            setState(() {
                              entidade = value!;
                            });
                          },
                          items: List.generate(
                            4,
                            (index) => DropdownMenuItem(
                              child: Text(entidades[index]),
                              value: entidades[index],
                            ),
                          ),
                        ),
                      ],
                    ),
                    content: InkWell(
                      child: Text(
                        file != null
                            ? "${file!.name}"
                            : "Clique para escolher o arquivo",
                      ),
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: [
                            'csv',
                          ],
                        );
                        if (result != null) {
                          setState(() {
                            file = result.files.first;
                          });
                        }
                      },
                    ),
                    actions: [
                      Row(
                        children: [
                          Flexible(
                            child: Button(
                              color: Colors.orange,
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ConfigReconciliacao(gerenciador),
                                  ),
                                );
                              },
                              label: "Configurações",
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Flexible(
                            child: Button(
                              color: Colors.lightGreen,
                              label: "Gerar",
                              onPressed: () async {
                                List<Conciliacao> csvList = [];
                                String csvData =
                                    File.fromRawPath(file!.bytes!).path;
                                List<String> datas = csvData
                                    .replaceAll('\r\n', '\r')
                                    .replaceAll('\n', '\r')
                                    .split("\r");
                                datas.removeAt(0);
                                String conta =
                                    datas.first.split(' ')[6].split('-')[0];
                                datas.removeRange(0, 2);
                                datas.removeWhere((element) =>
                                    element == ' ' ||
                                    element == '' ||
                                    element == '\r' ||
                                    element.split(";")[0] == "Data" ||
                                    element.split(" ")[0].split(';')[1] ==
                                        "�ltimos" ||
                                    element.split(" ")[0] == ";Saldos" ||
                                    element.split(';')[1].split(' ')[0] ==
                                        'SALDO');

                                datas.removeRange(
                                  datas.indexWhere((element) =>
                                      element.split(";")[0] == "Total"),
                                  datas.length - 1,
                                );
                                datas.removeLast();
                                String removerAcentos(String texto) {
                                  String comAcentos =
                                      "ÁÂÀÃáâàãÉÊéêÍÎíîÓÔÕóôõÚÛúûÇç";
                                  String semAcentos =
                                      "AAAAaaaaEEeeIIiiOOOoooUUuuCc";

                                  for (int i = 0; i < comAcentos.length; i++) {
                                    texto = texto.replaceAll(
                                        comAcentos[i].toString(),
                                        semAcentos[i].toString());
                                  }
                                  return texto;
                                }

                                for (var element in datas) {
                                  List<String?> list = element.split(";");
                                  csvList.add(
                                    Conciliacao(
                                      conta,
                                      list[0]!,
                                      removerAcentos(list[1]!),
                                      list[2]!,
                                      list[3] != ""
                                          ? list[3] != null
                                              ? list[3]!
                                                  .replaceAll(".", "")
                                                  .replaceAll(",", "")
                                              : list[4]!
                                                  .replaceAll(".", "")
                                                  .replaceAll(",", "")
                                                  .replaceAll("-", "")
                                          : list[4]!
                                              .replaceAll(".", "")
                                              .replaceAll(",", "")
                                              .replaceAll("-", ""),
                                    ),
                                  );
                                }
                                List<String> text = [];
                                text.add(entidade);
                                String jsonCsvEncoded = jsonEncode(csvList);
                                List<dynamic> jsonCsvDecoded =
                                    jsonDecode(jsonCsvEncoded);

                                QuerySnapshot<Map<String, dynamic>> rules =
                                    await db.collection("contabeis").get();
                                for (var element in jsonCsvDecoded) {
                                  Contabil rule = Contabil.fromMap(
                                      rules.docs.firstWhereOrNull(
                                    (rule) {
                                      return element["lancamento"]
                                          .toString()
                                          .toLowerCase()
                                          .contains(
                                            rule["historico"]
                                                .toString()
                                                .toLowerCase(),
                                          );
                                    },
                                  ));
                                  text.add(
                                      "${rule.contaCred};${rule.subContaCred};${rule.departCred};${rule.fundoCred};${rule.tipoCred};${element["valor"]};${rule.aviso};${element["lancamento"]} - ${element["doc"]} - ${element["data"]}");
                                  text.add(
                                      "${rule.contaDep};${rule.subContaDep};${rule.departDep};${rule.fundoDep};${rule.tipoDep};-${element["valor"]};${rule.aviso};${element["lancamento"]} - ${element["doc"]} - ${element["data"]}");
                                }
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
                                  ..download = 'Reconciliacao.csv';
                                html.document.body!.children.add(anchor);

                                // download
                                anchor.click();

                                // cleanup
                                html.document.body!.children.remove(anchor);
                                html.Url.revokeObjectUrl(url);
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Expanded(
                            flex: 1,
                            child: Button(
                              color: Colors.blue,
                              label: "Sair",
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
        },
      ),
    ),
    Tooltip(
      message: 'Lições',
      child: IconButton(
        icon: Icon(Icons.menu_book),
        onPressed: () async {
          String? escolhido;
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
                  onChanged: (dynamic value) {
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
                  validator: (dynamic value) {
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
    ),
    Tooltip(
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
                                  element["conta"]!.split("-")[0] == value &&
                                  bancaria) !=
                              -1) {
                            setState(() {
                              igrejaCod =
                                  "${jsonList[jsonList.indexWhere((element) => element["conta"]!.split("-")[0] == value)]["cod"]} - ${jsonList[jsonList.indexWhere((element) => element["conta"]!.split("-")[0] == value)]["nome"]}";
                              searched = "achou";
                            });
                          } else if (jsonList.indexWhere(
                                    (element) => element["cod"] == value,
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
                              child: Button(
                                color: Colors.orange,
                                onPressed: () {
                                  setState(() {
                                    searched = "espera";
                                    bancaria = !bancaria;
                                  });
                                },
                                label: bancaria ? "Conta Banc." : "Cod. Igreja",
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Expanded(
                              flex: 1,
                              child: Button(
                                color: Colors.lightGreen,
                                label: "Pesquisar",
                                onPressed: () async {
                                  List<Map<String, String>> jsonList =
                                      json.decode(result.toString());
                                  if (jsonList.indexWhere((element) =>
                                          element["conta"]!.split("-")[0] ==
                                              conta &&
                                          bancaria) !=
                                      -1) {
                                    setState(() {
                                      igrejaCod =
                                          "${jsonList[jsonList.indexWhere((element) => element["conta"]!.split("-")[0] == conta)]["cod"]} - ${jsonList[jsonList.indexWhere((element) => element["conta"]!.split("-")[0] == conta)]["nome"]}";
                                      searched = "achou";
                                    });
                                  } else if (jsonList.indexWhere((element) =>
                                              element["cod"] == conta) !=
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
                            Expanded(
                              child: Container(),
                            ),
                            Expanded(
                              flex: 1,
                              child: Button(
                                color: Colors.blue,
                                label: "Sair",
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
          }),
    ),
    tela == 'adicionar'
        ? Tooltip(
            message: igreja! ? 'Igreja' : 'Distrito',
            child: IconButton(
                icon: Icon(igreja ? Icons.account_balance : Icons.business),
                onPressed: () {
                  setDistrito!();
                }),
          )
        : Container(),
    tela != 'coelba'
        ? gerenciador == 'gerenciador'
            ? Tooltip(
                message: 'Coelba/Embasa',
                child: IconButton(
                    icon: Icon(Icons.data_usage),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CoelbaEmbasa(gerenciador),
                        ),
                      );
                    }),
              )
            : Container()
        : Container(),
    gerenciador == 'gerenciador' && tela != 'depositos'
        ? Tooltip(
            message: 'Depositos Manuais',
            child: IconButton(
                icon: Icon(Icons.monetization_on_sharp),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Deposito(c1),
                    ),
                  );
                }),
          )
        : Container(),
    kIsWeb
        ? gerenciador == 'gerenciador' && tela != 'dinheiro'
            ? Tooltip(
                message: 'Protocolo Caixa',
                child: IconButton(
                    icon: Icon(Icons.calculate),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Dinheiro(c2),
                        ),
                      );
                    }),
              )
            : Container()
        : Container(),
    tela != 'registrar'
        ? gerenciador == 'gerenciador'
            ? Tooltip(
                message: 'Registrar',
                child: IconButton(
                    icon: Icon(Icons.person_add),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Registro(),
                          ));
                    }),
              )
            : Container()
        : Container(),
    tela != 'adicionar'
        ? gerenciador == 'gerenciador'
            ? Tooltip(
                message: 'Adicionar',
                child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Adicionar(),
                        ),
                      );
                    }),
              )
            : Container()
        : Container(),
  ];
}

drawer(String gerenciador, BuildContext context, String tela, {Auth? auth}) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text(
            '7Rank',
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
            ? gerenciador == "gerenciador"
                ? ListTile(
                    title: Text('Adicionar'),
                    leading: Icon(Icons.add),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Adicionar(),
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
                            builder: (context) => Registro(),
                          ));
                    },
                  )
                : Container()
            : Container(),
        ListTile(
          title: Text('Etiqueta'),
          leading: Icon(Icons.local_offer),
          onTap: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    "Escolha um distrito",
                    textAlign: TextAlign.center,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField(
                        onChanged: (dynamic value) {
                          distritoEtiqueta = value;
                        },
                        onSaved: (dynamic value) {
                          distritoEtiqueta = value;
                        },
                        hint: Text("Distritos"),
                        items: distritos,
                        value: distritoEtiqueta,
                      ),
                    ],
                  ),
                  actions: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Button(
                            color: Colors.lightGreen,
                            label: 'Gerar',
                            onPressed: () {
                              Printing.layoutPdf(
                                onLayout: (format) {
                                  return buildPdfEtiqueta(
                                    distritoEtiqueta,
                                    currentDate(dataAtual: true).split("/")[2],
                                  );
                                },
                              );
                              Navigator.of(context).pop();
                              distritoEtiqueta = "";
                            },
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Expanded(
                          flex: 1,
                          child: Button(
                            color: Colors.blue,
                            label: 'Cancelar',
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
        ),
        ListTile(
          title: Text("Conciliação Bancária"),
          leading: Icon(Icons.insert_drive_file_rounded),
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowMultiple: true,
              allowedExtensions: [
                'csv',
              ],
            );
            if (result != null) {
              List<PlatformFile> files = result.files;
              bool poupanca = false;
              bool acms = true;

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
                                child: Button(
                                  color: Colors.deepOrange,
                                  onPressed: () {
                                    setState(() {
                                      poupanca = !poupanca;
                                    });
                                  },
                                  label: poupanca ? "Poupança" : "Corrente",
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              Expanded(
                                flex: 1,
                                child: Button(
                                  color: Colors.orange,
                                  onPressed: () {
                                    setState(() {
                                      acms = !acms;
                                    });
                                  },
                                  label: acms ? "ACMS" : "AASI",
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              Expanded(
                                flex: 1,
                                child: Button(
                                  color: Colors.lightGreen,
                                  label: "Gerar",
                                  onPressed: () async {
                                    List<Conciliacao> csvList = [];
                                    for (var file in files) {
                                      String csvData =
                                          File.fromRawPath(file.bytes!).path;
                                      List<String> datas = csvData
                                          .replaceAll('\r\n', '\r')
                                          .replaceAll('\n', '\r')
                                          .split("\r");
                                      datas.removeAt(0);
                                      String conta = datas.first
                                          .split(' ')[6]
                                          .split('-')[0];
                                      datas.removeRange(0, 2);
                                      datas.removeWhere((element) =>
                                          element == ' ' ||
                                          element == '' ||
                                          element == '\r' ||
                                          element.split(";")[0] == "Total" ||
                                          element.split(";")[0] == "Data" ||
                                          element.split(" ")[0].split(';')[1] ==
                                              "�ltimos" ||
                                          element.split(" ")[0] == ";Saldos" ||
                                          element.split(';')[1].split(' ')[0] ==
                                              'SALDO');
                                      for (var element in datas) {
                                        List<String?> list = element.split(";");
                                        csvList.add(
                                          Conciliacao(
                                            conta,
                                            list[0]!,
                                            list[1]!,
                                            list[2]!,
                                            list[3] != ""
                                                ? list[3] != null
                                                    ? list[3]!
                                                        .replaceAll(".", "")
                                                        .replaceAll(",", "")
                                                    : list[4]!
                                                        .replaceAll(".", "")
                                                        .replaceAll(",", "")
                                                : list[4]!
                                                    .replaceAll(".", "")
                                                    .replaceAll(",", ""),
                                          ),
                                        );
                                      }
                                    }
                                    String jsonCsvEncoded = jsonEncode(csvList);
                                    List<Map<String, String>> jsonCsvDecoded =
                                        jsonDecode(jsonCsvEncoded);
                                    List<String> text = acms
                                        ? [
                                            "Bank	BankAccountNumber	Date	Description	Value"
                                          ]
                                        : [];
                                    for (var element in jsonCsvDecoded) {
                                      if (acms) {
                                        text.add(
                                            "237	${element["conta"]}${poupanca ? "1" : ""}	${element["data"]}	${element["lancamento"]} - ${element["doc"]}	${element["valor"]}");
                                      } else {
                                        List<String> letters = element["valor"]!
                                            .split('')
                                            .reversed
                                            .toList();
                                        letters.insert(2, ',');
                                        text.add(
                                            "${element["data"]};${element["lancamento"]};${element["doc"]};${element["valor"]!.contains('-') ? '' : letters.reversed.join()};${element["valor"]!.contains('-') ? letters.reversed.join().replaceAll("-", '') : ''}");
                                      }
                                    }
                                    if (kIsWeb) {
                                      var anchor;
                                      var url;
                                      // prepare
                                      final bytes =
                                          utf8.encode(text.join("\n"));
                                      final blob = html.Blob([bytes]);
                                      url = html.Url.createObjectUrlFromBlob(
                                          blob);
                                      anchor = html.document.createElement('a')
                                          as html.AnchorElement
                                        ..href = url
                                        ..style.display = 'none'
                                        ..download =
                                            'Conciliacao.${acms ? 'txt' : 'csv'}';
                                      html.document.body!.children.add(anchor);

                                      // download
                                      anchor.click();

                                      // cleanup
                                      html.document.body!.children
                                          .remove(anchor);
                                      html.Url.revokeObjectUrl(url);
                                    } else {
                                      final file = await File(
                                              'Conciliacao.${acms ? 'txt' : 'csv'}')
                                          .writeAsString(
                                        text.join("\n"),
                                      );
                                      await file.open();
                                    }
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Button(
                                    color: Colors.blue,
                                    label: "Sair",
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )),
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
        ListTile(
          title: Text('Lições'),
          leading: Icon(Icons.menu_book),
          onTap: () async {
            String? escolhido;
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
                    onChanged: (dynamic value) {
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
                    validator: (dynamic value) {
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
        ListTile(
            title: Text('Pesquisa por conta'),
            leading: Icon(
              Icons.search,
            ),
            onTap: () async {
              String result = await DefaultAssetBundle.of(context)
                  .loadString('assets/contas.json');
              String conta = "";
              String searched = "espera";
              String igrejaCod = "";
              bool bancaria = true;
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
                                    element["conta"]!.split("-")[0] == value &&
                                    bancaria) !=
                                -1) {
                              setState(() {
                                igrejaCod =
                                    "${jsonList[jsonList.indexWhere((element) => element["conta"]!.split("-")[0] == value)]["cod"]} - ${jsonList[jsonList.indexWhere((element) => element["conta"]!.split("-")[0] == value)]["nome"]}";
                                searched = "achou";
                              });
                            } else if (jsonList.indexWhere(
                                      (element) => element["cod"] == value,
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
                                child: Button(
                                  color: Colors.orange,
                                  onPressed: () {
                                    setState(() {
                                      searched = "espera";
                                      bancaria = !bancaria;
                                    });
                                  },
                                  label:
                                      bancaria ? "Conta Banc." : "Cod. Igreja",
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              Expanded(
                                flex: 1,
                                child: Button(
                                  color: Colors.lightGreen,
                                  label: "Pesquisar",
                                  onPressed: () async {
                                    List<Map<String, String>> jsonList =
                                        json.decode(result.toString());
                                    if (jsonList.indexWhere((element) =>
                                            element["conta"]!.split("-")[0] ==
                                                conta &&
                                            bancaria) !=
                                        -1) {
                                      setState(() {
                                        igrejaCod =
                                            "${jsonList[jsonList.indexWhere((element) => element["conta"]!.split("-")[0] == conta)]["cod"]} - ${jsonList[jsonList.indexWhere((element) => element["conta"]!.split("-")[0] == conta)]["nome"]}";
                                        searched = "achou";
                                      });
                                    } else if (jsonList.indexWhere((element) =>
                                                element["cod"] == conta) !=
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
                              Expanded(
                                child: Container(),
                              ),
                              Expanded(
                                flex: 1,
                                child: Button(
                                  color: Colors.blue,
                                  label: "Sair",
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
            }),
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

class Contabil {
  final String contaCred;
  final String contaDep;
  final String subContaCred;
  final String subContaDep;
  final String departCred;
  final String departDep;
  final String tipoCred;
  final String tipoDep;
  final String fundoCred;
  final String fundoDep;
  final String aviso;

  Contabil({
    required this.contaCred,
    required this.contaDep,
    required this.subContaCred,
    required this.subContaDep,
    required this.departCred,
    required this.departDep,
    required this.tipoCred,
    required this.tipoDep,
    required this.fundoCred,
    required this.fundoDep,
    required this.aviso,
  });

  factory Contabil.fromMap(QueryDocumentSnapshot<Map<String, dynamic>>? map) {
    return Contabil(
      contaCred: map != null ? map['contaCred'] : "FALTA CADASTRAR",
      contaDep: map != null ? map['contaDep'] : "FALTA CADASTRAR",
      subContaCred: map != null ? map['subContaCred'] : "!",
      subContaDep: map != null ? map['subContaDep'] : "!",
      departCred: map != null ? map['departCred'] : "!",
      departDep: map != null ? map['departDep'] : "!",
      tipoCred: map != null ? map['tipoCred'] : "!",
      tipoDep: map != null ? map['tipoDep'] : "!",
      fundoCred: map != null ? map['fundoCred'] : "!",
      fundoDep: map != null ? map['fundoDep'] : "!",
      aviso: map != null ? map['aviso'] : "!",
    );
  }
}
