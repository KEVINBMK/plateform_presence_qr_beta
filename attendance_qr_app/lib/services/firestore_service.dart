import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Créer une séance
  Future<String> createSchedule({
    required String nomCours,
    required String qrToken,
    required String createdBy,
  }) async {
    final doc = await _db.collection('schedules').add({
      'nomCours': nomCours,
      'qrToken': qrToken,
      'createdBy': createdBy,
      'dateHeure': FieldValue.serverTimestamp(),
      'qrExpires': null,
    });
    return doc.id;
  }

  // Trouver séance par QR token
  Future<DocumentSnapshot?> getScheduleByQrToken(String qrToken) async {
    final query = await _db
        .collection('schedules')
        .where('qrToken', isEqualTo: qrToken)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    return query.docs.first;
  }

  // Enregistrer présence
  Future<void> markAttendance({
    required String scheduleId,
    required String userId,
    required String userName,
  }) async {
    // Vérifier si déjà présent
    final existing = await _db
        .collection('attendances')
        .where('scheduleId', isEqualTo: scheduleId)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      throw Exception('Vous avez déjà scanné ce QR Code');
    }

    // Créer présence
    await _db.collection('attendances').add({
      'scheduleId': scheduleId,
      'userId': userId,
      'userName': userName,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Récupérer présences par séance (Stream temps réel)
  Stream<QuerySnapshot> getAttendancesBySchedule(String scheduleId) {
    return _db
        .collection('attendances')
        .where('scheduleId', isEqualTo: scheduleId)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
