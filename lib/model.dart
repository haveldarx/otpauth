import 'package:cloud_firestore/cloud_firestore.dart';

class OurUser{
  String? uId;
  String? email;
  String? phoneNumber;
  String? fullName;
  Timestamp? timestamp;
 OurUser({this.uId,
          this.email,
          this.phoneNumber,
          this.fullName,
          this.timestamp});

}