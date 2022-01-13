import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

Future<Uint8List> buildPdfDeposito(List<Uint8List> images) async {
  final Document doc = Document();
  PdfPageFormat format = PdfPageFormat.a4;

  for (int i = 0; i < images.length; i++) {
    doc.addPage(
      Page(
        pageFormat: format,
        build: (Context context) {
          return Column(
            children: [
              Expanded(
                child: Image(
                  MemoryImage(images[i]),
                ),
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.bottomRight,
                child: Text("${i + 1}/${images.length}"),
              ),
            ],
          );
        },
      ),
    );
  }
  return await doc.save();
}
