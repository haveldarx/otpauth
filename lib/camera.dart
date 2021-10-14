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
  bool isUploading = true ;
  var ppId;
  String? profileUrl;
   
  File? file;
  final imagePicker = ImagePicker();
 

  

  Future<String> uploadImageToFirebase(imageFile) async {
    String url = "";
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("pp_$ppId");
    UploadTask uploadTask = ref.putFile(file!);
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
       ppId = Uuid().v4();
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
        padding: const EdgeInsets.fromLTRB(100.0, 0.0, 0.0, 0.0),
        child: FloatingActionButton(
          onPressed: (){
            
          },
          child: Icon(Icons.camera_outlined),
          backgroundColor: Colors.pinkAccent,
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(50.0, 0.0, 0.0, 0.0),
        child: FloatingActionButton(
          onPressed: (){
            file = imagePicker.pickImage(source: ImageSource.camera) as File;
            setState(() {
              
            
            uploadImageToFirebase(file);
             String uid = _auth.currentUser!.uid.toString();
                uploadImage(uid);
                });
          },
          child: Icon(Icons.add_photo_alternate_outlined),
          backgroundColor: Colors.pinkAccent,
        ),
      )
    ]));
  }

  FirebaseStorage _storage = FirebaseStorage.instance;

  // Future<Uri> uploadPic(File image) async {
  //   //Get the file from the image picker and store it

  //   //Create a reference to the location you want to upload to in firebase
  //   Reference reference = _storage.ref().child("images/");

  //   //Upload the file to firebase
  //   UploadTask uploadTask = reference.putFile(_image!);

  //   // Waits till the file is uploaded then stores the download url
  //   final location = await uploadTask.then((res) {
  //     res.ref.getDownloadURL();
  //   });

  //   //returns the download url
  //   return location;
  // }
   // Future<String> uploadImageToFirebase(imageFile) async {
  //   String url = "";
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   Reference ref = storage.ref().child("pp_${_auth.currentUser!.uid.toString()}");
  //   // UploadTask uploadTask = ref.putFile(image);
  //   await uploadTask.whenComplete(() async {
  //     url = await ref.getDownloadURL();
  //   });
  //   return url;
  // }

// }
  // }

  // Future getImageFromGallery() async {
  //   final imageGallery =
  //       await imagePicker.pickImage(source: ImageSource.camera);
  //   setState(() {
  //     if (imageGallery!.path != null) {
  //       _image = File(imageGallery.path);
  //       final destination = 'files/$_image';
  //       // uploadPic();
  //     }
  //   });
  // }
  // Future getImage() async { 
  //   print('get image is called here');
  //   FirebaseStorage storage = FirebaseStorage.instance;

  //   File image;
  //   try {
  //     image = imagePicker.pickImage(source: ImageSource.camera) as File;
  //   } catch (e) {
  //     return;
  //   }

  //   Reference reference = storage.ref().child("pp_${_auth.currentUser!.uid.toString()}");
  //   print('this iss                  $reference');

  //   UploadTask uploadTask = reference.putFile(image);

  //   await uploadTask.whenComplete(() async
  //    {  url = await reference.getDownloadURL();
  //   });
  //   return url;

  // }
}