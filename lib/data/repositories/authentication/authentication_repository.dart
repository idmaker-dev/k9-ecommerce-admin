import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../../routes/routes.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  // Variables
  final _auth = FirebaseAuth.instance;
  final _supabase = sb.Supabase.instance.client;
  final bool _useSupabaseAuth = const bool.fromEnvironment('USE_SUPABASE_AUTH', defaultValue: true);

  // Get Authenticated User Data
  dynamic get authUser => _supabase.auth.currentUser ?? _auth.currentUser;

  String get getUserID => _supabase.auth.currentUser?.id ?? _auth.currentUser?.uid ?? '';

  // Get IsAuthenticated User
  bool get isAuthenticated => _supabase.auth.currentUser != null || _auth.currentUser != null;

  // Called from main.dart on app launch
  @override
  void onReady() {
    if (!_useSupabaseAuth) {
      _auth.setPersistence(Persistence.LOCAL);
    }
    // Redirect to the appropriate screen
    // screenRedirect();
  }

  // Function to determine the relevant screen and redirect accordingly.
  void screenRedirect() async {
    final user = _supabase.auth.currentUser ?? _auth.currentUser;

    // If the user is logged in
    if (user != null) {
      // Navigate to the Home
      Get.offAllNamed(TRoutes.dashboard);
    } else {
      Get.offAllNamed(TRoutes.login);
    }
  }

  // Email & Password sign-in

  // LOGIN
  Future<dynamic> loginWithEmailAndPassword(String email, String password) async {
    try {
      if (_useSupabaseAuth) {
        final response = await _supabase.auth.signInWithPassword(email: email, password: password);
        if (response.user == null) throw 'No se pudo iniciar sesión con Supabase.';
        return response;
      }
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on sb.AuthException catch (e) {
      throw e.message;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // REGISTER
  Future<dynamic> registerWithEmailAndPassword(String email, String password) async {
    try {
      if (_useSupabaseAuth) {
        final response = await _supabase.auth.signUp(email: email, password: password);
        if (response.user == null) throw 'No se pudo crear la cuenta en Supabase.';
        return response;
      }
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on sb.AuthException catch (e) {
      throw e.message;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // REGISTER USER BY ADMIN
  Future<dynamic> registerUserByAdmin(String email, String password) async {
    try {
      if (_useSupabaseAuth) {
        final response = await _supabase.auth.admin.createUser(
          sb.AdminUserAttributes(email: email, password: password, emailConfirm: true),
        );
        if (response.user == null) throw 'No se pudo registrar el usuario desde admin.';
        return response;
      }
      FirebaseApp app = await Firebase.initializeApp(name: 'RegisterUser', options: Firebase.app().options);
      UserCredential userCredential =
      await FirebaseAuth.instanceFor(app: app).createUserWithEmailAndPassword(email: email, password: password);

      await app.delete();
      return userCredential;
    } on sb.AuthException catch (e) {
      throw e.message;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification() async {
    try {
      if (_useSupabaseAuth) {
        final email = _supabase.auth.currentUser?.email;
        if (email != null && email.isNotEmpty) {
          await _supabase.auth.resend(type: sb.OtpType.signup, email: email);
        }
        return;
      }
      await _auth.currentUser?.sendEmailVerification();
    } on sb.AuthException catch (e) {
      throw e.message;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // FORGET PASSWORD
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      if (_useSupabaseAuth) {
        await _supabase.auth.resetPasswordForEmail(email);
        return;
      }
      await _auth.sendPasswordResetEmail(email: email);
    } on sb.AuthException catch (e) {
      throw e.message;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // RE AUTHENTICATE USER
  Future<void> reAuthenticateWithEmailAndPassword(String email, String password) async {
    try {
      if (_useSupabaseAuth) {
        await _supabase.auth.signInWithPassword(email: email, password: password);
        return;
      }
      // Create a credential
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);

      // ReAuthenticate
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } on sb.AuthException catch (e) {
      throw e.message;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


  // Logout User
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed(TRoutes.login);
    } on sb.AuthException catch (e) {
      if (kDebugMode) print(e);
      throw e.message;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print(e);
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      if (kDebugMode) print(e);
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      if (kDebugMode) print('Format Exception Caught');
      throw const TFormatException();
    } on PlatformException catch (e) {
      if (kDebugMode) print(e);
      throw TPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) print(e);
      throw 'Something went wrong. Please try again';
    }
  }

  // DELETE USER - Remove user Auth and Firestore Account.
  Future<void> deleteAccount() async {
    try {
      // await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
      await _supabase.auth.signOut();
    } on sb.AuthException catch (e) {
      throw e.message;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}