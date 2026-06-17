import 'package:cloud_firestore/cloud_firestore.dart';

class StatusModel {
  final String id;
  final String deviceId;
  final int noOfVisits;

  StatusModel({
    required this.id,
    this.deviceId = '',
    this.noOfVisits = 0,
  });

  /// Static function to create an empty user model.
  static StatusModel empty() => StatusModel(id: '');

  /// Convert model to JSON structure for storing data in Firebase.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deviceId': deviceId,
      'noOfVisits': noOfVisits,
    };
  }

  factory StatusModel.fromJson(Map<String, dynamic> data, {String? id}) {
    return StatusModel(
      id: id ?? data['id']?.toString() ?? '',
      deviceId: data.containsKey('deviceId') ? data['deviceId'] as String : '',
      noOfVisits: data.containsKey('noOfVisits') ? data['noOfVisits'] as int : 0,
    );
  }

  /// Factory method to create a StatusModel from a Firebase document snapshot.
  factory StatusModel.fromSnapshot(DocumentSnapshot snapshot) {
    return StatusModel.fromJson(snapshot.data() as Map<String, dynamic>? ?? {}, id: snapshot.id);
  }
}
