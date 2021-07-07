import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:remessa/models/widgets/consts.dart';

class IgrejaFB {
  bool? marcado = false;
  String? distrito;
  String? nome;
  Timestamp? data;
  String? id;
  int? faltam;

  IgrejaFB();

  IgrejaFB.toCheckBoxModel(DocumentSnapshot documentSnapshot) {
    this.nome = documentSnapshot["nome"];
    this.marcado = documentSnapshot["marcado"];
    this.data = documentSnapshot["data"] != null
        ? Timestamp.fromDate(currentDate(date: documentSnapshot["data"]))
        : null;
    this.distrito = documentSnapshot["distrito"];
    this.id = documentSnapshot.id;
  }

  IgrejaFB.save(String campo, IgrejaFB item, {String? dataPronta}) {
    db.collection("igrejas").doc(item.id).update({
      "marcado": campo == "data" ? true : item.marcado,
      "data": campo == "data"
          ? DateFormat("dd/MM/yyyy").format(item.data!.toDate())
          : item.marcado!
              ? currentDate(dataAtual: true)
              : null,
    });
    db.collection('distritos').doc(item.distrito).get().then((value) {
      Timestamp? dataDb = value.get("data");
      if (dataDb == null ||
          item.data == null ||
          dataDb.toDate().isBefore(item.data!.toDate())) {
        db.collection('distritos').doc(item.distrito).update({
          "data": campo == "data"
              ? item.data
              : item.marcado!
                  ? Timestamp.fromDate(
                      DateTime.parse(
                        DateFormat("yyyy-MM-dd").format(DateTime.now()),
                      ),
                    )
                  : null,
        });
      }
    });
  }
}
