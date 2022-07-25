import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

void initializeControllers() {
  controllerCod = TextEditingController();
  controllerDate = TextEditingController();
  controllerDc = TextEditingController();
  controllerRM = TextEditingController();
  controllerVl = MoneyMaskedTextController(
    decimalSeparator: ",",
    thousandSeparator: ".",
    precision: 2,
    leftSymbol: "R\$ ",
  );
  scrollController = ScrollController();
}

final formatDate = new MaskTextInputFormatter(
  mask: '##/##/####',
  filter: {"#": RegExp(r'[0-9]')},
);

final formatRm = new MaskTextInputFormatter(
  mask: '##/####',
  filter: {"#": RegExp(r'[0-9]')},
);

TextEditingController controllerDate = TextEditingController();
TextEditingController controllerCod = TextEditingController();
TextEditingController controllerRM = TextEditingController();
TextEditingController controllerDc = TextEditingController();
TextEditingController controllerVl = MoneyMaskedTextController(
  decimalSeparator: ",",
  thousandSeparator: ".",
  precision: 2,
  leftSymbol: "R\$ ",
);

final PageController pageController = PageController();
ScrollController scrollController = ScrollController();

String? title = "Código da Igreja";

final Map<String, String> igrejas = {};
List<String> depositos = [];

List<Uint8List> data = [];
List<String> amostra = [];
List<String> contas = ["123", "132", "213", "231", "312", "Recibo Caixa"];

FocusNode? myFocusNode;
String conta = "";

String cod = "";
int focus = 0;
int page = 0;
