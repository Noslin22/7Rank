import 'package:flutter/material.dart';
import 'package:remessa/models/Auth.dart';
import 'package:remessa/models/pages/sign/SignModel.dart';
import 'package:remessa/models/pages/sign/SignPage.dart';
import 'package:remessa/models/widgets/BottomNavigator.dart';
import 'package:remessa/models/widgets/Loading.dart';
import 'package:remessa/models/widgets/consts.dart';
import 'package:provider/provider.dart';

class Registro extends StatefulWidget {
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
    double width = MediaQuery.of(context).size.width;
    bool mobile = width <= 750;
    Auth _auth = context.read<Auth>();
    final Map<int, String> types = {
      0: 'pastor',
      1: 'gerenciador',
      2: 'adm',
    };

    listScreens = List.generate(
      3,
      (index) => SignPage(
        model: SignModel(
          register: true,
          carregar: carregar,
          type: types[index]!,
          code: _auth.error,
        ),
      ),
    );
    return carregando
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("Resgistro"),
              centerTitle: true,
              actions: mobile
                  ? null
                  : actions('gerenciador', context, 'registrar'),
            ),
            drawer: mobile
                ? drawer('gerenciador', context, 'registrar')
                : null,
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
