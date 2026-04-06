import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../CommonWidgets/deleteDialog.dart';
import '../Image/zoom.dart';

class ImagenPicker extends StatefulWidget {
  final List<File>? images;
  const ImagenPicker({super.key, this.images});

  @override
  _ImagenPickerState createState() => _ImagenPickerState();
}

class _ImagenPickerState extends State<ImagenPicker> {
  late List<File> images;
  final picker = ImagePicker();

  @override
  void initState() {
    images = widget.images ?? [];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Imagen'),
            leading: IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => {Navigator.pop(context, images)})),
        body: listPreviewImages(images),
        persistentFooterButtons: [
          FloatingActionButton.extended(
              heroTag: null,
              icon: const Icon(Icons.photo_album),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () => {pickImage(ImageSource.gallery)},
              label: const Text("Galeria")),
          FloatingActionButton.extended(
              heroTag: null,
              icon: const Icon(Icons.add_a_photo),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () => {pickImage(ImageSource.camera)},
              label: const Text("Tomar Foto")),
        ]);
  }

  void pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source, imageQuality: 40);
    if (image == null) return;
    setState(() {
      images.add(File(image.path));
    });
  }

  Widget listPreviewImages(List<File> imgs) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: imgs.length,
        itemBuilder: (BuildContext context, int i) {
          return Padding(
              padding: const EdgeInsets.all(5),
              child: Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    setState(() {
                      imgs.removeAt(i);
                    });
                  },
                  confirmDismiss: (direction) async {
                    final bool delete = await showDialog(
                            context: context, builder: (_) => const DeleteDialog()) ??
                        false;
                    return delete;
                  },
                  background: Container(
                    color: Colors.blue,
                    padding: const EdgeInsets.only(left: 16),
                    child: const Align(
                      child: Icon(Icons.delete, color: Colors.white),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ZoomImage(imgs[i])),
                            );
                          },
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                imgs[i],
                                fit: BoxFit.cover,
                              )),
                        )
                      ]))));
        });
  }
}
