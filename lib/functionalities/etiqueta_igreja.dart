import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:remessa/models/pdf/EtiquetaPdf.dart';
import 'package:remessa/models/widgets/Button.dart';
import 'package:remessa/models/widgets/consts.dart';

class EtiquetaIgreja extends StatefulWidget {
  EtiquetaIgreja({Key? key}) : super(key: key);

  @override
  State<EtiquetaIgreja> createState() => _EtiquetaIgrejaState();
}

class _EtiquetaIgrejaState extends State<EtiquetaIgreja> {
  List<Map<String, String>> igrejas = [];

  @override
  void initState() {
    db.collection("igrejas").get().then((value) {
      value.docs.forEach((element) {
        igrejas.add({
          "nome": element["nome"],
          "cod": element["cod"].toString(),
          "distrito": element["distrito"],
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Etiqueta Igreja',
      child: IconButton(
          icon: Icon(Icons.description),
          onPressed: () {
            Printing.layoutPdf(
              onLayout: (format) {
                return buildEtiquetaIgreja(
                  igrejas: igrejas,
                );
              },
            );
          }),
    );
  }
}
