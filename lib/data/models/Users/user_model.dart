import 'dart:convert';

import 'package:wassalni/core/enum/user_role.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String phone;
  final UserRole role;
  final DateTime dateCreate;
  final String? imageUrl; // اختياري
  final String? city; // اختياري، يحتاجه السائق لفلترة الطلبات

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.role,
    required this.dateCreate,
    this.imageUrl,
    this.city,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      role: _parseRole(map['role'] as String?),
      dateCreate: DateTime.parse(map['dateCreate'] as String),
      imageUrl: map['urlimage'] as String?, // اسم المفتاح القديم محفوظ
      city: map['city'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'username': username,
    'email': email,
    'phone': phone,
    'role': role.name, // 'customer' وليس 'UserRole.customer'
    'dateCreate': dateCreate.toIso8601String(),
    'urlimage': imageUrl,
    'city': city,
  };

  UserModel copyWith({
    String? username,
    String? phone,
    UserRole? role,
    String? imageUrl,
    String? city,
  }) {
    return UserModel(
      id: id,
      username: username ?? this.username,
      email: email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      dateCreate: dateCreate,
      imageUrl: imageUrl ?? this.imageUrl,
      city: city ?? this.city,
    );
  }

  /// يقبل 'customer' و 'UserRole.customer' (البيانات القديمة)
  static UserRole _parseRole(String? raw) {
    final name = raw?.split('.').last;
    return UserRole.values.asNameMap()[name] ?? UserRole.customer;
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
