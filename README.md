# Plateforme de Présence QR Code - Version Beta

Projet de Groupe L4 - 10 Développeurs  
Stack: Firebase + Flutter  
Deadline: 3 JOURS

---

## Vue d'Ensemble

Application mobile permettant la gestion des présences universitaires via QR codes.

VERSION BETA = Proof of Concept minimal en 3 jours.

### Fonctionnalités (strict minimum)
- Login simple (prof/étudiant)
- Prof: créer séance et générer QR code
- Étudiant: scanner QR code
- Enregistrement présence en BDD
- Liste des présents par séance

C'est TOUT. Pas de features supplémentaires.

---

## Structure du Projet

```
plateforme_presence_qr_beta/
├── README.md                      # Ce fichier
├── PLAN_MVP.md                    # Plan complet 3 jours + stratégie
├── TACHES_3JOURS.md               # Répartition détaillée par dev
├── firebase_config.example        # Config Firebase
│
├── mobile/                        # À créer - Flutter App
└── .git/                          # Version control
```
│   │   │   ├── teacher/
│   │   │   └── student/
│   │   ├── widgets/              # Composants réutilisables
│   │   └── main.dart
│   └── test/
│
└── infrastructure/                # Config serveur
    ├── nginx.conf
    ├── docker-compose.yml
    └── deploy.sh
```

---

## Organisation de l'Équipe

### Firebase Setup (2 dev)
- Dev 1: Lead Firebase - Config projet, Auth, Firestore structure
- Dev 2: Firestore Rules + Cloud Functions (si besoin)

### Mobile Flutter (8 dev)
- Dev 3: Lead Mobile + Architecture
- Dev 4: Firebase Auth Integration
- Dev 5: Interface Login
- Dev 6: Interface Prof (créer séance + générer QR)
- Dev 7: Scanner QR Étudiant
- Dev 8: Firestore CRUD (schedules/attendances)
- Dev 9: UI/UX Polish + Navigation
- Dev 10: Tests + QA

---

## Technologies

### Backend
- Firebase Auth (authentification)
- Cloud Firestore (base de données temps réel)
- Firebase Storage (si images needed)

### Mobile
- Flutter 3.x
- firebase_core (Firebase SDK)
- firebase_auth (login)
- cloud_firestore (BDD)
- mobile_scanner (scan QR)
- qr_flutter (générer QR)
- provider (state management)

### Infra
- Firebase Console
- Git + GitHub

---

## Installation

### Prérequis
- Flutter 3.x
- Compte Firebase (gratuit)
- VS Code ou Android Studio

### Étape 1: Firebase Setup

```bash
# Aller sur Firebase Console
# https://console.firebase.google.com

# 1. Créer nouveau projet "attendance-qr"
# 2. Activer Authentication (Email/Password)
# 3. Créer base de données Firestore (mode test)
# 4. Ajouter une app Android/iOS
# 5. Télécharger google-services.json (Android)
# 6. Télécharger GoogleService-Info.plist (iOS)
```

### Étape 2: Flutter App

```bash
cd mobile

# Créer projet Flutter
flutter create .

# Installer dépendances Firebase
flutter pub add firebase_core firebase_auth cloud_firestore

# Installer packages QR
flutter pub add qr_flutter mobile_scanner provider

# Placer google-services.json dans android/app/
# Placer GoogleService-Info.plist dans ios/Runner/

# Initialiser Firebase dans main.dart
# Voir firebase_config.example

# Lancer app
flutter run

# Build APK
flutter build apk --release
```

---

## Modèle de Données Firestore

### Collection: users
```
{
  uid: "firebase_auth_uid",
  email: "prof@upc.cd",
  nom: "Kabongo",
  prenom: "Jean",
  role: "PROF" | "ETUDIANT"
}
```

### Collection: schedules
```
{
  id: "auto_generated",
  nomCours: "Math Info",
  createdBy: "user_uid",
  dateHeure: Timestamp,
  qrToken: "random_string",
  qrExpires: Timestamp
}
```

### Collection: attendances
```
{
  id: "auto_generated",
  scheduleId: "schedule_id",
  userId: "user_uid",
  userName: "Jean Kabongo",
  timestamp: Timestamp
}
```

---

## Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users: lecture par tout le monde, écriture par admin
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
    
    // Schedules: profs peuvent créer, tous peuvent lire
    match /schedules/{scheduleId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && 
                       get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'PROF';
    }
    
    // Attendances: étudiants peuvent créer leur présence, tous peuvent lire
    match /attendances/{attendanceId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
    }
  }
}
```

---

## Tests

### Flutter
```bash
# Tests unitaires
flutter test

# Tests widgets
flutter test test/widgets/

# Tests intégration (si temps)
flutter drive --target=test_driver/app.dart
```

### Firebase (Console)
- Tester auth manuellement (créer users)
- Vérifier Firestore rules dans l'onglet Rules
- Monitorer les requêtes dans l'onglet Usage

---

## Documentation

### Docs Principales
- **[PLAN_MVP.md](PLAN_MVP.md)** - Plan complet MVP 3 jours
  - Objectifs et scope
  - Organisation équipe 10 dev
  - Planning jour par jour  
  - Stack technique
  - Règles de survie

- **[TACHES_3JOURS.md](TACHES_3JOURS.md)** - Tâches détaillées par personne
  - Dev 1-10 : tâches matin/aprem
  - Checklist par jour
  - Livrables attendus

### Fichiers Config
- `firebase_config.example` - Configuration Firebase pour Flutter
- Firestore Security Rules (voir section ci-dessus)

---

## Contribution

### Setup Rapide Firebase + Flutter

```bash
# 1. Créer projet Firebase Console
# 2. Activer Authentication + Firestore

# 3. Setup Flutter
cd mobile
flutter create .
flutter pub add firebase_core firebase_auth cloud_firestore
flutter pub add qr_flutter mobile_scanner provider

# 4. Config Firebase (google-services.json + GoogleService-Info.plist)
# 5. Voir TACHES_3JOURS.md pour détails

flutter run
```

---

## Planning

**Jour 1:** Auth + Setup  
**Jour 2:** QR codes + Scan  
**Jour 3:** Tests + Démo

Voir [TACHES_3JOURS.md](TACHES_3JOURS.md) pour les détails.

---

## Contact

**Repo GitHub:** https://github.com/KEVINBMK/plateform_presence_qr_beta  
**Chef de Projet:** Kevin  
**Email:** bitubishakevin5@gmail.com

---

**Licence:** MIT  
**Université:** Université Protestante au Congo

