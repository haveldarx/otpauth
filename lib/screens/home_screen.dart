

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:otpfv/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otpfv/screens/updater_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
   final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 2),
    () => 'Data Loaded',
  );
}

class _HomeScreenState extends State<HomeScreen> {
  

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map? data;
  var _userName;
  var _profileUrl;
  var _url;
  var _phone;
  var _email;
  final _auth = FirebaseAuth.instance;
  Future _getUserName() async {
    print(
        'user id 222222222222222222222222222222222222222222222222222222222222222222222222222 ${_auth.currentUser!.uid}');
    var ppId = _auth.currentUser!.uid;
    print('this isssssssssssssssssssssssssssssssssssss ppid $ppId');
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("images/$ppId");
    _url = await ref.getDownloadURL();

    _profileUrl = _url.toString();
    print('this issssssssssssssssssss url $_profileUrl');
    try {
      var doc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
          
      data = doc.data();
      _userName = data?['fullname'];
      _phone = data?['phone'];
      _email = data?['email'];
      return doc.data();
    } catch (e) {
      print(e.toString());
    }
    
  }
  @override
  void initState() {
    super.initState();
    
    setState(() {
      _getUserName();
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        
        drawer:  FutureBuilder(
          future: _getUserName(),
          builder: (BuildContext context ,AsyncSnapshot snapshot){
            
            if (snapshot.hasData){
              return Drawer(
              
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: CircleAvatar(
                      radius: 50,
                      child: ClipOval(
                        child: _profileUrl != null
                            ? Image.network(
                                '$_profileUrl',
                                height: 160,
                                width: 160,
                                fit: BoxFit.cover,
                              )
                            : Image.asset('images/clock.png'),
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Text('Name'),
                title: Text('$_userName'),
              ),
              ListTile(leading: Text('Phone'), title: Text('$_phone')),
              ListTile(
                leading: Text('Email'),
                title: Text('$_email'),
              ),
              ListTile(
                leading: Text('Update details'),
                onTap:() {
                   Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpdateCred()));
                },
              )
            ],
          ),
        
               );
               
                }
                else {
                  return CircularProgressIndicator();
                }
          }
          ),
          
        appBar: AppBar(
          title: Text('SOSKRU'),
          centerTitle: true,
          backgroundColor: Colors.redAccent[400],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/splashBg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Text("Home Screen"),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await _auth.signOut();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
            final SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            sharedPreferences.remove('uid');
            
          },
          child: Icon(Icons.logout),
        ),
      ),
    );
  }
}
