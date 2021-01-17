import 'package:flutter/material.dart';
import 'package:remessa/models/widgets/BottomNavigator.dart';
import 'package:remessa/models/widgets/Loading.dart';
import 'package:remessa/views/Tabs/Autenticate/Login/LoginAdm.dart';
import 'package:remessa/views/Tabs/Autenticate/Login/LoginGerenciador.dart';
import 'package:remessa/views/Tabs/Autenticate/Login/LoginPastor.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int tabIndex = 0;
  List<Widget> listScreens;
  @override
  void initState() {
    super.initState();
    listScreens = [
      LoginPastor(carregar),
      LoginGerenciador(carregar),
      LoginAdm(carregar),
    ];
  }

  void setIndex(value) {
    setState(() {
      tabIndex = value;
    });
  }

  void carregar(value) {
    setState(() {
      carregando = value;
    });
  }

  bool carregando = false;

  @override
  Widget build(BuildContext context) {
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
