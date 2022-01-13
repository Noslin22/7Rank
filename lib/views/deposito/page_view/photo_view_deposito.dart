import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:remessa/views/deposito/page_view/action_bar.dart';

import '../common_deposito.dart';

class PhotoViewDespesa extends StatelessWidget {
  const PhotoViewDespesa({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Uint8List data;

  @override
  Widget build(BuildContext context) {
    final PhotoViewController controller = PhotoViewController();
    int turn = 0;

    return Column(
      children: [
        Expanded(
          child: PhotoView(
            imageProvider: MemoryImage(data),
            controller: controller,
            backgroundDecoration: BoxDecoration(color: Colors.white),
          ),
        ),
        PreferredSize(
          child: ActionBar(
            controller: controller,
            turn: turn,
          ),
          preferredSize: Size(double.infinity, 50),
        ),
      ],
    );
  }
}
