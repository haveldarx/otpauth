import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:otpfv/database.dart';
import 'package:otpfv/model.dart';
import 'package:otpfv/screens/home_screen.dart';
import 'package:otpfv/screens/otp_screen.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:otpfv/user_credential.dart';


enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  // late String pinAuth;
  FirebaseAuth _auth = FirebaseAuth.instance;

  late String verificationId;
  late UserCredential authCredential;

  bool showLoading = false;
  OurUser _user =  OurUser();

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
          

      setState(() {
        showLoading = false;
      });

      if(authCredential.user != null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
      }

    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      // _scaffoldKey.currentState!
          // .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
  Future<String> signUpUser(String email, String password, String fullName) async {
    String retVal = "error";
    OurUser _user = OurUser();
    try{
      _user.uid = authCredential.user!.uid;
      _user.email = authCredential.user!.uid;
      _user.fullName = fullName;
      String _returnString = await OurDatabse().createUser(_user);
      if(_returnString == "success")
      retVal = "success";
    }on PlatformException catch (e) {
      retVal = e.message.toString();

    }catch (e){
      print(e);
    }
    return retVal;
  }

  getMobileFormWidget(context) {
    return Scaffold(
      
      body: Column(
        children: [
          Image.asset('images/icon.png',scale: 3,),
          Text("Login",style: TextStyle(fontSize: 30),),
          SizedBox(height:40),
          Row(
            children: [
              Text("Enter phone number",style: TextStyle(fontSize: 30),),
            ],
          ),
          TextField(
            
            autofocus: true,
            controller: phoneController,
            decoration: InputDecoration(
              hintMaxLines: 10,
              hintText: "Phone Number",
            ),
          ),
          SizedBox(
            height: 16,
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                showLoading = true;
              });
    
              await _auth.verifyPhoneNumber(
                phoneNumber: phoneController.text,
                verificationCompleted: (phoneAuthCredential) async {
                  setState(() {
                    showLoading = false;
                  });
                  signInWithPhoneAuthCredential(phoneAuthCredential);
                },
                verificationFailed: (verificationFailed) async {
                  setState(() {
                    showLoading = false;
                  });
                  // _scaffoldKey.currentState.showSnackBar(
                      // SnackBar(content: Text(verificationFailed.message)));
                },
                codeSent: (verificationId, resendingToken) async {
                  setState(() {
                    showLoading = false;
                    currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                    this.verificationId = verificationId;
                  });
                },
                codeAutoRetrievalTimeout: (verificationId) async {},
              );
            },
            child: Text("SEND",style: TextStyle(fontSize: 20),),
            
          ),
          Spacer(),
        ],
      ),
    );
  }

  getOtpFormWidget(context) {
     return
     Column(
      children: [
        Image.asset('images/otpScreen.jpeg',),
        Text('Welcome to sos kru',style: TextStyle(fontSize: 30,
        color: Colors.pink[200],
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w600 ),),
        Text("Enter otp To verify phone"),
        Spacer(flex: 1,),
        TextField(
  //         length: 6,
  // width: MediaQuery.of(context).size.width,
  
  // fieldWidth: 50,
  // style: TextStyle(
  //   fontSize: 17
  // ),
  // textFieldAlignment: MainAxisAlignment.spaceAround,
  // fieldStyle: FieldStyle.box,
  // onCompleted: (pin) {
  //   pinAuth = pin;
  //   print("Completed: " + pin);
  // },
          controller: otpController,
          decoration: InputDecoration(
            hintText: "Enter OTP",
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextButton(
          onPressed: () async {
            PhoneAuthCredential phoneAuthCredential =
                PhoneAuthProvider.credential(
                    verificationId: verificationId, smsCode: otpController.toString());

            signInWithPhoneAuthCredential(phoneAuthCredential);
          },
          child: Text("VERIFY"),
          
         
        ),
        Spacer(flex: 3,),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SOSKRU'),
      backgroundColor: Colors.pink[200],
      centerTitle: true,),
        key: _scaffoldKey,
        body: Container(
          child: showLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                  ? getMobileFormWidget(context)
                  : getOtpFormWidget(context),
          padding: const EdgeInsets.all(16),
        ));
  }
}
