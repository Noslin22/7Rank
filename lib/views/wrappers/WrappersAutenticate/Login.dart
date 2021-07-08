import 'package:flutter/material.dart';
import 'package:remessa/models/Auth.dart';
import 'package:remessa/models/pages/SignModel.dart';
import 'package:remessa/models/pages/SignPage.dart';
import 'package:remessa/models/widgets/BottomNavigator.dart';
import 'package:remessa/models/widgets/Loading.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late List<Widget> listScreens;
  int tabIndex = 0;

  void setIndex(value) {
    setState(() {
      tabIndex = value;
    });
  }

  void carregar(bool value) {
    setState(() {
      carregando = value;
    });
  }

  bool carregando = false;

  @override
  Widget build(BuildContext context) {
    Auth _auth = context.read<Auth>();
    final Map<int, String> types = {
      0: 'pastor',
      1: 'gerenciador',
      2: 'adm',
    };

    listScreens = List.generate(
      3,
      (index) {
        return SignPage(
          model: SignModel(
            register: false,
            carregar: carregar,
            type: types[index]!,
            code: _auth.error != null ? _auth.error!.code : null,
          ),
        );
      },
    );

    return carregando
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("7Rank"),
              centerTitle: true,
            ),
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
