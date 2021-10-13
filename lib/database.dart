import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:otpfv/model.dart';

class OurDatabse{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // late UserCredential authCredential;
  FirebaseAuth _auth = FirebaseAuth.instance;
  
  Future createUser(OurUser user)async {
    String retVal = 'error';
    try{
      await _firestore.collection('users').doc(_auth.currentUser!.uid.toString()).set({
        'fullname': user.fullName,
        'email' : user.email,
        'phone' : user.phoneNumber,
        'userid' : user.uId
        

      });
      retVal = "Success";
    }
    catch(e){
      print(e);
    }
    return retVal;
  }
}