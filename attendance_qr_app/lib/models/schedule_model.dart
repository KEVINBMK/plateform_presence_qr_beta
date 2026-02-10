import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleModel {
  final String id;
  final String nomCours;
  final String qrToken;
  final String createdBy;
  final DateTime? dateHeure;
  final DateTime? qrExpires;
  final bool isActive;

  ScheduleModel({
    required this.id,
    required this.nomCours,
    required this.qrToken,
    required this.createdBy,
    this.dateHeure,
    this.qrExpires,
    this.isActive = true,
  });

  // Créer depuis Firestore
  factory ScheduleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ScheduleModel(
      id: doc.id,
      nomCours: data['nomCours'] ?? '',
      qrToken: data['qrToken'] ?? '',
      createdBy: data['createdBy'] ?? '',
      dateHeure: (data['dateHeure'] as Timestamp?)?.toDate(),
      qrExpires: (data['qrExpires'] as Timestamp?)?.toDate(),
      isActive: data['isActive'] ?? true,
    );
  }

  // Convertir en Map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nomCours': nomCours,
      'qrToken': qrToken,
      'createdBy': createdBy,
      'dateHeure': dateHeure != null ? Timestamp.fromDate(dateHeure!) : FieldValue.serverTimestamp(),
      'qrExpires': qrExpires != null ? Timestamp.fromDate(qrExpires!) : null,
      'isActive': isActive,
    };
  }

  // Vérifier si le QR code est expiré
  bool get isExpired {
    if (qrExpires == null) return false;
    return DateTime.now().isAfter(qrExpires!);
  }
}

