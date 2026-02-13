import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Créer une séance
  Future<String> createSchedule({
    required String nomCours,
    required String qrToken,
    required String createdBy,
  }) async {
    try {
      print('📝 Création de séance: nomCours=$nomCours, qrToken=$qrToken, createdBy=$createdBy');

      final doc = await _db.collection('schedules').add({
        'nomCours': nomCours,
        'qrToken': qrToken,
        'createdBy': createdBy,
        'dateHeure': FieldValue.serverTimestamp(),
        'qrExpires': null,
        'isActive': true,
      });

      print('✅ Séance créée avec ID: ${doc.id}');
      return doc.id;
    } catch (e) {
      print('❌ Erreur création séance: $e');
      if (e.toString().contains('permission')) {
        throw Exception('Erreur de permissions Firestore. Vérifiez vos règles de sécurité.');
      }
      throw Exception('Erreur lors de la création de la séance: $e');
    }
  }

  // Trouver séance par QR token
  Future<DocumentSnapshot?> getScheduleByQrToken(String qrToken) async {
    try {
      print('🔍 Recherche de séance avec token: $qrToken');

      final query = await _db
          .collection('schedules')
          .where('qrToken', isEqualTo: qrToken)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        print('⚠️ Aucune séance trouvée avec ce token');
        return null;
      }

      print('✅ Séance trouvée: ${query.docs.first.id}');
      return query.docs.first;
    } catch (e) {
      print('❌ Erreur recherche séance: $e');
      throw Exception('Erreur lors de la recherche de la séance: $e');
    }
  }

  // Enregistrer présence
  Future<void> markAttendance({
    required String scheduleId,
    required String userId,
    required String userName,
  }) async {
    try {
      print('📝 Enregistrement présence: scheduleId=$scheduleId, userId=$userId');

      // Vérifier si déjà présent
      final existing = await _db
          .collection('attendances')
          .where('scheduleId', isEqualTo: scheduleId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        print('⚠️ Présence déjà enregistrée');
        throw Exception('Vous avez déjà scanné ce QR Code');
      }

      // Créer présence
      await _db.collection('attendances').add({
        'scheduleId': scheduleId,
        'userId': userId,
        'userName': userName,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('✅ Présence enregistrée avec succès');
    } catch (e) {
      print('❌ Erreur enregistrement présence: $e');
      if (e.toString().contains('Vous avez déjà scanné')) {
        rethrow;
      }
      if (e.toString().contains('permission')) {
        throw Exception('Erreur de permissions. Vérifiez vos règles Firestore.');
      }
      throw Exception('Erreur lors de l\'enregistrement de la présence: $e');
    }
  }

  // Récupérer présences par séance (Stream temps réel)
  Stream<QuerySnapshot> getAttendancesBySchedule(String scheduleId) {
    print('📡 Stream présences pour séance: $scheduleId');
    return _db
        .collection('attendances')
        .where('scheduleId', isEqualTo: scheduleId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Récupérer toutes les séances d'un professeur
  Stream<QuerySnapshot> getSchedulesByProfessor(String professorId) {
    print('📡 Stream séances pour professeur: $professorId');
    return _db
        .collection('schedules')
        .where('createdBy', isEqualTo: professorId)
        .orderBy('dateHeure', descending: true)
        .snapshots();
  }
}
