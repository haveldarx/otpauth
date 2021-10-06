import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otpfv/model.dart';

class OurDatabse{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future createUser(OurUser user)async {
    String retVal = 'error';
    try{
      await _firestore.collection('users').doc(user.uid).set({
        'fullname': user.fullName,
        'email' : user.email,
        'accountcreated' : user.timestamp,
        

      });
      retVal = "Success";
    }
    catch(e){
      print(e);
    }
    return retVal;
  }
}