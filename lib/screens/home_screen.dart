import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otpfv/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  final _auth = FirebaseAuth.instance;
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop:() async => false,child: Scaffold(
        appBar: AppBar(title: Text('SOSKRU'),
        centerTitle: true,
        backgroundColor: Colors.redAccent[400],),
        
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
          onPressed: ()async{
            await _auth.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          },
          child: Icon(Icons.logout),
        ),
      ),
    );
  }
}
