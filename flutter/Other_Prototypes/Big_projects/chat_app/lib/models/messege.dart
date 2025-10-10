import 'package:cloud_firestore/cloud_firestore.dart';

class Messege {
  final String senderID;
  final String senderEmail;
  final String recieverID;
  final String messege;
  final Timestamp timestamp;

  Messege(
      {required this.senderID,
      required this.senderEmail,
      required this.recieverID,
      required this.messege,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'recieverID': recieverID,
      'messege': messege,
      'timestamp': timestamp
    };
  }
}
