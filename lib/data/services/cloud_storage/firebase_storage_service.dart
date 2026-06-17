import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service class for Supabase Storage operations
class TFirebaseStorageService extends GetxController {
  static TFirebaseStorageService get instance => Get.find();

  final _storage = Supabase.instance.client.storage;

  static const _knownBuckets = {'products', 'categories', 'brands', 'banners', 'users'};

  String _bucketFor(String path) {
    final first = path.split('/').first;
    return _knownBuckets.contains(first) ? first : 'products';
  }

  /// Reads a local asset and returns its bytes.
  Future<Uint8List> getImageDataFromAssets(String path) async {
    try {
      final byteData = await rootBundle.load(path);
      return byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    } catch (e) {
      throw 'Error loading image data: $e';
    }
  }

  /// Uploads raw bytes to Supabase Storage.
  /// Returns the public URL of the uploaded image.
  Future<String> uploadImageData(String path, Uint8List image, String name) async {
    try {
      final bucket = _bucketFor(path);
      final objectPath = '$path/$name';
      await _storage.from(bucket).uploadBinary(
            objectPath,
            image,
            fileOptions: const FileOptions(upsert: true),
          );
      return _storage.from(bucket).getPublicUrl(objectPath);
    } catch (e) {
      if (e is StorageException) {
        throw 'Storage Exception: ${e.message}';
      } else if (e is SocketException) {
        throw 'Network Error: ${e.message}';
      } else {
        throw 'Something went wrong! Please try again.';
      }
    }
  }

  /// Uploads a file to Supabase Storage.
  /// Returns the public URL of the uploaded image.
  Future<String> uploadImageFile(String path, XFile image) async {
    try {
      final bucket = _bucketFor(path);
      final objectPath = '$path/${image.name}';
      await _storage.from(bucket).upload(
            objectPath,
            File(image.path),
            fileOptions: const FileOptions(upsert: true),
          );
      return _storage.from(bucket).getPublicUrl(objectPath);
    } catch (e) {
      if (e is StorageException) {
        throw 'Storage Exception: ${e.message}';
      } else if (e is SocketException) {
        throw 'Network Error: ${e.message}';
      } else {
        throw 'Something went wrong! Please try again.';
      }
    }
  }
}