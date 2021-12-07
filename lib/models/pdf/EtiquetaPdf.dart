import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

Future<Uint8List> buildPdfEtiqueta(String distrito, String? year) async {
  final Document doc = Document();

  ByteData image = await rootBundle.load("assets/Iasd.png");
  PdfPageFormat format = PdfPageFormat.a4;
  List<String> numbers = [
    "01/02-$year",
    "03/04-$year",
    "05/06-$year",
    "07/08-$year",
    "09/10-$year",
    "11/12-$year",
  ];
  for (int i = 0; i < 6; i++) {
    doc.addPage(
      Page(
        pageFormat: format,
        build: (Context context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.fromBorderSide(
                BorderSide(
                  color: PdfColors.black,
                ),
              ),
            ),
            child: Column(
              children: [
                Image(
                  ImageProxy(
                    PdfImage.file(
                      doc.document,
                      bytes: image.buffer.asUint8List(),
                    ),
                  ),
                  height: 200,
                  width: 200,
                ),
                Text(
                  "Associação Bahia\nCentral",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                  ),
                ),
                Divider(
                  height: 40,
                  indent: 10,
                  endIndent: 10,
                  borderStyle: BorderStyle.dotted,
                ),
                Text("Distrito:", style: TextStyle(fontSize: 42)),
                Text(
                  distrito,
                  style: TextStyle(fontSize: 48),
                ),
                Divider(
                  height: 60,
                  indent: 10,
                  endIndent: 10,
                  borderStyle: BorderStyle.dotted,
                ),
                Text(
                  "Arquivo de Remessa:",
                  style: TextStyle(fontSize: 48),
                ),
                Text(
                  numbers[i],
                  style: TextStyle(
                    fontSize: 54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  return await doc.save();
}
