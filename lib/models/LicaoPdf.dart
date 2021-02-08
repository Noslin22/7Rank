import 'dart:math';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:remessa/models/widgets/consts.dart';

final baseColor = PdfColors.blue;
final List<String> headers = ['Ord.', 'Distrito', 'Cod.', 'Igreja', 'Ass.'];

class Igreja {
  const Igreja(this.nome, this.cod, this.distrito, this.ordem, this.ass);

  final String ordem;
  final String distrito;
  final String cod;
  final String nome;
  final String ass;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return ordem;
      case 1:
        return distrito;
      case 2:
        return cod;
      case 3:
        return nome;
      case 4:
        return ass;
    }
    return '';
  }
}

Future<Uint8List> generatePdf(PdfPageFormat format, String title) async {
  final pdf = pw.Document();
  List<Igreja> igrejas = [];
  db.collection('igrejas').orderBy('nome').get().then(
    (value) {
      value.docs.forEach(
        (element) {
          igrejas.add(
            Igreja(
                element['nome'],
                Random().nextInt(520).toString(),
                element['distrito'],
                Random().nextInt(520).toString(),
                '__________________'),
          );
          print(igrejas);
        },
      );
    },
  );

  List<List<String>> list = [];
  for (int i = 0; i < 10; i++) {
    list.add(['Ordem $i', 'Distrito $i', 'Cod $i', 'Nome $i', '_____________________']);
  }

  pdf.addPage(
    pw.MultiPage(
      pageFormat: format,
      footer: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text('Página ${context.pageNumber}/${context.pagesCount}',
                style: pw.Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      build: (context) {
        return [
          pw.ListView.builder(
              itemBuilder: (context, index) {
                return pw.Row(children: [
                  pw.Text(list[index][0]),
                  pw.Text(list[index][1]),
                  pw.Text(list[index][2]),
                  pw.Text(list[index][3]),
                  pw.Text(list[index][4]),
                ], mainAxisAlignment: pw.MainAxisAlignment.spaceAround);
              },
              itemCount: list.length)
        ];
      },
    ),
  );

  return pdf.save();
}
