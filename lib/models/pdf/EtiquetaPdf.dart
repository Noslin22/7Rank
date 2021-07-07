import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

Future<Uint8List> buildPdfEtiqueta(String? distrito, String? year) async {
  final Document doc = Document();

  ByteData image = await rootBundle.load("assets/Iasd.png");
  PdfPageFormat? format;
  doc.addPage(
    MultiPage(
      pageFormat: format,
      build: (Context context) {
        return _buildSheet(distrito, doc, year, format, image);
      },
    ),
  );
  return await doc.save();
}

List<Widget> _buildSheet(String? distrito, Document doc, String? ano,
    PdfPageFormat? format, ByteData image) {
  List<Widget> widgets = [];
  for (var i = 0; i < 6; i++) {
    widgets.add(
      Expanded(
        child: Container(
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
              Text(
                "Distrito:",
                style: TextStyle(fontSize: 42),
              ),
              Text(
                distrito!,
                style: TextStyle(fontSize: 48),
                textAlign: TextAlign.center,
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
                "${(i * 2 + 1).toString().length == 1 ? "0${i * 2 + 1}" : i * 2 + 1}/${(i * 2 + 2).toString().length == 1 ? "0${i * 2 + 2}" : i * 2 + 2}-$ano",
                style: TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  return widgets;
}
