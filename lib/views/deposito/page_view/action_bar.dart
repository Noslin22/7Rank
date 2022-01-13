import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';


import 'dart:math' as math;
import '../common_deposito.dart';

class ActionBar extends StatelessWidget {
  ActionBar({
    Key? key,
    required this.controller,
    required this.turn,
  }) : super(key: key);
  final PhotoViewController controller;
  int turn;

  @override
  Widget build(BuildContext context) {
    return Row(
            children: [
              IconButton(
                icon: Icon(Icons.keyboard_arrow_left),
                onPressed: () {
                  if (page > 0) {
                    pageController.jumpToPage(page - 1);
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.rotate_left),
                onPressed: () {
                  turn = turn == 0 ? 3 : turn - 1;
                  controller.rotation = math.pi / 2 * turn;
                },
              ),
              IconButton(
                icon: Icon(Icons.zoom_out),
                onPressed: () {
                  if (controller.scale! >= 0.5) {
                    double scale = controller.scale!;
                    scale -= 0.5;
                    controller.scale = scale;
                  }
                },
              ),
              Text("${page + 1}/${data.length}"),
              IconButton(
                icon: Icon(Icons.zoom_in),
                onPressed: () {
                    double scale = controller.scale!;
                    scale += 0.5;
                    controller.scale = scale;
                },
              ),
              IconButton(
                icon: Icon(Icons.rotate_right),
                onPressed: () {
                  turn = turn == 3 ? 0 : turn + 1;
                  controller.rotation = math.pi / 2 * turn;
                },
              ),
              IconButton(
                icon: Icon(Icons.keyboard_arrow_right),
                onPressed: () {
                  if (page < data.length) {
                    pageController.jumpToPage(page + 1);
                  }
                },
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          );
  }
}
