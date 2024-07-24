import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUserModel {
  final String id;
  final String name;
  final String photoUrl;
  final String surname;
  final int age;
  final String city;
  final String gender;

  AdminUserModel({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.surname,
    required this.age,
    required this.city,
    required this.gender,
  });

  factory AdminUserModel.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return AdminUserModel(
      id: snapshot.id,
      name: data['name'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      surname: data['surname'] ?? '',
      age: int.tryParse(data['age'].toString()) ?? 0,
      city: data['city'] ?? '',
      gender: data['gender'] ?? '',
    );
  }
}
