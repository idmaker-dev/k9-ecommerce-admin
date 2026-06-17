import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/supabase/supabase_client.dart';
import '../../../features/personalization/models/setting_model.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

/// Repository class for setting-related operations.
class SettingsRepository extends GetxController {
  static SettingsRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _settingsDocId = 'GLOBAL_SETTINGS';
  static const String _settingsTable = 'settings';

  Future<void> _upsertSupabaseSettings(Map<String, dynamic> payload) async {
    await supabase.from(_settingsTable).upsert({'id': _settingsDocId, 'data': payload});
  }

  Future<Map<String, dynamic>?> _getSupabaseSettingsData() async {
    final row = await supabase.from(_settingsTable).select().eq('id', _settingsDocId).maybeSingle();
    if (row == null) return null;
    return flattenRow(Map<String, dynamic>.from(row));
  }

  /// Function to save setting data to Firestore.
  Future<void> registerSettings(SettingsModel setting) async {
    try {
      await _upsertSupabaseSettings(setting.toJson());
      return;
    } catch (_) {
      // Fallback during migration.
    }

    try {
      await _db.collection("Settings").doc(_settingsDocId).set(setting.toJson());
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

  /// Function to fetch setting details based on setting ID.
  Future<SettingsModel> getSettings() async {
    try {
      final data = await _getSupabaseSettingsData();
      if (data != null) {
        return SettingsModel.fromJson(data, id: _settingsDocId);
      }
    } catch (_) {
      // Fallback during migration.
    }

    try {
      final querySnapshot = await _db.collection("Settings").doc(_settingsDocId).get();
      return SettingsModel.fromSnapshot(querySnapshot);
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

  /// Function to update setting data in Firestore.
  Future<void> updateSettingDetails(SettingsModel updatedSetting) async {
    try {
      await _upsertSupabaseSettings(updatedSetting.toJson());
      return;
    } catch (_) {
      // Fallback during migration.
    }

    try {
      await _db.collection("Settings").doc(_settingsDocId).update(updatedSetting.toJson());
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

  /// Update any field in specific Settings Collection
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      final current = await _getSupabaseSettingsData() ?? {};
      current.addAll(json);
      await _upsertSupabaseSettings(current);
      return;
    } catch (_) {
      // Fallback during migration.
    }

    try {
      await _db.collection("Settings").doc(_settingsDocId).update(json);
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
}
