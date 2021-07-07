import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class IgrejaPdf {
  const IgrejaPdf(
    this.nome,
    this.data,
  );

  final String nome;
  final String data;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return nome;
      case 1:
        return data;
    }
    return '';
  }
}

Future<Uint8List> buildPdfDistrito(
    {List<List<String?>>? protocolos,
    List<IgrejaPdf>? igrejas,
    String? data,
    bool protocolo = false,
    String? distrito}) async {
  final Document doc = Document();
  final baseColor = PdfColors.blue;
  const _darkColor = PdfColors.blueGrey800;

  PdfColor _baseTextColor = PdfColors.white;
  final List<String> headers =
      protocolo ? ['Código', 'Igreja', 'Valor'] : ['Igreja', 'Data'];

  PdfPageFormat? format;
  doc.addPage(
    MultiPage(
      pageFormat: format,
      build: (Context context) {
        return [
          ListView(
            children: [
              Container(
                child: Column(children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          protocolo ? "Protocolo Caixa" : "Distrito: $distrito",
                          style:
                              TextStyle(color: PdfColors.black, fontSize: 14),
                        ),
                        !protocolo
                            ? Text(
                                data!,
                                style: TextStyle(
                                    color: PdfColors.black, fontSize: 14),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Table.fromTextArray(
                      border: null,
                      cellAlignment: Alignment.centerLeft,
                      headerDecoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(2)),
                        color: baseColor,
                      ),
                      headerHeight: 20,
                      cellHeight: 11,
                      cellPadding: EdgeInsets.all(2),
                      oddRowDecoration: BoxDecoration(color: PdfColors.grey400),
                      headerAlignments: protocolo
                          ? {
                              0: Alignment.centerLeft,
                              1: Alignment.centerLeft,
                              2: Alignment.centerRight,
                            }
                          : {
                              0: Alignment.centerLeft,
                              1: Alignment.centerRight,
                            },
                      cellAlignments: protocolo
                          ? {
                              0: Alignment.centerLeft,
                              1: Alignment.centerLeft,
                              2: Alignment.centerRight,
                            }
                          : {
                              0: Alignment.centerLeft,
                              1: Alignment.centerRight,
                            },
                      headerStyle: TextStyle(
                        color: _baseTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      cellStyle: const TextStyle(
                        color: _darkColor,
                        fontSize: 14,
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
                      data: protocolo
                          ? protocolos!
                          : List<List<String>>.generate(
                              igrejas!.length,
                              (row) => List<String>.generate(
                                headers.length,
                                (col) => igrejas[row].getIndex(col),
                              ),
                            ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ];
      },
    ),
  );
  return await doc.save();
}
