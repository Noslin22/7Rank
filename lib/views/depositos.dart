import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:remessa/models/widgets/consts.dart';
import "package:flutter/material.dart";
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class Deposito extends StatefulWidget {
  @override
  _DepositoState createState() => _DepositoState();
}

class _DepositoState extends State<Deposito> {
  var formatDate = new MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  var formatRm = new MaskTextInputFormatter(
    mask: '##/####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  TextEditingController controllerDate = TextEditingController();
  TextEditingController controllerCod = TextEditingController();
  TextEditingController controllerRM = TextEditingController();
  TextEditingController controllerDc = TextEditingController();
  TextEditingController controllerVl = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  String title = "Código da Igreja";
  Map<String, String> igrejas = {};
  List<String> depositos = [];
  List<String> amostra = [];
  FocusNode myFocusNode;
  String conta = "128076-7";
  String cod = "";
  int focus = 0;

  _pegarDados() {
    db.collection("igrejas").orderBy('nome').get().then((value) {
      value.docs.forEach((doc) {
        igrejas[doc["cod"].toString()] = doc['nome'].toString();
      });
    });
  }

  _write(List<String> list) async {
    var anchor;
    var url;
    // prepare
    String text =
        "Day	Month	Year	Description	Church Code	Document	Value\n${list.join("\n")}";
    final bytes = utf8.encode(text);
    final blob = html.Blob([bytes]);
    url = html.Url.createObjectUrlFromBlob(blob);
    anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = '$conta.txt';
    html.document.body.children.add(anchor);

    // download
    anchor.click();

    // cleanup
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    _pegarDados();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Depositos Manuais"),
      ),
      body: Row(
        children: [
          Expanded(
            child: Container(),
            flex: 1,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 50, 10, 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Radio(
                              value: "128076-7",
                              groupValue: conta,
                              onChanged: (text) {
                                setState(() {
                                  conta = text;
                                });
                              }),
                          Text("128076-7"),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                              value: "41500-6",
                              groupValue: conta,
                              onChanged: (text) {
                                setState(() {
                                  conta = text;
                                });
                              }),
                          Text("41500-6"),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                              value: "43266-0",
                              groupValue: conta,
                              onChanged: (text) {
                                setState(() {
                                  conta = text;
                                });
                              }),
                          Text("43266-0"),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                              value: "136385-1",
                              groupValue: conta,
                              onChanged: (text) {
                                setState(() {
                                  conta = text;
                                });
                              }),
                          Text("136385-1"),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                              value: "342-5",
                              groupValue: conta,
                              onChanged: (text) {
                                setState(() {
                                  conta = text;
                                });
                              }),
                          Text("342-5"),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controllerCod,
                          onChanged: (value) {
                            setState(() {
                              cod = value;
                            });
                          },
                          focusNode: focus == 0 ? myFocusNode : null,
                          onSubmitted: (value) {
                            setState(() {
                              focus = 1;
                              title = igrejas[controllerCod.text];
                            });
                            myFocusNode = FocusNode();
                            myFocusNode.requestFocus();
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: title,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                          controller: controllerDate,
                          inputFormatters: [formatDate],
                          focusNode: focus == 1 ? myFocusNode : null,
                          onSubmitted: (value) {
                            setState(() {
                              focus = 2;
                            });
                            myFocusNode = FocusNode();
                            myFocusNode.requestFocus();
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Data',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controllerRM,
                          inputFormatters: [formatRm],
                          focusNode: focus == 2 ? myFocusNode : null,
                          onSubmitted: (value) {
                            setState(() {
                              focus = 3;
                            });
                            myFocusNode = FocusNode();
                            myFocusNode.requestFocus();
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Remessa',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                          controller: controllerDc,
                          focusNode: focus == 3 ? myFocusNode : null,
                          onSubmitted: (value) {
                            setState(() {
                              focus = 4;
                            });
                            myFocusNode = FocusNode();
                            myFocusNode.requestFocus();
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Documento',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: controllerVl,
                    focusNode: focus == 4 ? myFocusNode : null,
                    onSubmitted: (value) {
                      List date = controllerDate.text.split('/');
                      String vl = controllerVl.text.replaceAll(",", "");
                      _scrollController.animateTo(
                        0.0,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 300),
                      );
                      setState(() {
                        depositos.add(
                            "${date[0]}	${date[1]}	${date[2]}	Deposito em ${controllerDate.text} - RM ${controllerRM.text} - ${controllerDc.text}	${controllerCod.text}	${controllerDc.text}	$vl");
                        amostra.insert(0,
                            "${igrejas[controllerCod.text]} - ${controllerDate.text} - Remessa ${controllerRM.text} - Doc ${controllerDc.text} - R\$ ${controllerVl.text}");
                        controllerCod.text = '';
                        controllerDate.text = '';
                        controllerRM.text = '';
                        controllerDc.text = '';
                        controllerVl.text = '';
                        focus = 0;
                      });
                      myFocusNode = FocusNode();
                      myFocusNode.requestFocus();
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Valor',
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                            color: Colors.orange,
                            child: Text(
                              "Exportar",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              if (depositos != []) {
                                _write(depositos);
                                setState(() {
                                  controllerCod.text = '';
                                  controllerDate.text = '';
                                  controllerRM.text = '';
                                  controllerDc.text = '';
                                  controllerVl.text = '';
                                  focus = 0;
                                });
                              }
                            }),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: RaisedButton(
                            color: Colors.lightGreen,
                            child: Text(
                              "Novo",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              setState(() {
                                depositos = [];
                                controllerCod.text = '';
                                controllerDate.text = '';
                                controllerRM.text = '';
                                controllerDc.text = '';
                                focus = 0;
                              });
                            }),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: amostra.length,
                        controller: _scrollController,
                        shrinkWrap: true,
                        reverse: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(amostra[index]),
                            trailing: FlatButton(
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              color: Colors.red,
                              onPressed: () {
                                setState(() {
                                  amostra.removeAt(index);
                                  depositos.removeAt(index);
                                });
                              },
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(),
            flex: 1,
          ),
        ],
      ),
    );
  }
}
