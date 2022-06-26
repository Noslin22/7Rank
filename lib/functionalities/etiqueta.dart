import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:remessa/models/pdf/EtiquetaPdf.dart';
import 'package:remessa/models/widgets/Button.dart';
import 'package:remessa/models/widgets/consts.dart';

class Etiqueta extends StatefulWidget {
  Etiqueta({Key? key}) : super(key: key);

  @override
  State<Etiqueta> createState() => _EtiquetaState();
}

class _EtiquetaState extends State<Etiqueta> {
  List<DropdownMenuItem<String>> distritos = [];

  String? distritoEtiqueta;

  @override
  void initState() {
    db.collection("distritos").get().then((value) {
      value.docs.forEach((element) {
        distritos.add(
          DropdownMenuItem(
            child: Text(element.id),
            value: element.id,
          ),
        );
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Etiqueta Distrito',
      child: IconButton(
          icon: Icon(Icons.local_offer),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    "Escolha um distrito",
                    textAlign: TextAlign.center,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        onChanged: (String? value) {
                          distritoEtiqueta = value;
                        },
                        onSaved: (String? value) {
                          distritoEtiqueta = value;
                        },
                        hint: Text("Distritos"),
                        items: distritos,
                        value: distritoEtiqueta,
                      ),
                    ],
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Button(
                            color: Colors.lightGreen,
                            label: "Gerar",
                            onPressed: () {
                              Printing.layoutPdf(
                                onLayout: (format) {
                                  return buildEtiquetaDistrito(
                                    distritoEtiqueta!,
                                    currentDate(dataAtual: true).split("/")[2],
                                  );
                                },
                              );
                              Navigator.of(context).pop();
                              distritoEtiqueta = "";
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
                            label: "Cancelar",
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
          }),
    );
  }
}
