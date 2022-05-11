import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:universal_html/html.dart' as html;
import 'package:remessa/models/widgets/Button.dart';

import '../models/widgets/consts.dart';

class LancamentoContabil extends StatefulWidget {
  LancamentoContabil({Key? key}) : super(key: key);

  @override
  State<LancamentoContabil> createState() => _LancamentoContabilState();
}

class _LancamentoContabilState extends State<LancamentoContabil> {
  FilePickerResult? file;

  List<String> entidades = ["134811", "134893", "134812", "134821"];
  List<Lancamento> lancamentos = [];
  String entidade = "134811";

  Future<void> importFile() async {
    file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'csv',
      ],
      withData: true,
    );
    String csvData = File.fromRawPath(file!.files.single.bytes!).path;
    List<String> datas =
        csvData.replaceAll('\r\n', '\r').replaceAll('\n', '\r').split("\r");
    datas.removeAt(0);
    // conta = datas.first.split(' ')[6].split('-')[0];
    datas.removeRange(0, 2);
    datas.removeWhere(
      (element) =>
          element == ' ' ||
          element.replaceAll(";", "") == "" ||
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
      lancamentos.add(
        Lancamento(
          data: list[0]!,
          lancamento: list[1]!,
          checked: false,
          doc: list[2]!,
          valor: list[3] != null && list[3] != ""
              ? list[3]!.contains(",")
                  ? list[3]!.split(",")[1].length == 1
                      ? list[3]! + "0"
                      : list[3]!
                  : list[3]! + ",00"
              : list[4]!.contains(",") && list[4] != ""
                  ? list[4]!.split(",")[1].length == 1
                      ? list[4]! + "0"
                      : list[4]!
                  : list[4]! + ",00",
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool mobile = width <= 750;
    return Scaffold(
      appBar: AppBar(
        title: Text("Lançamento Contábil"),
        actions: mobile
            ? null
            : actions(
                "gerenciador",
                context,
                'lancamento',
              ),
      ),
      drawer: mobile ? drawer("gerenciador", context, 'home') : null,
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Button(
                  onPressed: () {
                    importFile();
                  },
                  color: Colors.green,
                  label: "Importar",
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
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Container(height: 12, width: 30),
                            ...List.generate(
                              lancamentos.length,
                              (index) => Radio<bool>(
                                value: true,
                                groupValue: lancamentos[index].checked,
                                toggleable: true,
                                onChanged: (_) {
                                  setState(() {
                                    lancamentos[index] = lancamentos[index]
                                        .copyWith(
                                            checked:
                                                !lancamentos[index].checked);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Data"),
                            ...List.generate(
                              lancamentos.length,
                              (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  lancamentos[index].data,
                                  style: TextStyle(
                                      color: lancamentos[index].checked
                                          ? Colors.red
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Lançamento"),
                            ...List.generate(
                              lancamentos.length,
                              (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  lancamentos[index].lancamento,
                                  style: TextStyle(
                                      color: lancamentos[index].checked
                                          ? Colors.red
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Documento"),
                            ...List.generate(
                              lancamentos.length,
                              (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  lancamentos[index].doc,
                                  style: TextStyle(
                                      color: lancamentos[index].checked
                                          ? Colors.red
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Valor"),
                            ...List.generate(
                              lancamentos.length,
                              (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  lancamentos[index].valor,
                                  style: TextStyle(
                                    color: lancamentos[index].checked
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Button(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      final formKey = GlobalKey<FormState>();
                      String conta = "";
                      String subconta = "";
                      return Form(
                        key: formKey,
                        child: AlertDialog(
                          title: Text("Selecionar Conta"),
                          content: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 128,
                                child: TextFormField(
                                  validator: (text) {
                                    if (text == null ||
                                        text.isEmpty ||
                                        text == " ") {
                                      return "Este campo é obrigatório";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    conta = value!;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Conta",
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              SizedBox(
                                width: 128,
                                child: TextFormField(
                                  validator: (text) {
                                    if (text == null ||
                                        text.isEmpty ||
                                        text == " ") {
                                      return "Este campo é obrigatório";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    subconta = value!;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Subconta",
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            SizedBox(
                              width: 70,
                              child: Button(
                                color: Colors.amber,
                                label: "Gerar",
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                    List<String> text = [];
                                    text.add("$entidade;;;;;;;");

                                    for (var lancamento in lancamentos
                                        .where((element) => element.checked)) {
                                      text.add(
                                          "$conta;$subconta;10;0;0A;${lancamento.valor.replaceAll(".", "").replaceAll(",", "")};N;${lancamento.lancamento} - ${lancamento.doc} - ${lancamento.data}");
                                    }

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
                                      ..download = 'lancamentos.csv';
                                    html.document.body!.children.add(anchor);
                                    anchor.click();
                                    html.document.body!.children.remove(anchor);
                                    html.Url.revokeObjectUrl(url);
                                    Navigator.of(context).pop();
                                    lancamentos
                                        .where((element) => element.checked)
                                        .forEach((element) {
                                      lancamentos[
                                              lancamentos.indexOf(element)] =
                                          element.copyWith(checked: false);
                                    });
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                label: "Gravar",
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Lancamento {
  final String data;
  final String lancamento;
  final String doc;
  final String valor;
  final bool checked;
  Lancamento({
    required this.data,
    required this.lancamento,
    required this.doc,
    required this.valor,
    required this.checked,
  });

  Lancamento copyWith({
    String? data,
    String? lancamento,
    String? doc,
    String? valor,
    bool? checked,
  }) {
    return Lancamento(
      data: data ?? this.data,
      lancamento: lancamento ?? this.lancamento,
      doc: doc ?? this.doc,
      valor: valor ?? this.valor,
      checked: checked ?? this.checked,
    );
  }
}
