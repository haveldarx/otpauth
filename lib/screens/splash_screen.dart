import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otpfv/main.dart';
import 'package:otpfv/screens/home_screen.dart';

import 'login_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);
  

  
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    final user = auth.currentUser;
    super.initState();
    InitializerWidget();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('images\splashScreen.jpeg')
        ],
      ),
      
    );
  }
}
class InitializerWidget extends StatefulWidget {
  @override
  _InitializerWidgetState createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {

  late FirebaseAuth _auth;

  late User _user;

  bool isLoading = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth = FirebaseAuth.instance;
     
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    ) : _auth.currentUser == null ? LoginScreen() : HomeScreen();
  }
}