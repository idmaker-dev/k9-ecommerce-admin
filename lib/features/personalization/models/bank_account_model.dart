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

  // Empty constructor
  BankAccountModel.empty()
      : id = '',
        accountNumber = null,
        accountHolderName = null,
        bankName = null,
        branchName = null,
        ifscCode = null;

  Map<String, dynamic> toJson() => {
        "Id": id,
        "AccountNumber": accountNumber,
        "AccountHolderName": accountHolderName,
        "BankName": bankName
      };

  factory BankAccountModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return BankAccountModel(
        id: snapshot.id,
        accountNumber: data["AccountNumber"],
        accountHolderName: data["AccountHolderName"],
        bankName: data["BankName"]);
  }
}
