import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:remessa/models/widgets/BottomNavigator.dart';
import 'package:remessa/models/widgets/Loading.dart';
import 'package:remessa/models/widgets/consts.dart';
import 'package:remessa/views/Tabs/Autenticate/Registro/RegistroAdm.dart';
import 'package:remessa/views/Tabs/Autenticate/Registro/RegistroGerenciador.dart';
import 'package:remessa/views/Tabs/Autenticate/Registro/RegistroPastor.dart';
import 'package:remessa/views/wrappers/Adicionar.dart';
import '../../CoelbaEmbasa.dart';
import '../../Home.dart';

class Registro extends StatefulWidget {
  final String gerenciador;
  const Registro(this.gerenciador);
  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  int tabIndex = 0;
  List<Widget> listScreens;
  @override
  void initState() {
    super.initState();
    listScreens = [
      RegistroPastor(carregar),
      RegistroGerenciador(carregar),
      RegistroAdm(carregar),
    ];
  }

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
    return carregando
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("Resgistro"),
              centerTitle: true,
              actions: kIsWeb ? actions(widget.gerenciador, context, 'registrar') : [],
            ),
            drawer: kIsWeb ? null : drawer(widget.gerenciador, context, 'registrar'),
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
