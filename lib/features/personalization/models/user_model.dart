import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cwt_ecommerce_admin_panel/features/personalization/models/address_model.dart';
import 'package:cwt_ecommerce_admin_panel/features/shop/models/order_model.dart';

import '../../../../utils/formatters/formatter.dart';
import '../../../utils/constants/enums.dart';

/// Model class representing user data.
class UserModel {
  final String? id;
  String firstName;
  String lastName;
  String userName;
  String email;
  String phoneNumber;
  String profilePicture;
  AppRole role;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? coupon;
  List<OrderModel>? orders;
  List<AddressModel>? addresses;

  /// Constructor for UserModel.
  UserModel({
    this.id,
    required this.email,
    this.firstName = '',
    this.lastName = '',
    this.userName = '',
    this.phoneNumber = '',
    this.profilePicture = '',
    this.role = AppRole.user,
    this.createdAt,
    this.updatedAt,
    this.coupon
  });

  /// Helper methods
  String get fullName => '$firstName $lastName';

  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  String get formattedDate => TFormatter.formatDate(createdAt);

  String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);

  /// Static function to create an empty user model.
  static UserModel empty() => UserModel(email: ''); // Default createdAt to current time

  /// Convert model to JSON structure for storing data in Firebase.
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'FirstName': firstName,
      'LastName': lastName,
      'UserName': userName,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'Role': role.name.toString(),
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt = DateTime.now(),
    };
  }

  static AppRole _roleFromString(String? roleName) {
    return AppRole.values.firstWhere(
      (role) => role.name == roleName,
      orElse: () => AppRole.user,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  factory UserModel.fromJson(Map<String, dynamic> data, {String? id}) {
    return UserModel(
      id: id ?? data['id']?.toString(),
      firstName: data.containsKey('FirstName') ? data['FirstName'] ?? '' : '',
      lastName: data.containsKey('LastName') ? data['LastName'] ?? '' : '',
      userName: data.containsKey('UserName') ? data['UserName'] ?? '' : '',
      email: data.containsKey('Email') ? data['Email'] ?? '' : '',
      phoneNumber: data.containsKey('PhoneNumber') ? data['PhoneNumber'] ?? '' : '',
      profilePicture: data.containsKey('ProfilePicture') ? data['ProfilePicture'] ?? '' : '',
      role: _roleFromString(data['Role']?.toString()),
      createdAt: _parseDate(data['CreatedAt']) ?? DateTime.now(),
      updatedAt: _parseDate(data['UpdatedAt']) ?? DateTime.now(),
      coupon: data.containsKey('Cupon') ? data['Cupon'] ?? '' : '',
    );
  }

  /// Factory method to create a UserModel from a Firebase document snapshot.
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    return UserModel.fromJson(document.data() ?? {}, id: document.id);
  }
}
