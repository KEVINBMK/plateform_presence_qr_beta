# SPÉCIFICATIONS TECHNIQUES - VERSION EXPRESS
## Plateforme Présence QR - 3 Jours

**Stack:** Firebase + Flutter  
**Deadline:** 3 jours  
**Team:** 10 personnes

---

## 1. FONCTIONNALITÉS (RÉSUMÉ)

### Flow Principal
1. **Prof** → Crée séance → QR généré → Affichage
2. **Étudiant** → Scanne QR → Présence enregistrée
3. **Prof** → Liste présents (temps réel)

### Fonctions Essentielles

**Auth:**
- Login (email/password) → Firebase Auth
- Rôle stocké dans Firestore (PROF / ETUDIANT)
- Logout

**Prof:**
- Créer séance (nom cours) → Génère QR token (6 chiffres)
- Afficher QR (qr_flutter package)
- Voir liste présents (temps réel avec StreamBuilder)

**Étudiant:**
- Scanner QR (mobile_scanner package)
- Enregistrer présence si QR valide
- Empêcher double scan (contrainte unique)
- (Optionnel) Voir historique

### Règles Métier
- 1 étudiant = 1 présence max par séance
- QR token doit exister dans Firestore
- Rôles séparés (PROF ≠ ETUDIANT)

---

## 2. STACK TECHNIQUE

### Architecture
```
Flutter App (Client)
    ↓ Firebase SDK
Firebase (Backend Cloud)
    • Auth (login)
    • Firestore (BDD NoSQL)
```

### Technologies

**Flutter Packages:**
```yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  qr_flutter: ^4.1.0           # Générer QR
  mobile_scanner: ^3.5.0       # Scanner QR
  provider: ^6.1.0             # State
  intl: ^0.18.0                # Dates
```

**Firebase (Gratuit):**
- Authentication (Email/Password)
- Cloud Firestore (NoSQL temps réel)
- Security Rules
- Limites: 50k reads/jour, 20k writes/jour

---

## 3. MODÈLE FIRESTORE (3 Collections)

### users
```javascript
{
  uid: "auto",
  email: "prof@upc.cd",
  nom: "Kabongo",
  prenom: "Jean",
  role: "PROF" | "ETUDIANT"
}
```

### schedules
```javascript
{
  id: "auto",
  nomCours: "Math Info",
  createdBy: "user_uid",
  dateHeure: Timestamp,
  qrToken: "847392",     // 6 chiffres random
  qrExpires: null        // Optionnel Beta
}
```

### attendances
```javascript
{
  id: "auto",
  scheduleId: "sch_id",
  userId: "user_uid",
  userName: "Mukendi Pierre",  // Denormalized
  timestamp: Timestamp
}
```

**Index:** qrToken (schedules), scheduleId+userId (attendances)

---

## 4. FIRESTORE SECURITY RULES

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function getUserRole() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role;
    }
    
    // Collection: users
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow write: if isAuthenticated() && request.auth.uid == userId;
    }
    
    // Collection: schedules
    match /schedules/{scheduleId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated() && getUserRole() == 'PROF';
      allow update, delete: if isAuthenticated() && 
                               resource.data.createdBy == request.auth.uid;
    }
    
    // Collection: attendances
    match /attendances/{attendanceId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated() && getUserRole() == 'ETUDIANT';
      allow update, delete: if false;  // Immuable
    }
  }
}
```

---

## 5. SERVICES FLUTTER (Code Essentials)

### AuthService (`lib/services/auth_service.dart`)
```dart
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;
  
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }
  
  Future<void> signOut() async => await _auth.signOut();
}
```

### FirestoreService (`lib/services/firestore_service.dart`)
```dart
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // Créer séance
  Future<String> createSchedule(String nomCours, String qrToken, String userId) async {
    final doc = await _db.collection('schedules').add({
      'nomCours': nomCours,
      'qrToken': qrToken,
      'createdBy': userId,
      'dateHeure': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }
  
  // Chercher par QR token
  Future<DocumentSnapshot?> getScheduleByQrToken(String token) async {
    final query = await _db.collection('schedules')
      .where('qrToken', isEqualTo: token).limit(1).get();
    return query.docs.isEmpty ? null : query.docs.first;
  }
  
  // Enregistrer présence (avec vérif doublon)
  Future<void> markAttendance(String scheduleId, String userId, String userName) async {
    final existing = await _db.collection('attendances')
      .where('scheduleId', isEqualTo: scheduleId)
      .where('userId', isEqualTo: userId).limit(1).get();
    
    if (existing.docs.isNotEmpty) throw Exception('Déjà scanné');
    
    await _db.collection('attendances').add({
      'scheduleId': scheduleId,
      'userId': userId,
      'userName': userName,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
  
  // Stream temps réel
  Stream<QuerySnapshot> getAttendances(String scheduleId) {
    return _db.collection('attendances')
      .where('scheduleId', isEqualTo: scheduleId)
      .orderBy('timestamp').snapshots();
  }
}
```

---

## 6. CONFIGURATION

### Permissions Android (`AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
```

### Permissions iOS (`Info.plist`)
```xml
<key>NSCameraUsageDescription</key>
<string>Scanner QR Codes de présence</string>
```

### Firebase Init (`main.dart`)
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
```

---

## 7. BUILD & DÉPLOIEMENT

**Build APK Release:**
```bash
flutter build apk --release
```

**Fichier:** `build/app/outputs/flutter-apk/app-release.apk`

**Distribution:** Google Drive / Email (installation manuelle)

---

## 8. PLAN D'ACTION 3 JOURS

**Jour 1:**
- Setup Firebase projet
- Login screen + Auth
- Collections Firestore + Rules

**Jour 2:**
- Créer séance + QR display (Prof)
- Scanner + enregistrer présence (Étudiant)

**Jour 3:**
- Liste présents temps réel
- Tests multi-devices
- Build APK

---

**FIN - Specs Version Express • 3 Jours • Keep It Simple**
