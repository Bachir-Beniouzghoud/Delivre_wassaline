import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  String? username, email, password, urlimage, dateCreate, phone, id;
  UserModel({
    this.id,
    this.phone,
    this.username,
    this.email,
    this.password,
    this.urlimage,
    this.dateCreate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      'phone': phone,
      'password': password,
      'username': username,
      'email': email,
      'urlimage': urlimage,
      'dateCreate': dateCreate,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> json) {
    if (json.isEmpty) return UserModel();

    return UserModel(
      id: json['id'] as String?,
      phone: json['phone'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      urlimage: json['urlimage'] as String?,
      dateCreate: json['dateCreate'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
