import 'package:dcache/dcache.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:remessa/models/widgets/Button.dart';
import 'package:remessa/models/widgets/consts.dart';
import "package:flutter/material.dart";
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class Deposito extends StatefulWidget {
  final SimpleCache<String, List<String>?> cache;
  Deposito(this.cache);
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
  String? title = "Código da Igreja";
  Map<String, String> igrejas = {};
  List<String> depositos = [];
  List<String> amostra = [];
  FocusNode? myFocusNode;
  String? conta = "128076-7";
  bool caixa = false;
  String cod = "";
  int focus = 0;

  _pegarDados() {
    db.collection("igrejas").orderBy('nome').get().then((value) {
      value.docs.forEach((doc) {
        igrejas[doc["cod"].toString()] = doc['nome'].toString();
      });
    });
    if (widget.cache.get("depositos") != null) {
      depositos = widget.cache.get("depositos")!;
    }
    if (widget.cache.get("amostra") != null) {
      amostra = widget.cache.get("amostra")!;
    }
  }

  _write(List<String> list) async {
    var anchor;
    var url;
    // prepare
    String text =
        "Day	Month	Year	Description	Church Code	Document	Value\n${list.reversed.join("\n")}";
    final bytes = utf8.encode(text);
    final blob = html.Blob([bytes]);
    url = html.Url.createObjectUrlFromBlob(blob);
    anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = caixa
          ? "Recibo Caixa - ${currentDate(dataAtual: true)}"
          : '$conta.txt';
    html.document.body!.children.add(anchor);

    // download
    anchor.click();

    // cleanup
    html.document.body!.children.remove(anchor);
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
    myFocusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showCentered = MediaQuery.of(context).size.width > 1110;
    return Scaffold(
      appBar: AppBar(
        title: Text("Depositos Manuais"),
      ),
      body: Row(
        children: [
          showCentered
              ? Expanded(
                  child: Container(),
                  flex: 1,
                )
              : Container(),
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
                              onChanged: (dynamic text) {
                                setState(() {
                                  conta = text;
                                  caixa = false;
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
                              onChanged: (dynamic text) {
                                setState(() {
                                  conta = text;
                                  caixa = false;
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
                              onChanged: (dynamic text) {
                                setState(() {
                                  conta = text;
                                  caixa = false;
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
                              onChanged: (dynamic text) {
                                setState(() {
                                  conta = text;
                                  caixa = false;
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
                              onChanged: (dynamic text) {
                                setState(() {
                                  conta = text;
                                  caixa = false;
                                });
                              }),
                          Text("342-5"),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                              value: "Recibo Caixa",
                              groupValue: conta,
                              onChanged: (dynamic text) {
                                setState(() {
                                  conta = text;
                                  caixa = true;
                                });
                              }),
                          Text("Recibo Caixa"),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
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
                            myFocusNode!.requestFocus();
                          },
                          decoration:
                              inputDecoration.copyWith(labelText: title),
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
                            myFocusNode!.requestFocus();
                          },
                          decoration:
                              inputDecoration.copyWith(labelText: "Data"),
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
                            myFocusNode!.requestFocus();
                          },
                          decoration:
                              inputDecoration.copyWith(labelText: "Remessa"),
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
                            myFocusNode!.requestFocus();
                          },
                          decoration:
                              inputDecoration.copyWith(labelText: "Documento"),
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
                      widget.cache.set("depositos", depositos);
                      widget.cache.set("amostra", amostra);
                      setState(() {
                        depositos.insert(
                            0,
                            caixa
                                ? "${date[0]}	${date[1]}	${date[2]}	Recibo Caixa ${controllerDc.text} - Rm ${controllerRM.text}	${controllerCod.text}	${controllerDc.text}	$vl"
                                : "${date[0]}	${date[1]}	${date[2]}	Deposito em ${controllerDate.text} - Rm ${controllerRM.text} - ${controllerDc.text}	${controllerCod.text}	${controllerDc.text}	$vl");
                        amostra.insert(0,
                            "${igrejas[controllerCod.text]} - ${controllerCod.text} - ${controllerDate.text} - Remessa ${controllerRM.text} - Doc ${controllerDc.text} - R\$ ${controllerVl.text}");
                        controllerCod.text = '';
                        controllerDc.text = '';
                        controllerVl.text = '';
                        title = "Código da Igreja";
                        focus = 0;
                      });
                      myFocusNode = FocusNode();
                      myFocusNode!.requestFocus();
                    },
                    decoration: inputDecoration.copyWith(labelText: "Valor"),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Button(
                            color: Colors.orange,
                            label: "Exportar",
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
                        child: Button(
                            color: Colors.lightGreen,
                            label: "Novo",
                            onPressed: () {
                              widget.cache.get("depositos")!.clear();
                              widget.cache.get("amostra")!.clear();
                              setState(() {
                                depositos = [];
                                amostra = [];
                                controllerCod.text = '';
                                controllerDate.text = '';
                                controllerRM.text = '';
                                controllerDc.text = '';
                                focus = 0;
                              });
                              widget.cache.set("depositos", depositos);
                              widget.cache.set("amostra", amostra);
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
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Button(
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
                                SizedBox(
                                  width: 10,
                                ),
                                Button(
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  color: Colors.orange,
                                  onPressed: () {
                                    List<String> text =
                                        amostra[index].split("-");
                                    setState(() {
                                      amostra.removeAt(index);
                                      depositos.removeAt(index);
                                      title =
                                          igrejas[text[1].replaceAll(" ", "")];
                                      controllerCod.text =
                                          text[1].replaceAll(" ", "");
                                      controllerDate.text =
                                          text[2].replaceAll(" ", "");
                                      controllerRM.text = text[3]
                                          .replaceAll(" ", "")
                                          .split("a")[1];
                                      controllerDc.text = text[4]
                                          .replaceAll(" ", "")
                                          .split("c")[1];
                                      controllerVl.text = text[5]
                                          .replaceAll(" ", "")
                                          .split("\$")[1];
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            flex: 2,
          ),
          showCentered
              ? Expanded(
                  child: Container(),
                  flex: 1,
                )
              : Container(),
        ],
      ),
    );
  }
}
