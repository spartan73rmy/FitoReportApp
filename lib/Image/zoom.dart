import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ZoomImage extends StatefulWidget {
  final File image;
  ZoomImage(this.image, {Key key}) : super(key: key);

  @override
  _ZoomImageState createState() => _ZoomImageState();
}

class _ZoomImageState extends State<ZoomImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            leading: InkWell(
              onTap: () {
                //  Navigator.pop(context);
              },
              child: Icon(Icons.close),
            ),
            title: Text('Zoom Image')),
        body: Container(
          child: PhotoView(
            imageProvider: FileImage(widget.image),
          ),
        ));
  }
}
