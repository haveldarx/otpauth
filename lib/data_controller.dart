// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// class DataController extends GetxController{
//   AuthController authController = AuthCredential
//   final userName = TextEditingController();
//   final userPhone = TextEditingController();
//   final userEmail = TextEditingController();
//   final FirebaseInstance = FirebaseFirestore.instance;
//   Map userProfileData = {'fullname':'','phone':'','email':''};
//   void onReady(){
//     super.onReady();
//     getUserProfileData();
//   }

//   Future<void> getUserProfileData() async {
//     try{
//       var response = await FirebaseInstance.collection('users').where('fullname',isEqualTo: userName).get();
//       if(response.docs.length > 0){
//         userProfileData['fullname'] = response.docs[0]['fullname'];
//       }

//     }
//   }
// }