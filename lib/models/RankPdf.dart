import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Distrito {
  const Distrito(
    this.nome,
    this.faltam,
    this.data,
  );

  final String nome;
  final String faltam;
  final String data;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return nome;
      case 1:
        return faltam;
      case 2:
        return data;
    }
    return '';
  }
}

Future<Uint8List> buildPdf(PdfPageFormat format, List<Distrito> distritos,
    int total, String date) async {
  final pw.Document doc = pw.Document();
  final baseColor = PdfColors.blue;
  const _darkColor = PdfColors.blueGrey800;

  PdfColor _baseTextColor = PdfColors.white;
  final List<String> headers = ['Distrito', 'Faltam', 'Data'];

  doc.addPage(
    pw.Page(
      pageFormat: format,
      build: (pw.Context context) {
        return pw.Container(
          child: pw.Column(
            children: [
              pw.Container(
                child: pw.Row(
                  children: [
                    pw.Text(
                      'Rank Atualizado $date',
                      style: pw.TextStyle(color: PdfColors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Table.fromTextArray(
                  border: null,
                  cellAlignment: pw.Alignment.centerLeft,
                  headerDecoration: pw.BoxDecoration(
                    borderRadius:
                        const pw.BorderRadius.all(pw.Radius.circular(2)),
                    color: baseColor,
                  ),
                  headerHeight: 25,
                  cellHeight: 11,
                  cellPadding: pw.EdgeInsets.all(2),
                  oddRowDecoration: pw.BoxDecoration(color: PdfColors.grey400),
                  cellAlignments: {
                    0: pw.Alignment.centerLeft,
                    1: pw.Alignment.center,
                    2: pw.Alignment.centerRight,
                  },
                  headerStyle: pw.TextStyle(
                    color: _baseTextColor,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  cellStyle: const pw.TextStyle(
                    color: _darkColor,
                    fontSize: 10,
                  ),
                  rowDecoration: pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        color: PdfColors.blueGrey900,
                        width: .5,
                      ),
                    ),
                  ),
                  headers: headers,
                  data: List<List<String>>.generate(
                    distritos.length,
                    (row) => List<String>.generate(
                      headers.length,
                      (col) => distritos[row].getIndex(col),
                    ),
                  ),
                ),
              ),
              pw.Container(
                height: 40,
                child: pw.Center(
                  child: pw.Text(
                    "Total:   $total",
                    style: pw.TextStyle(fontSize: 20, color: PdfColors.white),
                  ),
                ),
                color: PdfColors.blue,
              )
            ],
          ),
        );
      },
    ),
  );
  return await doc.save();
}
