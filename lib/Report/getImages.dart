import 'dart:io';
import 'package:LikeApp/CommonWidgets/deleteDialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagenPicker extends StatefulWidget {
  final List<File> images;
  ImagenPicker({this.images, Key key}) : super(key: key);

  @override
  _ImagenPickerState createState() => _ImagenPickerState();
}

class _ImagenPickerState extends State<ImagenPicker> {
  List<File> images;
  final picker = ImagePicker();

  @override
  void initState() {
    widget.images != null ? images = widget.images : images = new List<File>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Imagen'),
            leading: IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: () => Navigator.pop(context, images))),
        body: listPreviewImages(images),
        persistentFooterButtons: [
          FloatingActionButton.extended(
              heroTag: null,
              icon: Icon(Icons.photo_album),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () => {pickImage(ImageSource.gallery)},
              label: Text("Galeria")),
          FloatingActionButton.extended(
              heroTag: null,
              icon: Icon(Icons.add_a_photo),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () => {pickImage(ImageSource.camera)},
              label: Text("Tomar Foto"))
        ]);
  }

  Widget _previewImage(image) {
    return FutureBuilder<File>(
        future: image,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return Image.file(
              snapshot.data,
              height: 100,
              width: 110,
              fit: BoxFit.cover,
            );
          } else if (snapshot.error != null) {
            return const Text(
              'Error, seleccionela de nuevo',
              textAlign: TextAlign.center,
            );
          } else {
            return const Text(
              "Selecciona una imagen",
              textAlign: TextAlign.center,
            );
          }
        });
  }

  pickImage(ImageSource source) async {
    PickedFile image = await picker.getImage(source: source, imageQuality: 50);
    if (image == null) return;
    setState(() {
      images.add(File(image.path));
    });
  }

  Widget listPreviewImages(List<File> images) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      // shrinkWrap: true,
      itemCount: images.length,
      itemBuilder: (BuildContext context, int i) {
        return Padding(
          padding: EdgeInsets.all(5),
          child: new Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {
              setState(() {
                images.removeAt(i);
              });
            },
            confirmDismiss: (direction) async {
              final bool delete = await showDialog(
                      context: context, builder: (_) => DeleteDialog()) ??
                  false;
              return delete;
            },
            background: Container(
              color: Colors.blue,
              padding: EdgeInsets.only(left: 16),
              child: Align(
                child: Icon(Icons.delete, color: Colors.white),
                alignment: Alignment.centerLeft,
              ),
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(
                        images[i],
                        //TODO set way to resize
                        // height: 400,
                        // width: 300,
                        fit: BoxFit.cover,
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
