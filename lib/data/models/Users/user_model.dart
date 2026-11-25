import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wassalni/core/enum/user_role.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String phone;
  final UserRole role;
  final DateTime dateCreate;
  final String? imageUrl;
  final String? city;
  final String? activeOrderId;
  final String? defaultAddressId;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.role,
    required this.dateCreate,
    this.imageUrl,
    this.activeOrderId,
    this.defaultAddressId,
    this.city,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ,
      username: map['username'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      role: _parseRole(map['role'] as String?),
      dateCreate: _parseDate(map['dateCreate']),
      imageUrl: map['urlimage'] as String?, // المفتاح القديم محفوظ
      city: map['city'] as String?,
      activeOrderId: map['activeOrderId'] as String?,
      defaultAddressId: map['defaultAddressId'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'username': username,
    'email': email,
    'phone': phone,
    'role': role.name,
    'dateCreate': dateCreate.toIso8601String(),
    'urlimage': imageUrl,
    'city': city,
    'activeOrderId': activeOrderId,
    'defaultAddressId': defaultAddressId,
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
      activeOrderId: activeOrderId ?? activeOrderId,
      defaultAddressId: defaultAddressId ?? defaultAddressId,
    );
  }

  /// يقبل 'customer' و 'UserRole.customer' (البيانات القديمة)
  static UserRole _parseRole(String? raw) {
    final name = raw?.split('.').last;
    return UserRole.values.asNameMap()[name] ?? UserRole.customer;
  }

  /// يقبل نصًا ISO (القديم) أو Timestamp (الجديد)
  static DateTime _parseDate(dynamic raw) {
    if (raw is Timestamp) return raw.toDate();
    if (raw is String) return DateTime.tryParse(raw) ?? DateTime.now();
    return DateTime.now();
  }

  String toJson() => json.encode(toMap());
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
