import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:otpfv/screens/home_screen.dart';
import 'package:otpfv/screens/login_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: InitializerWidget());
  }
}

class InitializerWidget extends StatefulWidget {
  @override
  _InitializerWidgetState createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {
  late FirebaseAuth _auth;
  bool userIsLoggedIn = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool collectionComplete = false;
  bool isLoading = true;
  _getUserstatus() async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) {
        if (value.exists) {
          userIsLoggedIn = true;
          
               print(
              'user is logggggggggggggggggggggggggggggggggggeeeeeeeedddddddddd $userIsLoggedIn');
        }
       
        
      });
    } catch (e) {
      print(e.toString());
    }
    setState(() {
       isLoading = false;
    });
   
  }

  

  @override
  void initState() {
    _auth = FirebaseAuth.instance;
  
     
    
     
    super.initState();
    _getUserstatus();
    
   

      

    
  
  }
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (_auth.currentUser != null && userIsLoggedIn) {
      return HomeScreen();
    } else if (_auth.currentUser != null) {
      return LoginScreen();
    } else {
      return LoginScreen();
    } //UserCred() L
  }
}
