import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

String _format(double dou) {
  return NumberFormat.currency(locale: 'pt_BR', decimalDigits: 2, name: "R\$")
      .format(dou);
}

Future<Uint8List> buildPdfMalote(List<String> datas) async {
  final Document doc = Document();

  PdfPageFormat format;
  doc.addPage(
    Page(
      pageFormat: format,
      build: (Context context) {
        return Container(
          child: Center(
            child: Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Código: ${datas[0]}"),
                      Text(datas[1]),
                      Text("Remessa: ${datas[2]}")
                    ],
                  ),
                  SizedBox(height: 45),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text("Cédulas"),
                              SizedBox(height: 10),
                              Container(
                                child: Text(
                                  "200,00 x ${datas[3]} = ${_format(int.parse(datas[3]) * 200.00)}",
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                child: Text(
                                  "100,00 x ${datas[4]} = ${_format(int.parse(datas[4]) * 100.00)}",
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                child: Text(
                                  "50,00 x ${datas[5]} = ${_format(int.parse(datas[5]) * 50.00)}",
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                child: Text(
                                  "20,00 x ${datas[6]} = ${_format(int.parse(datas[6]) * 20.00)}",
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                child: Text(
                                  "10,00 x ${datas[7]} = ${_format(int.parse(datas[7]) * 10.00)}",
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                child: Text(
                                  "5,00 x ${datas[8]} = ${_format(int.parse(datas[8]) * 5.00)}",
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                child: Text(
                                  "2,00 x ${datas[9]} = ${_format(int.parse(datas[9]) * 2.00)}",
                                ),
                              ),
                            ],
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text("Moedas"),
                              SizedBox(height: 10),
                              Container(
                                child: Text(
                                  "1,00 x ${datas[10]} = ${_format(int.parse(datas[10]) * 1.00)}",
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                child: Text(
                                  "0,50 x ${datas[11]} = ${_format(int.parse(datas[11]) * 0.50)}",
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                child: Text(
                                  "0,25 x ${datas[12]} = ${_format(int.parse(datas[12]) * 0.25)}",
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                child: Text(
                                  "0,10 x ${datas[13]} = ${_format(int.parse(datas[13]) * 0.10)}",
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                child: Text(
                                  "0,05 x ${datas[14]} = ${_format(int.parse(datas[14]) * 0.05)}",
                                ),
                              ),
                              SizedBox(height: 25),
                              Text(
                                datas[15],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text("Cheques"),
                              SizedBox(height: 10),
                              Container(
                                child: Text(
                                  datas[16],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                child: Text(
                                  datas[17],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                child: Text(
                                  datas[18],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                child: Text(
                                  datas[19],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                child: Text(
                                  datas[20],
                                ),
                              ),
                            ],
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
  return await doc.save();
}
