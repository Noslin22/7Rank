import 'dart:convert';
import 'dart:io';

import 'package:universal_html/html.dart' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'Button.dart';

Widget buildConciliacaoDialog({required FilePickerResult result}) {
  List<PlatformFile> files = result.files;
  bool poupanca = false;
  bool acms = true;

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
                    List<String> text = acms
                        ? ["Bank	BankAccountNumber	Date	Description	Value"]
                        : [];
                    for (var file in files) {
                      for (var element in organizeFile(file)) {
                        if (acms) {
                          text.add(
                              "237	${element["conta"]}${poupanca ? "1" : ""}	${element["data"]}	${element["lancamento"]} - ${element["doc"]}	${element["valor"]}");
                        } else {
                          List<String> letters =
                              element["valor"]!.split('').reversed.toList();
                          letters.insert(2, ',');
                          text.add(
                              "${element["data"]};${element["lancamento"]};${element["doc"]};${element["valor"]!.contains('-') ? '' : letters.reversed.join()};${element["valor"]!.contains('-') ? letters.reversed.join().replaceAll("-", '') : ''}");
                        }
                      }
                    }
                    if (kIsWeb) {
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
                            ..download = 'Conciliacao.${acms ? 'txt' : 'csv'}';
                      html.document.body!.children.add(anchor);

                      // download
                      anchor.click();

                      // cleanup
                      html.document.body!.children.remove(anchor);
                      html.Url.revokeObjectUrl(url);
                    } else {
                      final file =
                          await File('Conciliacao.${acms ? 'txt' : 'csv'}')
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
                ),
              ),
            ],
          )
        ],
      );
    },
  );
}

organizeFile(PlatformFile file) {
  List<Conciliacao> csv = [];
  String? conta;
  String csvData = File.fromRawPath(file.bytes!).path;
  List<String> datas =
      csvData.replaceAll('\r\n', '\r').replaceAll('\n', '\r').split("\r");
    datas.removeAt(0);
    conta = datas.first.split(' ')[6].split('-')[0];
    datas.removeRange(0, 2);
    datas.removeWhere(
      (element) =>
          element == ' ' ||
          element == '' ||
          element == '	' ||
          element.isEmpty ||
          element == '\r' ||
          element == '\n' ||
          element.split(";")[0] == "Total" ||
          element.split(";")[0] == "Data" ||
          element.split(" ")[0].split(';')[1] == "�ltimos" ||
          element.split(" ")[0] == ";Saldos" ||
          element.split(" ")[0] == ";Não" ||
          element.split(" ")[0] == ";N�o" ||
          element.split(';')[1].split(' ')[0] == 'SALDO',
    );
  
  for (var element in datas) {
    List<String?> list = element.split(";");
    csv.add(
      Conciliacao(
        conta: conta,
        data: list[0]!,
        lancamento: list[1]!,
        documento: list[2]!,
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

class Conciliacao {
  final String? conta;
  final String data;
  final String lancamento;
  final String documento;
  final String valor;

  Conciliacao({
    this.conta,
    required this.data,
    required this.lancamento,
    required this.documento,
    required this.valor,
  });

  Map toJson() => {
        'conta': conta,
        'data': data,
        'lancamento': lancamento,
        'doc': documento,
        'valor': valor,
      };
}