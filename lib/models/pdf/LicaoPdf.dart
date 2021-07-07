import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:remessa/models/widgets/consts.dart';

final baseColor = PdfColors.blue;
final List<String> headers = ['Ord.', 'Distrito', 'Cod.', 'Igreja', 'Ass.'];

Future<Uint8List> generateLicaoPdf(PdfPageFormat format, String? title) async {
  final pdf = Document();
  final baseColor = PdfColors.blue;
  const _darkColor = PdfColors.blueGrey800;
  PdfColor _baseTextColor = PdfColors.white;
  ByteData image = await rootBundle.load("assets/Ess_logo.png");
  List<List<String?>> igrejas = [];
  await db.collection('igrejas').orderBy('distrito').orderBy("nome").get().then(
    (value) {
      String? distrito = "Alagoinhas";
      int ord = 1;
      for (var element in value.docs) {
        if (distrito != element["distrito"]) {
          distrito = element["distrito"];
          ord = 1;
        }
        if (ord == 1 && distrito != "Alagoinhas") {
          igrejas.add(["", "", "", "", ""]);
        }
        igrejas.add([
          ord.toString(),
          element["distrito"],
          element["cod"],
          element["nome"],
          ""
        ]);
        ord++;
      }
    },
  );

  pdf.addPage(
    MultiPage(
      pageFormat: format,
      footer: (Context context) {
        return Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
          child: Text(
            'Página ${context.pageNumber}/${context.pagesCount}',
            style: Theme.of(context).defaultTextStyle.copyWith(
                  color: PdfColors.grey,
                ),
          ),
        );
      },
      build: (context) {
        return [
          Container(
            width: format.availableWidth,
            height: format.availableHeight - 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Center(
                  child: Text(
                    title!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ),
                Image(
                  ImageProxy(
                    PdfImage.file(
                      pdf.document,
                      bytes: image.buffer.asUint8List(),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Lição Escola Sabatina",
                    style: TextStyle(
                      fontSize: 26,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Table.fromTextArray(
            border: null,
            cellAlignments: {
              0: Alignment.centerLeft,
              1: Alignment.centerLeft,
              2: Alignment.center,
              3: Alignment.centerLeft,
              4: Alignment.centerRight,
            },
            headerDecoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(2)),
              color: baseColor,
            ),
            headerHeight: 16,
            cellHeight: 11,
            cellPadding: EdgeInsets.all(1),
            oddRowDecoration: BoxDecoration(color: PdfColors.grey400),
            headerAlignments: {
              0: Alignment.centerLeft,
              1: Alignment.centerLeft,
              2: Alignment.center,
              3: Alignment.centerLeft,
              4: Alignment.centerRight,
            },
            headerStyle: TextStyle(
              color: _baseTextColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            cellStyle: const TextStyle(
              color: _darkColor,
              fontSize: 10,
            ),
            rowDecoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: PdfColors.blueGrey900,
                  width: .5,
                ),
              ),
            ),
            headers: headers,
            data: igrejas,
          ),
        ];
      },
    ),
  );

  return pdf.save();
}
