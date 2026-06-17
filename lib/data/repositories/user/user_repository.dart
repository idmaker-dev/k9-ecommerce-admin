import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/supabase/supabase_client.dart';
import '../../../features/personalization/models/bank_account_model.dart';
import '../../../features/personalization/models/user_model.dart';
import '../../../features/shop/models/order_model.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../authentication/authentication_repository.dart';

/// Repository class for user-related operations.
class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _usersTable = 'users';
  static const String _ordersTable = 'orders';
  static const String _bankAccountsTable = 'bank_accounts';

  /// Function to save user data to Firestore.
  Future<void> createUser(UserModel user) async {
    try {
      await supabase.from(_usersTable).upsert({'id': user.id, 'data': user.toJson()});
      return;
    } catch (_) {
      // Fallback during migration.
    }

    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Function to fetch user details based on user ID.
  Future<List<UserModel>> getAllUsers() async {
    try {
      final rows = await supabase.from(_usersTable).select().neq('role', 'admin');
      return (rows as List)
          .map((e) => flattenRow(Map<String, dynamic>.from(e)))
          .map((json) => UserModel.fromJson(json, id: json['id']?.toString()))
          .toList();
    } catch (_) {
      // Fallback during migration.
    }

    try {
      final querySnapshot = await _db.collection("Users").where('Role', isNotEqualTo: 'admin').get();
      return querySnapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) print('Something Went Wrong: $e');
      throw 'Something Went Wrong: $e';
    }
  }


  /// Function to fetch user details based on user ID.
  Future<UserModel> fetchUserDetails(String id) async {
    try {
      final row = await supabase.from(_usersTable).select().eq('id', id).maybeSingle();
      if (row != null) {
        return UserModel.fromJson(flattenRow(Map<String, dynamic>.from(row)), id: id);
      }
      return UserModel.empty();
    } catch (_) {
      // Fallback during migration.
    }

    try {
      final documentSnapshot = await _db.collection("Users").doc(id).get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) print('Something Went Wrong: $e');
      throw 'Something Went Wrong: $e';
    }
  }

  Future<UserModel> fetchUserDetailsByAttribute(String attributeName, String attributeValue) async {
    try {
      final filterField = 'data->>$attributeName';
      final rows = await supabase.from(_usersTable).select().filter(filterField, 'eq', attributeValue).limit(1);
      if ((rows as List).isNotEmpty) {
        return UserModel.fromJson(flattenRow(Map<String, dynamic>.from(rows.first)));
      }
      return UserModel.empty();
    } catch (_) {
      // Fallback during migration.
    }

    try {
      final querySnapshot = await _db.collection("Users")
          .where(attributeName, isEqualTo: attributeValue)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return UserModel.fromSnapshot(querySnapshot.docs.first);
      } else {
        return UserModel.empty();
      }
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) print('Something Went Wrong: $e');
      throw 'Something Went Wrong: $e';
    }
  }

  Future<BankAccountModel?> fetchBankAccount(String userId) async{
    try{
      final row = await supabase.from(_bankAccountsTable).select().eq('user_id', userId).maybeSingle();
      if (row != null) {
        return BankAccountModel.fromJson(flattenRow(Map<String, dynamic>.from(row)));
      }
      return null;
    }catch(_){
      // Fallback during migration.
    }

    try{
      final result = await _db.collection('Users').doc(userId).collection('BankAccounts').get();
      return result.docs.map((documentSnapshot) => BankAccountModel.fromDocumentSnapshot(documentSnapshot)).firstOrNull;
    }catch(e){
      print('${e.toString()}');
      throw 'Something went wrong while fetching Address Information. Try again later';
    }
  }

  /// Function to fetch user details based on user ID.
  Future<UserModel> fetchAdminDetails() async {
    try {
      final userId = AuthenticationRepository.instance.getUserID;
      final row = await supabase.from(_usersTable).select().eq('id', userId).maybeSingle();
      if (row != null) {
        return UserModel.fromJson(flattenRow(Map<String, dynamic>.from(row)), id: userId);
      }
      return UserModel.empty();
    } catch (_) {
      // Fallback during migration.
    }

    try {
      final documentSnapshot = await _db.collection("Users").doc(AuthenticationRepository.instance.getUserID).get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) print('Something Went Wrong: $e');
      throw 'Something Went Wrong: $e';
    }
  }

  /// Function to fetch user details based on user ID.
  Future<List<OrderModel>> fetchUserOrders(String userId) async {
    try {
      final rows = await supabase.from(_ordersTable).select().eq('user_id', userId);
      return (rows as List)
          .map((e) => flattenRow(Map<String, dynamic>.from(e)))
          .map((json) => OrderModel.fromJson(json))
          .toList();
    } catch (_) {
      // Fallback during migration.
    }

    try {
      final documentSnapshot = await _db.collection("Orders").where('userId', isEqualTo: userId).get();
      return documentSnapshot.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) print('Something Went Wrong: $e');
      throw 'Something Went Wrong: $e';
    }
  }

  /// Function to update user data in Firestore.
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      await supabase.from(_usersTable).upsert({'id': updatedUser.id, 'data': updatedUser.toJson()});
      return;
    } catch (_) {
      // Fallback during migration.
    }

    try {
      await _db.collection("Users").doc(updatedUser.id).update(updatedUser.toJson());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Update any field in specific Users Collection
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      final userId = AuthenticationRepository.instance.getUserID;
      final row = await supabase.from(_usersTable).select('data').eq('id', userId).maybeSingle();
      final data = Map<String, dynamic>.from(row?['data'] ?? {});
      data.addAll(json);
      await supabase.from(_usersTable).upsert({'id': userId, 'data': data});
      return;
    } catch (_) {
      // Fallback during migration.
    }

    try {
      await _db.collection("Users").doc(AuthenticationRepository.instance.getUserID).update(json);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }



  /// Delete User Data
  Future<void> deleteUser(String id) async {
    try {
      await supabase.from(_usersTable).delete().eq('id', id);
      return;
    } catch (_) {
      // Fallback during migration.
    }

    try {
      await _db.collection("Users").doc(id).delete();
    } on FirebaseException catch (e) {
      throw e.message!;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
