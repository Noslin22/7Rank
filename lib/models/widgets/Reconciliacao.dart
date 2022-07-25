import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:remessa/models/pages/reconciliacao/config_reconciliacao.dart';

import 'Button.dart';
import 'Conciliacao.dart';
import 'consts.dart';

Widget buildReconciliacaoDialog({
  PlatformFile? file,
  required String gerenciador,
}) {
  List<String> entidades = ["134811", "134893", "134812", "134821"];
  final controller = TextEditingController();
  String entidade = "134811";

  if (preferences!.getStringList("entidades") != null) {
    entidades = preferences!.getStringList("entidades")!;
    entidade = entidades[0];
  }

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
                entidades.length,
                (index) => DropdownMenuItem(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(entidades[index]),
                      SizedBox(
                        width: 12,
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Gerenciar Entidade"),
                              content: TextField(
                                controller: controller..text = entidades[index],
                                decoration: inputDecoration.copyWith(
                                  hintText: "Digite a entidade",
                                ),
                              ),
                              actions: [
                                Row(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.red),
                                      onPressed: () {
                                        entidades.removeAt(index);
                                        preferences!.setStringList(
                                            "entidades", entidades);
                                        Navigator.pop(context);
                                      },
                                      child: Row(
                                        children: [
                                          Text("Excluir"),
                                          Icon(Icons.delete),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.green),
                                      onPressed: () {
                                        entidades[entidades
                                                .indexOf(entidades[index])] =
                                            controller.text;
                                        preferences!.setStringList(
                                            "entidades", entidades);
                                        Navigator.pop(context);
                                      },
                                      child: Row(
                                        children: [
                                          Text("Salvar"),
                                          Icon(Icons.check),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  value: entidades[index],
                ),
              ),
            ),
          ],
        ),
        content: InkWell(
          child: Text(
            file != null ? "${file!.name}" : "Clique para escolher o arquivo",
          ),
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
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
                        builder: (context) => ConfigReconciliacao(gerenciador),
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
                    List<String> text = [];
                    text.add(entidade);

                    QuerySnapshot<Map<String, dynamic>> rules =
                        await db.collection("contabeis").get();
                    for (var element in organizeReconcFile(file!)) {
                      Configuration rule =
                          Configuration.fromMap(rules.docs.firstWhereOrNull(
                        (rule) {
                          return element["lancamento"]
                              .toString()
                              .toLowerCase()
                              .contains(
                                rule["historico"].toString().toLowerCase(),
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
                    anchor =
                        html.document.createElement('a') as html.AnchorElement
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
}

organizeReconcFile(PlatformFile file) {
  String csvData = File.fromRawPath(file.bytes!).path;
  List<String> datas = csvData.split("\r\n");
  List<Conciliacao> csv = [];

  datas.removeAt(0);
  datas.removeLast();

  for (var element in datas) {
    List<String?> list = element.split(";");
    csv.add(
      Conciliacao(
        data: list[0]!.split(" ")[0],
        documento: list[1]!,
        lancamento: list[2]!,
        valor: list[3] != null && list[3] != ""
            ? list[3]!.contains(",")
                ? list[3]!.split(",").length == 1
                    ? list[3]!.replaceAll(".", "").replaceAll(",", "") + "0"
                    : list[3]!.replaceAll(".", "").replaceAll(",", "")
                : list[3]!.replaceAll(".", "") + "00"
            : list[4]!.contains(",") && list[4] != ""
                ? list[4]!.split(",").length == 1
                    ? list[4]!.replaceAll(".", "").replaceAll(",", "") + "0"
                    : list[4]!.replaceAll(".", "").replaceAll(",", "")
                : list[4]!.replaceAll(".", "") + "00",
      ),
    );
  }
  String jsonCsvEncoded = jsonEncode(csv);
  return jsonDecode(jsonCsvEncoded);
}

class Configuration {
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

  Configuration({
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

  factory Configuration.fromMap(
      QueryDocumentSnapshot<Map<String, dynamic>>? map) {
    return Configuration(
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
