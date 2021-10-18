import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otpfv/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _getUserName();
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map? data;
  var _userName;
  var _phone;
  var _email;
   final _auth = FirebaseAuth.instance;
        Future<void> _getUserName() async {
          print('user id 222222222222222222222222222222222222222222222222222222222222222222222222222 ${_auth.currentUser!.uid}');
          try {
            var doc = await _firestore
            .collection('users')
            .doc( _auth.currentUser!.uid)
            .get(); 
            data =  doc.data();
            _userName = data?['username'];
            _phone = data?['phone'];
            _email = data?['email'];
          } catch (e) {
            print(e.toString());
          }
        
        
          //   .then((value) {
          // setState(() {
           
          //    var data = value.data();
             
          //    _userName = data?['username'].toString();
             

          //   print('username isssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss $_userName');
          // });
        }
      

  
 
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop:() async => false,child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children:<Widget> [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.white),
                child:  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
            
            child:
                  CircleAvatar(
                    radius: 50,
                    child: ClipOval(
                      child: Image.network(
                        'images/icon.png',
                        height: 160,
                        width: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ),
                ),
            ),
            ListTile(
              leading: Text('Name'),
              title: Text('$_userName'),
            ),
            ListTile(
              leading: Text('Phone'),
              title:Text('$_phone')
            ),
            ListTile(
              leading: Text('Email'),
              title: Text('$_email'),
            )
            
            ],
          ),
        ),
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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen())
            );
            final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
            sharedPreferences.remove('uid');
          },
          child: Icon(Icons.logout),
        ),
      ),
    );
  }
}
