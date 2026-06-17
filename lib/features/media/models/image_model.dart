import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cwt_ecommerce_admin_panel/utils/formatters/formatter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:universal_html/html.dart';

/// Model class representing user data.
class ImageModel {
  String id;
  final String url;
  final String folder;
  final int? sizeBytes;
  String mediaCategory;
  final String filename;
  final String? fullPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? contentType;

  // Not Mapped
  final File? file;
  RxBool isSelected = false.obs;
  final Uint8List? localImageToDisplay;

  /// Constructor for ImageModel.
  ImageModel({
    this.id = '',
    required this.url,
    required this.folder,
    required this.filename,
    this.sizeBytes,
    this.fullPath,
    this.createdAt,
    this.updatedAt,
    this.contentType,
    this.file,
    this.localImageToDisplay,
    this.mediaCategory = '',
  });

  /// Static function to create an empty user model.
  static ImageModel empty() => ImageModel(url: '', folder: '', filename: '');

  String get createdAtFormatted => TFormatter.formatDate(createdAt);

  String get updatedAtFormatted => TFormatter.formatDate(updatedAt);

  /// Convert to Json to Store in DB
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'folder': folder,
      'sizeBytes': sizeBytes,
      'filename': filename,
      'fullPath': fullPath,
      'createdAt': createdAt?.toUtc(),
      'contentType': contentType,
      'mediaCategory': mediaCategory,
    };
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  factory ImageModel.fromJson(Map<String, dynamic> data, {String? id}) {
    if (data.isEmpty) return ImageModel.empty();
    return ImageModel(
      id: id ?? data['id']?.toString() ?? '',
      url: data['url'] ?? '',
      folder: data['folder'] ?? '',
      sizeBytes: data['sizeBytes'] ?? 0,
      filename: data['filename'] ?? '',
      fullPath: data['fullPath'] ?? '',
      createdAt: _parseDate(data['createdAt']),
      updatedAt: _parseDate(data['updatedAt']),
      contentType: data['contentType'] ?? '',
      mediaCategory: data['mediaCategory'] ?? '',
    );
  }

  /// Convert Firestore Json and Map on Model
  factory ImageModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    return ImageModel.fromJson(document.data() ?? {}, id: document.id);
  }

  /// Map Firebase Storage Data
  factory ImageModel.fromFirebaseMetadata(FullMetadata metadata, String folder, String filename, String downloadUrl) {
    return ImageModel(
      url: downloadUrl,
      folder: folder,
      filename: filename,
      sizeBytes: metadata.size,
      updatedAt: metadata.updated,
      fullPath: metadata.fullPath,
      createdAt: metadata.timeCreated,
      contentType: metadata.contentType,
    );
  }
}
