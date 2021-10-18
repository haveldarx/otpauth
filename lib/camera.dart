import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class Camera extends StatefulWidget {
  const Camera({Key? key}) : super(key: key);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late String url;
  bool isUploading = true;
  var ppId;
  String? profileUrl;
  final picker = ImagePicker();
  
  final imagePicker = ImagePicker();
  XFile? file;
  File? upfile;

  Future<String> uploadImageToFirebase(imageFile) async {
    String url = "";
    FirebaseStorage storage = FirebaseStorage.instance;
     ppId = Uuid().v4();
    Reference ref = storage.ref().child("images/$ppId");
    UploadTask uploadTask = ref.putFile(upfile!);
    await uploadTask.whenComplete(() async {
      url = await ref.getDownloadURL();
    });
    print('this is             $url');
    return url;
  }

  uploadImage(userId) async { 
    setState(() {
      isUploading = true;
    });
    String imageUrl = await uploadImageToFirebase(file);
    setState(() {
     
      isUploading = false;
      profileUrl = imageUrl;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Image Uploaded!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(children: <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(50.0, 0.0, 0.0, 0.0),
        child: FloatingActionButton(
          onPressed: () async{
            
              file = await imagePicker.pickImage(source: ImageSource.camera);
              setState(() {
                upfile = File(file!.path);
              });

              print('this issssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss $file');

              
          
          },
          child: Icon(Icons.camera_outlined), //camera image
          backgroundColor: Colors.pinkAccent,
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(50.0, 0.0, 0.0, 0.0),
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add_photo_alternate_outlined), //gallery image
          backgroundColor: Colors.pinkAccent,
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(50.0, 0.0, 0.0, 0.0),
        child: FloatingActionButton(
            child: Icon(Icons.upload_file),
            backgroundColor: Colors.pinkAccent,
            onPressed: () {
              setState(() {
                
                uploadImage(_auth.currentUser!.uid);
              });
            }),
      ),
    ])
    );
  }
}
