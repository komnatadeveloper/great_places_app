import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProvider;



class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

// -----------STATE----------
class _ImageInputState extends State<ImageInput> {
  File _storageImage;

  Future<void> _takePicture () async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera, // or ImageSource.gallery
      maxWidth: 600
    );
    if( imageFile == null) {
      return;
    }
    setState(() {
      _storageImage = imageFile;
    });

    final appDir = await pathProvider.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey
            )
          ),
          child: _storageImage != null 
            ? Image.file(
               _storageImage ,
               fit: BoxFit.cover,
               width: double.infinity,
              )
            : Text(
              'No Image Taken',
              textAlign: TextAlign.center,
              ) ,
          alignment: Alignment.center,
        ),
        SizedBox(width: 10,),
        Expanded(
          child: FlatButton.icon(
            icon: Icon(Icons.camera),
            label: Text('Take Picture'),
            textColor: Theme.of(context).primaryColor,
            onPressed: _takePicture
          ),
        )
        
      ],
    );
  }
}