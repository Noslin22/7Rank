import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

organizeFile(PlatformFile file) {
  List<Conciliacao> csv = [];
  String csvData = File.fromRawPath(file.bytes!).path;
  List<String> datas =
      csvData.replaceAll('\r\n', '\r').replaceAll('\n', '\r').split("\r");
  datas.removeAt(0);
  String conta = datas.first.split(' ')[6].split('-')[0];
  datas.removeRange(0, 2);
  datas.removeWhere((element) =>
      element == ' ' ||
      element == '' ||
      element.isEmpty ||
      element == '\r' ||
      element.split(";")[0] == "Total" ||
      element.split(";")[0] == "Data" ||
      element.split(" ")[0].split(';')[1] == "�ltimos" ||
      element.split(" ")[0] == ";Saldos" ||
      element.split(';')[1].split(' ')[0] == 'SALDO');
  for (var element in datas) {
    List<String?> list = element.split(";");
    csv.add(
      Conciliacao(
        conta,
        list[0]!,
        removerAcentos(list[1]!),
        list[2]!,
        list[3] != ""
            ? list[3] != null
                ? list[3]!.replaceAll(".", "").replaceAll(",", "")
                : list[4]!.replaceAll(".", "").replaceAll(",", "")
            : list[4]!.replaceAll(".", "").replaceAll(",", ""),
      ),
    );
  }
  String jsonCsvEncoded = jsonEncode(csv);
  return jsonDecode(jsonCsvEncoded);
}

String removerAcentos(String texto) {
  String comAcentos = "ÁÂÀÃáâàãÉÊéêÍÎíîÓÔÕóôõÚÛúûÇç";
  String semAcentos = "AAAAaaaaEEeeIIiiOOOoooUUuuCc";

  for (int i = 0; i < comAcentos.length; i++) {
    texto =
        texto.replaceAll(comAcentos[i].toString(), semAcentos[i].toString());
  }
  return texto;
}

class Conciliacao {
  final String conta;
  final String data;
  final String lancamento;
  final String documento;
  final String valor;

  Conciliacao(
    this.conta,
    this.data,
    this.lancamento,
    this.documento,
    this.valor,
  );

  Map toJson() => {
        'conta': conta,
        'data': data,
        'lancamento': lancamento,
        'doc': documento,
        'valor': valor,
      };
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