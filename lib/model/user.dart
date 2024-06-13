import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? id;
  String userName;
  String address;
  String mobileNumber;
  String email;
  String password;
  String role;

  User({
    this.id,
    required this.userName,
    required this.address,
    required this.mobileNumber,
    required this.email,
    required this.password,
    required this.role,
  });

  User.create({
    this.id,
    required this.userName,
    required this.address,
    required this.mobileNumber,
    required this.email,
    required this.password,
    required this.role,
  });

  User.fromJson(Map<String, Object?> json)
      : this(
          id: json['id'] as String?,
          userName: json['userName']! as String,
          address: json['address']! as String,
          mobileNumber: json['mobileNumber']! as String,
          email: json['email']! as String,
          password: json['password']! as String,
          role: json['role']! as String,
        );

  User copyWith({
    String? id,
    String? userName,
    String? address,
    String? mobileNumber,
    String? email,
    String? password,
    String? role,
  }) {
    return User(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      address: address ?? this.address,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'userName': userName,
      'address': address,
      'mobileNumber': mobileNumber,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}
