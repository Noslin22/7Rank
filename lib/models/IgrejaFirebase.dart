import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remessa/models/widgets/consts.dart';

class IgrejaFB {
  bool marcado = false;
  String distrito;
  String nome;
  String data;
  String id;
  int faltam;

  IgrejaFB();

  IgrejaFB.toCheckBoxModel(DocumentSnapshot documentSnapshot) {
    this.nome = documentSnapshot["nome"];
    this.marcado = documentSnapshot["marcado"];
    this.data = documentSnapshot["data"];
    this.distrito = documentSnapshot["distrito"];
    this.id = documentSnapshot.id;
  }

  IgrejaFB.save(String campo, IgrejaFB item, {String dataPronta}) {
    db.collection("igrejas").doc(item.id).update({
      "marcado": campo == "data" ? true : item.marcado,
      "data": campo == "data"
          ? item.data
          : item.marcado
              ? currentDate(dataAtual: true)
              : null,
    });
    db.collection('distritos').doc(item.distrito).get().then((value) {
      String dataDb = value.data()['data'];
      if (dataDb == null ||
          item.data == null ||
          int.parse(dataDb.split('/')[0]) <
              int.parse(item.data.split('/')[0])) {
        db.collection('distritos').doc(item.distrito).update({
          "data": campo == "data"
              ? item.data
              : item.marcado
                  ? currentDate(dataAtual: true)
                  : null,
        });
      }
    });
  }
}
