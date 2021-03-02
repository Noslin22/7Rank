import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:remessa/models/widgets/consts.dart';
import '../models/pdf/LicaoPdf.dart';

class LicaoPreview extends StatefulWidget {
  @override
  LicaoPreviewState createState() {
    return LicaoPreviewState();
  }
}

class LicaoPreviewState extends State<LicaoPreview>
    with SingleTickerProviderStateMixin {
  List<Igreja> igrejas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lições da Escola Sabatina'),
      ),
      body: PdfPreview(
          build: (format) => generatePdf(format, 'LICAO'),
        ),
      // Container(
      //   child: Column(
      //     children: [
      //       RaisedButton(
      //           child: Text('Imprimir'),
      //           onPressed: () {
      //             Printing.layoutPdf(
      //               name: 'LICAO',
      //               onLayout: (PdfPageFormat format) {
      //                 return buildPdf(format);
      //               },
      //             );
      //           }),
      //       RaisedButton(
      //           child: Text('Salvar'),
      //           onPressed: () {
      //             PdfPageFormat format;
      //             Printing.sharePdf(
      //               bytes: buildPdf(format),
      //               filename: 'LICAO.pdf',
      //             );
      //           }),
      //     ],
      //   ),
      // ),
    );
  }
}
