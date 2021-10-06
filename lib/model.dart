import 'package:cloud_firestore/cloud_firestore.dart';

class OurUser{
  String? uid;
  String? email;
  String? phoneNumber;
  String? fullName;
  Timestamp? timestamp;
 OurUser({this.uid,
          this.email,
          this.phoneNumber,
          this.fullName,
          this.timestamp});

}