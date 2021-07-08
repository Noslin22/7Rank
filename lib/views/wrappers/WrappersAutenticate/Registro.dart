import 'package:flutter/material.dart';
import 'package:remessa/models/pages/SignModel.dart';
import 'package:remessa/models/Auth.dart';
import 'package:remessa/models/pages/SignPage.dart';
import 'package:remessa/models/widgets/BottomNavigator.dart';
import 'package:remessa/models/widgets/Loading.dart';
import 'package:remessa/models/widgets/consts.dart';
import 'package:provider/provider.dart';

class Registro extends StatefulWidget {
  final String gerenciador;
  const Registro(this.gerenciador);
  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  late List<Widget> listScreens;
  int tabIndex = 0;

  void carregar(value) {
    setState(() {
      carregando = value;
    });
  }

  void setIndex(value) {
    setState(() {
      tabIndex = value;
    });
  }

  bool carregando = false;

  @override
  Widget build(BuildContext context) {
    Auth _auth = context.read<Auth>();
    double width = MediaQuery.of(context).size.width;
    print(width);
    final Map<int, String> types = {
      0: 'pastor',
      1: 'gerenciador',
      2: 'adm',
    };

    listScreens = List.generate(
      3,
      (index) => SignPage(
        model: SignModel(
          register: false,
          carregar: carregar,
          type: types[index]!,
          code: _auth.error != null ? _auth.error!.code : null,
        ),
      ),
    );
    return carregando
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("Resgistro"),
              centerTitle: true,
              actions: width <= 750
                  ? null
                  : actions(widget.gerenciador, context, 'registrar'),
            ),
            drawer: width >= 750
                ? null
                : drawer(widget.gerenciador, context, 'registrar'),
            body: SingleChildScrollView(
              child: listScreens[tabIndex],
            ),
            bottomNavigationBar: BottomNavigator(
              tabIndex,
              setIndex,
              ['Pastor', 'Gerenciador', 'Adm'],
              [Icons.person, Icons.account_box, Icons.supervisor_account],
            ),
          );
  }
}
