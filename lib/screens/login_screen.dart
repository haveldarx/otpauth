import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:otpfv/database.dart';
import 'package:otpfv/model.dart';
import 'package:otpfv/screens/home_screen.dart';

import 'package:otpfv/user_credential.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fade_animation.dart';

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
  String uid = '';
  String finalEmail = '';
  late String verificationId;
  late UserCredential authCredential;
  String? phoneNumber;
  PhoneNumber number = PhoneNumber(isoCode: 'IND');
  bool showLoading = false;
  // OurUser _user = OurUser();
  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getString('email');
    setState(() {
      finalEmail = obtainedEmail.toString();
    });
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      uid = (_auth.currentUser)!.uid;

      setState(() {
        showLoading = false;
      });
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final uisp = sharedPreferences.getString('uid');

      print(
          'uid isssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss $uisp');
      if (authCredential.user != null &&
          _auth.currentUser!.uid.toString() == uisp) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else if (authCredential.user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => UserCred()));
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      setState(() {
        showLoading = false;
      });

      // _scaffoldKey.currentState!
      // .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<String> signUpUser(
      String email, String password, String fullName) async {
    String retVal = "error";
    OurUser _user = OurUser();
    try {
      _user.uId = uid;
      _user.email = authCredential.user!.uid;
      _user.fullName = fullName;
      String _returnString = await OurDatabse().createUser(_user);
      if (_returnString == "success") retVal = "success";
    } on PlatformException catch (e) {
      retVal = e.message.toString();
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  getMobileFormWidget(context) {
    return Column(
      children: [
        FadeAnimation(
            2,
            Image.asset(
              'images/icon.png',
              scale: 3,
            )),
        FadeAnimation(
            2,
            Text(
              "Login",
              style: TextStyle(fontSize: 30, color: Colors.white),
            )),
        SizedBox(height: 40),
        FadeAnimation(
          2,
          Row(
            children: [
              Text(
                "Enter phone number",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ],
          ),
        ),
        FadeAnimation(
            2,
            Container(
              width: double.infinity,
              height: 90,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.pinkAccent, width: 1),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.pinkAccent,
                        blurRadius: 10,
                        offset: Offset(1, 1)),
                  ],
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 1),
                child: InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    phoneNumber = number.phoneNumber;
                    print(number.phoneNumber);
                  },
                  onInputValidated: (bool value) {
                    print(value);
                  },
                  selectorConfig: SelectorConfig(
                    selectorType: PhoneInputSelectorType.DIALOG,
                  ),
                  ignoreBlank: false,
                  searchBoxDecoration: InputDecoration(fillColor: Colors.white,),
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  initialValue: number,
                  selectorTextStyle: TextStyle(color: Colors.black),
                  textFieldController: phoneController,
                  formatInput: false,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  inputBorder: OutlineInputBorder(),
                  onSaved: (PhoneNumber number) {
                    print('On Saved: $number');
                  },
                ),
              ),
            )),
        Spacer(
          flex: 1,
        ),
        TextButton(
          onPressed: () async {
            setState(() {
              showLoading = true;
              
            });

            await _auth.verifyPhoneNumber(
              phoneNumber: phoneNumber.toString(),
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
          child: Text(
            "SEND",
            style: TextStyle(fontSize: 20),
          ),
        ),
        Spacer(
          flex: 3,
        ),
      ],
    );
  }

  getOtpFormWidget(context) {
    return Column(
      children: [
        Image.asset(
          'images/otpScreen.jpeg',
        ),
        Text(
          'Welcome to sos kru',
          style: TextStyle(
              fontSize: 30,
              color: Colors.pink[200],
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600),
        ),
        Text("Enter otp To verify phone"),
        Spacer(
          flex: 1,
        ),
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
                    verificationId: verificationId,
                    smsCode: otpController.text);

            signInWithPhoneAuthCredential(phoneAuthCredential);
          },
          child: Text("VERIFY"),
        ),
        Spacer(
          flex: 3,
        ),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SOSKRU'),
          backgroundColor: Colors.redAccent[400],
          centerTitle: true,
        ),
        key: _scaffoldKey,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/splashBg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
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

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
  }
}
