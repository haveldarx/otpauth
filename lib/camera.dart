// import 'package:flutter/material.dart';

// import 'dart:io';

// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class Camera extends StatefulWidget {
//   const Camera({Key? key}) : super(key: key);

//   @override
//   _CameraState createState() => _CameraState();
// }

// class _CameraState extends State<Camera> {
//   File? _image;
//   final imagePicker = ImagePicker();
  
//   // Future getImage() async {
//   //   FirebaseStorage storage = FirebaseStorage.instance;

//   //   File image;
//   //   try {
//   //     image = imagePicker.pickImage(source: ImageSource.camera) as File;
//   //   } catch (e) {
//   //     return;
//   //   }

//   //   Reference reference = storage.ref().child("images/");

//   //   UploadTask uploadTask = reference.putFile(image);

//   //   TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() async
//   //    { String  url = await reference.getDownloadURL();
//   //   return url;});

    
//   // }

//   // Future getImageFromGallery() async {
//   //   final imageGallery =
//   //       await imagePicker.pickImage(source: ImageSource.camera);
//   //   setState(() {
//   //     if (imageGallery!.path != null) {
//   //       _image = File(imageGallery.path);
//   //       final destination = 'files/$_image';
//   //       // uploadPic();
//   //     }
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: Row(children: <Widget>[
//       Padding(
//         padding: const EdgeInsets.fromLTRB(100.0, 0.0, 0.0, 0.0),
//         child: FloatingActionButton(
//           onPressed: getImage,
//           child: Icon(Icons.camera_outlined),
//           backgroundColor: Colors.pinkAccent,
//         ),
//       ),
//       Padding(
//         padding: const EdgeInsets.fromLTRB(50.0, 0.0, 0.0, 0.0),
//         child: FloatingActionButton(
//           onPressed: getImageFromGallery,
//           child: Icon(Icons.add_photo_alternate_outlined),
//           backgroundColor: Colors.pinkAccent,
//         ),
//       )
//     ]));
//   }

//   FirebaseStorage _storage = FirebaseStorage.instance;

//   Future<Uri> uploadPic(File image) async {
//     //Get the file from the image picker and store it

//     //Create a reference to the location you want to upload to in firebase
//     Reference reference = _storage.ref().child("images/");

//     //Upload the file to firebase
//     UploadTask uploadTask = reference.putFile(_image!);

//     // Waits till the file is uploaded then stores the download url
//     final location = await uploadTask.then((res) {
//       res.ref.getDownloadURL();
//     });

//     //returns the download url
//     return location;
//   }
// }
