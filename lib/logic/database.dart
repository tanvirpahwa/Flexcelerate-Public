import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:FleXcelerate/logic/user.dart';
import 'package:flutter/cupertino.dart';
import 'data.dart';

//allows you to easily access the firebase
class DatabaseService {

  //connects the data in the firebase to your user
  final String uid;
  DatabaseService({ required this.uid });

  final CollectionReference userDataCollection = FirebaseFirestore.instance.collection('UserData');

  //updates the userdata in firebase with your data
  Future updateUserData(String firstName,String lastName, String age, String height, String weight, String gender, ImageProvider profilePhoto, String weightGoal) async {
    return await userDataCollection.doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'height': height,
      'weight': weight,
      'gender': gender,
      'profileImage': profilePhoto,
      'weightGoal' : weightGoal,
    });
  }

  //gets the data from the firebase
  Iterable<Data> _dataListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return Data(
        firstName: doc.get('firstName') ?? '',
        lastName: doc.get('lastName') ?? '',
        age:  doc.get('age') ?? '',
        height: doc.get('height') ?? '',
        weight: doc.get('weight') ?? '',
        gender: doc.get('gender') ?? '',
        profilePhoto: doc.get('profilePhoto') ?? '',
        weightGoal: doc.get('weightGoal') ?? '',
      );
    });
  }

  //userdata from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(uid: uid,
        firstName: snapshot.get('firstName'),
        lastName: snapshot.get('lastName'),
        age: snapshot.get('age'),
        height: snapshot.get('height'),
        weight: snapshot.get('weight'),
        gender: snapshot.get('gender'),
        profilePhoto: snapshot.get('profilePhoto'),
        weightGoal: snapshot.get('weightGoal'));
  }

  //turns the data into a list for easier access
  Stream<Iterable<Data>> get user {
    return userDataCollection.snapshots()
        .map(_dataListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return userDataCollection.doc(uid).snapshots()
        .map(_userDataFromSnapshot);
  }
}