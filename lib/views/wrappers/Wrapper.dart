import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remessa/models/User.dart';
import 'package:remessa/views/Home.dart';
import '../Home.dart';
import 'WrappersAutenticate/Login.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Uid>(context);
    if (user == null) {
      return Login();
    } else {
      return Home();
    }
  }
}
