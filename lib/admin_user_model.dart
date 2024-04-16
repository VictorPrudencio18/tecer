import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUserModel {
  String uid;
  String name;
  String surname;
  String photoUrl;
  int age;
  String city;
  String gender;

  AdminUserModel({
    required this.uid,
    required this.name,
    required this.surname,
    required this.photoUrl,
    required this.age,
    required this.city,
    required this.gender,
  });

  factory AdminUserModel.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return AdminUserModel(
      uid: snapshot.id,
      name: data['name'] ?? '',
      surname: data['surname'] ?? '',
      photoUrl: data['photoUrl'] ?? 'https://via.placeholder.com/150',
      age: data['age'] ?? 0,
      city: data['city'] ?? '',
      gender: data['gender'] ?? '',
    );
  }
}
