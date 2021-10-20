
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:otpfv/camera.dart';
import 'package:otpfv/database.dart';
import 'package:otpfv/model.dart';
import 'package:otpfv/screens/home_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'fade_animation.dart';

class UserCred extends StatefulWidget {
  UserCred({Key? key}) : super(key: key);

  @override
  _UserCredState createState() => _UserCredState();
}

class _UserCredState extends State<UserCred> {
   FirebaseAuth _auth = FirebaseAuth.instance;
  late String url;
  bool isUploading = true;
  var ppId;
  String? profileUrl;
  final picker = ImagePicker();
  var imageId ;
  final imagePicker = ImagePicker();
  XFile? file;
  File? upfile; 

  Future<String> uploadImageToFirebase(imageFile) async {
    var uid = _auth.currentUser!.uid;
    String url = "";
    FirebaseStorage storage = FirebaseStorage.instance;
     ppId = Uuid().v4();
    Reference ref = storage.ref().child("images/$uid");
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
       imageId =  ppId;
      isUploading = false;
      profileUrl = imageUrl.toString();
      print('this issssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss $profileUrl');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Image Uploaded!"),
      ),
    );
  }
  
// late UserCredential authCredential;
  final userName = TextEditingController();
  final userEmail = TextEditingController();
   

  
  
  final userPhone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              // Colors.purple,
              Colors.pink.shade200,
              Colors.pinkAccent,
            ])),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: FadeAnimation(
                2,
                CircleAvatar(
                  radius: 50,
                  child: ClipOval(
                    child: profileUrl != null ?Image.network(
                      '$profileUrl',
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ): Image.asset('images/clock.png'),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                  margin: const EdgeInsets.only(top: 60),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Container(
                            // color: Colors.red,
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(left: 22, bottom: 10),
                            child: const FadeAnimation(
                              2,
                              Text(
                                "Enter your details",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black87,
                                  letterSpacing: 2,
                                ),
                              ),
                            )),
                        FadeAnimation(
                          2,
                          Container(
                              width: double.infinity,
                              height: 70,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 2),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.pinkAccent, width: 1),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.pinkAccent,
                                        blurRadius: 10,
                                        offset: Offset(1, 1)),
                                  ],
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.person_outlined),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: TextField(
                                        controller: userName,
                                        maxLines: 1,
                                        decoration: const InputDecoration(
                                          hintText: "Name ",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        FadeAnimation(
                          2,
                          Container(
                              width: double.infinity,
                              height: 70,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.pinkAccent, width: 1),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.pinkAccent,
                                        blurRadius: 10,
                                        offset: Offset(1, 1)),
                                  ],
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.email_outlined),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                        controller: userEmail,
                                        maxLines: 1,
                                        decoration: const InputDecoration(
                                          hintText: " Email",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        FadeAnimation(
                          2,
                          Container(
                              width: double.infinity,
                              height: 70,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.pinkAccent, width: 1),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.pinkAccent,
                                        blurRadius: 10,
                                        offset: Offset(1, 1)),
                                  ],
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.phone_android),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: TextField(
                                        controller: userPhone,
                                        maxLines: 1,
                                        decoration: const InputDecoration(
                                          hintText: "Phone Number ",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            // color: Colors.red,
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(left: 22),
                            child: const FadeAnimation(
                              2,
                              Text(
                                "Select profile picture",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black87,
                                  letterSpacing: 2,
                                ),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: FadeAnimation(2, Container(
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
                          )),
                        ),
                        FadeAnimation(
                          2,
                          ElevatedButton(
                            onPressed: () async {
                              OurUser user = OurUser(
                              uId: _auth.currentUser!.uid.toString(),
                                email: userEmail.text,
                                phoneNumber: userPhone.text,
                                fullName: userName.text,
                              );
                              OurDatabse().createUser(user);
                              final uIdSP = _auth.currentUser!.uid.toString();
                              final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                              sharedPreferences.setString('uid', uIdSP);
                              sharedPreferences.setString('userName', userName.toString());
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            },
                            style: ElevatedButton.styleFrom(
                                onPrimary: Colors.redAccent[400],
                                shadowColor: Colors.pinkAccent,
                                elevation: 18,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: Ink(
                              decoration: BoxDecoration(
                                  color: Colors.pinkAccent,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                width: 200,
                                height: 50,
                                alignment: Alignment.center,
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
