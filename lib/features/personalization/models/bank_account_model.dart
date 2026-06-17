import 'package:cloud_firestore/cloud_firestore.dart';

class BankAccountModel {
  final String id;
  final String? accountNumber;
  final String? accountHolderName;
  final String? bankName;
  final String? branchName;
  final String? ifscCode;

  BankAccountModel({
    required this.id,
    this.accountNumber,
    this.accountHolderName,
    this.bankName,
    this.branchName,
    this.ifscCode,
  });

  @override
  String toString() {
    return '$accountHolderName - $bankName \nAccount: $accountNumber';
  }

  Map<String, dynamic> toJson() => {
    "Id": id,
    "AccountNumber": accountNumber,
    "AccountHolderName": accountHolderName,
    "BankName": bankName
  };

  factory BankAccountModel.fromJson(Map<String, dynamic> data, {String? id}) {
    return BankAccountModel(
      id: id ?? data['Id']?.toString() ?? data['id']?.toString() ?? '',
      accountNumber: data['AccountNumber'],
      accountHolderName: data['AccountHolderName'],
      bankName: data['BankName'],
      branchName: data['BranchName'],
      ifscCode: data['IfscCode'],
    );
  }

  factory BankAccountModel.fromDocumentSnapshot(DocumentSnapshot snapshot){
    return BankAccountModel.fromJson(snapshot.data() as Map<String, dynamic>? ?? {}, id: snapshot.id);
  }
}
