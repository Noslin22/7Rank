import 'dart:convert';
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
import 'package:remessa/models/widgets/Reconciliacao.dart';
import 'package:remessa/views/CoelbaEmbasa.dart';
import 'package:remessa/views/Home.dart';
import 'package:remessa/views/depositos.dart';
import 'package:remessa/views/dinheiro.dart';
import 'package:remessa/views/wrappers/Adicionar.dart';
import 'package:remessa/views/wrappers/WrappersAutenticate/Login.dart';
import 'package:remessa/views/wrappers/WrappersAutenticate/Registro.dart';
import 'package:universal_html/html.dart' as html;

import '../Auth.dart';
import 'Conciliacao.dart';

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
SimpleCache<String, double> c3 =
    SimpleCache<String, double>(
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
            showDialog(
              context: context,
              builder: (context) => buildConciliacaoDialog(result: result),
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
            builder: (context) => buildReconciliacaoDialog(gerenciador: gerenciador, file: file,),
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
                          builder: (context) => Dinheiro(c2, c3),
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
              showDialog(
                context: context,
                builder: (context)  => buildConciliacaoDialog(result: result),
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
