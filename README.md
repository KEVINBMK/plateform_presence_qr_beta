# Plateforme de Présence QR Code - Version Beta

Projet de Groupe L4 - 10 Développeurs  
Stack: Firebase + Flutter  
Deadline: 3 JOURS

## Vue d'Ensemble

Application mobile pour gérer les présences universitaires via QR codes.

Version Beta = Proof of Concept minimal en 3 jours.

### Fonctionnalités
- Login (prof/étudiant)
- Prof: créer séance et générer QR code
- Étudiant: scanner QR code
- Enregistrement présence en BDD
- Liste des présents par séance

## Structure du Projet

```
plateforme_presence_qr_beta/
├── README.md
├── PLAN_MVP.md
├── TACHES_3JOURS.md
├── firebase_config.example
└── attendance_qr_app/        # Flutter App
```

## Organisation de l'Équipe

### Firebase (2 dev)
- Dev 1: Lead Firebase - Config, Auth, Firestore
- Dev 2: Firestore Rules

### Mobile (8 dev)
- Dev 3: Lead Mobile + Architecture
- Dev 4: Firebase Auth Integration
- Dev 5: Interface Login
- Dev 6: Interface Prof
- Dev 7: Scanner QR Étudiant
- Dev 8: Firestore CRUD
- Dev 9: UI/UX + Navigation
- Dev 10: Tests + QA

## Technologies

### Backend
- Firebase Auth
- Cloud Firestore

### Mobile
- Flutter 3.x
- firebase_core, firebase_auth, cloud_firestore
- mobile_scanner, qr_flutter
- provider

## Installation

### Prérequis
- Flutter 3.x
- Compte Firebase
- VS Code ou Android Studio

### Firebase Setup

1. Créer projet sur Firebase Console (https://console.firebase.google.com)
2. Activer Authentication (Email/Password)
3. Créer Firestore (mode test)
4. Télécharger google-services.json
5. Télécharger GoogleService-Info.plist

### Flutter App

```bash
cd attendance_qr_app

flutter pub get

# Placer google-services.json dans android/app/
# Placer GoogleService-Info.plist dans ios/Runner/

flutter run

flutter build apk --release
```

## Modèle Firestore

### users
```javascript
{
  uid: "firebase_auth_uid",
  email: "prof@upc.cd",
  nom: "Kabongo",
  prenom: "Jean",
  role: "PROF" | "ETUDIANT"
}
```

### schedules
```javascript
{
  id: "auto_generated",
  nomCours: "Math Info",
  createdBy: "user_uid",
  dateHeure: Timestamp,
  qrToken: "random_string"
}
```

### attendances
```javascript
{
  id: "auto_generated",
  scheduleId: "schedule_id",
  userId: "user_uid",
  userName: "Jean Kabongo",
  timestamp: Timestamp
}
```

## Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
    
    match /schedules/{scheduleId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && 
                       get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'PROF';
    }
    
    match /attendances/{attendanceId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
    }
  }
}
```

## Tests

```bash
flutter test
```

Tester manuellement dans Firebase Console:
- Auth
- Firestore rules
- Monitoring requêtes

## Documentation

- [PLAN_MVP.md](PLAN_MVP.md) - Plan 3 jours
- [TACHES_3JOURS.md](TACHES_3JOURS.md) - Tâches par personne
- firebase_config.example - Config Firebase

## Setup Rapide

```bash
cd attendance_qr_app
flutter pub get

# Configurer Firebase (voir Installation)

flutter run
```

## Planning

Jour 1: Auth + Setup  
Jour 2: QR codes + Scan  
Jour 3: Tests + Démo

Voir [TACHES_3JOURS.md](TACHES_3JOURS.md)

## Contact

Chef de Projet: Kevin  
Email: bitubishakevin5@gmail.com  
Repo: https://github.com/KEVINBMK/plateform_presence_qr_beta

Licence: MIT  
Université Protestante au Congo
