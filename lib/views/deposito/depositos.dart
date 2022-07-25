import 'dart:typed_data';

import 'package:dcache/dcache.dart';
import 'package:file_picker/file_picker.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:printing/printing.dart';
import 'package:remessa/models/widgets/Button.dart';
import 'package:remessa/models/widgets/consts.dart';
import "package:flutter/material.dart";
import 'package:remessa/views/deposito/page_view/photo_view_deposito.dart';
import 'package:remessa/views/deposito/pdf_deposito.dart';
import 'package:remessa/views/deposito/radio_group_deposito.dart';
import 'dart:convert';
import 'package:universal_html/html.dart' as html;

import 'common_deposito.dart';

class Deposito extends StatefulWidget {
  Deposito();
  @override
  _DepositoState createState() => _DepositoState();
}

class _DepositoState extends State<Deposito> {
  void _pegarDados() {
    db.collection("igrejas").orderBy('nome').get().then((value) {
      value.docs.forEach((doc) {
        igrejas[doc["cod"].toString()] = doc['nome'].toString();
      });
    });
    if (c1.get("depositos") != null) {
      depositos = c1.get("depositos")!;
    }
    if (c1.get("amostra") != null) {
      amostra = c1.get("amostra")!;
    }

    if (preferences!.getStringList("contas") != null) {
        contas = preferences!.getStringList("contas")!;
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
      ..download = conta == "Recibo Caixa"
          ? "Recibo Caixa - ${currentDate(dataAtual: true)}"
          : '$conta.txt';
    html.document.body!.children.add(anchor);

    // download
    anchor.click();

    // cleanup
    html.document.body!.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  void onChange(int index) {
    setState(() {
      page = index;
    });
  }

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    initializeControllers();
    _pegarDados();
  }

  @override
  void dispose() {
    myFocusNode!.dispose();
    controllerCod.dispose();
    controllerDate.dispose();
    controllerDc.dispose();
    controllerRM.dispose();
    controllerVl.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Depositos Manuais"),
        actions: actions('gerenciador', context, 'depositos'),
      ),
      body: Row(
        children: [
          SizedBox(width: 20),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 50, 10, 20),
              child: Column(
                children: [
                  RadioGroupDeposito(
                      groupValue: conta,
                      preferences: preferences,
                      values: contas,
                      onChange: (String? text) {
                        setState(() {
                          conta = text!;
                        });
                      }),
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
                      String vl = controllerVl.text
                          .split(" ")[1]
                          .replaceAll(",", "")
                          .replaceAll(".", "");
                      scrollController.animateTo(
                        0.0,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 300),
                      );
                      c1.set("depositos", depositos);
                      c1.set("amostra", amostra);
                      setState(() {
                        depositos.insert(
                            0,
                            conta == "Recibo Caixa"
                                ? "${date[0]}	${date[1]}	${date[2]}	Recibo Caixa ${controllerDc.text} - Rm ${controllerRM.text}	${controllerCod.text}	${controllerDc.text}	$vl"
                                : "${date[0]}	${date[1]}	${date[2]}	Deposito em ${controllerDate.text} - Rm ${controllerRM.text} - ${controllerDc.text}	${controllerCod.text}	${controllerDc.text}	$vl");
                        amostra.insert(0,
                            "${igrejas[controllerCod.text]} - ${controllerCod.text} - ${controllerDate.text} - Remessa ${controllerRM.text} - Doc ${controllerDc.text} - ${controllerVl.text}");
                        controllerCod.text = '';
                        controllerDc.text = '';
                        controllerVl.text = "R\$ 0,00";
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
                              if (data != []) {
                                Printing.layoutPdf(
                                  onLayout: (format) {
                                    return buildPdfDeposito(data);
                                  },
                                );
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
                              c1.get("depositos")!.clear();
                              c1.get("amostra")!.clear();
                              setState(() {
                                depositos = [];
                                amostra = [];
                                data = [];
                                controllerCod.text = '';
                                controllerDate.text = '';
                                controllerRM.text = '';
                                controllerDc.text = '';
                                focus = 0;
                              });
                              c1.set("depositos", depositos);
                              c1.set("amostra", amostra);
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
                        controller: scrollController,
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
          ),
          SizedBox(width: 20),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(5)),
              child: data.isEmpty
                  ? Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(
                                  allowMultiple: true,
                                  type: FileType.custom,
                                  allowedExtensions: ["jpg", "png", "pdf"]);
                          if (result != null) {
                            List<Uint8List> datas = [];
                            controllerCod.text =
                                result.files.first.name.split(" ")[0];
                            List<String> dateNum = result.files.first.name
                                .split(" ")[1]
                                .split(".")[0]
                                .split("");
                            String rawDate =
                                "${dateNum[0]}${dateNum[1]}${dateNum[2]}${dateNum[3]}20${dateNum[4]}${dateNum[5]}";
                            controllerDate.text = formatDate.maskText(rawDate);
                            title = igrejas[controllerCod.text];
                            for (var file in result.files) {
                              Uint8List bytes = file.bytes!;
                              if (file.extension == "pdf") {
                                final document =
                                    await PdfDocument.openData(bytes);
                                final page = await document.getPage(1);
                                final pageImage = await page.render(
                                    width: page.width,
                                    height: page.height,
                                    format: PdfPageImageFormat.jpeg);
                                datas.add(pageImage!.bytes);
                                await page.close();
                              } else {
                                datas.add(bytes);
                              }
                            }
                            setState(() {
                              data = datas;
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Selecione pelo menos um arquivo"),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Tudo Bem"),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: Text("Selecionar Arquivos"),
                      ),
                    )
                  : PageView.builder(
                      itemBuilder: (context, index) {
                        return PhotoViewDespesa(data: data[index]);
                      },
                      onPageChanged: onChange,
                      itemCount: data.length,
                      controller: pageController,
                    ),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}
