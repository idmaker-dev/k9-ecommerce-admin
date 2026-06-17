import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  String? id;
  String imageUrl;
  bool active;
  String targetScreen;

  BannerModel({this.id, required this.imageUrl, required this.targetScreen, required this.active});

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'active': active,
      'targetScreen': targetScreen,
    };
  }

  factory BannerModel.fromJson(Map<String, dynamic> data, {String? id}) {
    return BannerModel(
      id: id,
      imageUrl: data['imageUrl'] ?? '',
      active: data['active'] ?? false,
      targetScreen: data['targetScreen'] ?? '',
    );
  }

  factory BannerModel.fromSnapshot(DocumentSnapshot snapshot) {
    return BannerModel.fromJson(snapshot.data() as Map<String, dynamic>? ?? {}, id: snapshot.id);
  }
}
