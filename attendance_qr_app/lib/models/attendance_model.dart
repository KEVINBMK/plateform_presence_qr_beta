import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  final String id;
  final String scheduleId;
  final String userId;
  final String userName;
  final DateTime? timestamp;

  AttendanceModel({
    required this.id,
    required this.scheduleId,
    required this.userId,
    required this.userName,
    this.timestamp,
  });

  // Créer depuis Firestore
  factory AttendanceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AttendanceModel(
      id: doc.id,
      scheduleId: data['scheduleId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
    );
  }

  // Convertir en Map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'scheduleId': scheduleId,
      'userId': userId,
      'userName': userName,
      'timestamp': timestamp != null ? Timestamp.fromDate(timestamp!) : FieldValue.serverTimestamp(),
    };
  }
}

