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

  /// Factory method to create a StatusModel from a Firebase document snapshot.
  factory StatusModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return StatusModel(
      id: snapshot.id,
      deviceId: data.containsKey('deviceId') ? data['deviceId'] as String : '',
      noOfVisits: data.containsKey('noOfVisits') ? data['noOfVisits'] as int : 0,
    );
  }
}
