//class that holds all of the userdata for firebase
import 'package:flutter/cupertino.dart';

class Data {

  final String firstName;
  final String lastName;
  final String age;
  final String height;
  final String weight;
  final String gender;
  final ImageProvider? profilePhoto;
  final String? weightGoal;

  Data({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    this.profilePhoto,
    this.weightGoal
  });

}