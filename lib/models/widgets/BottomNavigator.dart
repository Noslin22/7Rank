import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BottomNavigator extends StatelessWidget {
  final int index;
  final Function setIndex;
  List<String> names = ['Pastor', 'Gerenciador', 'Adm'];
  List<IconData> icons = [Icons.person, Icons.account_box, Icons.supervisor_account];
  BottomNavigator(this.index, this.setIndex, this.names, this.icons);
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey[400],
      currentIndex: index,
      onTap: (index) {
        setIndex(index);
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            icons[0],
          ),
          label: names[0],
        ),
        BottomNavigationBarItem(
          icon: Icon(
            icons[1],
          ),
          label: names[1],
        ),
        BottomNavigationBarItem(
          icon: Icon(
            icons[2],
          ),
          label: names[2],
        ),
      ],
    );
  }
}
