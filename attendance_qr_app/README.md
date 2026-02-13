# Plateforme Presence QR - Application Mobile

**Developpe par Kevin - Fevrier 2026**

---

## Salut !

Bienvenue dans l'application de gestion de presence par QR Code ! Cette app a ete creee pour simplifier la prise de presence dans les cours universitaires.

---

## Demarrage Rapide

### Prerequis :
- Flutter 3.24+ installe
- Firebase CLI (pour deployer les index)
- Un projet Firebase configure

### Installation en 3 etapes :

```bash
# 1. Installer les dependances
flutter pub get

# 2. Deployer les index Firebase (IMPORTANT !)
firebase deploy --only firestore:indexes

# 3. Lancer l'app
flutter run
```

C'est tout ! L'app est prête !

---

## Fonctionnalites

### Pour les Professeurs :
- Creer des seances de cours
- Generer des QR codes uniques
- Voir les presences en temps reel
- Suivre l'historique des seances

### Pour les Etudiants :
- Scanner les QR codes
- Enregistrer automatiquement leur presence
- Consulter leur historique de presences

---

## Stack Technique

- Frontend : Flutter 3.24+ (Dart)
- Backend : Firebase (Authentication + Firestore)
- QR Code : qr_flutter + mobile_scanner
- State Management : Provider
- Date/Time : intl

---

## Structure du Projet

```
lib/
├── main.dart                 # Point d'entree de l'app
├── firebase_options.dart     # Configuration Firebase
├── models/                   # Modeles de donnees
│   ├── user_model.dart
│   ├── schedule_model.dart
│   └── attendance_model.dart
├── providers/                # Gestion d'etat
│   └── auth_provider.dart
├── screens/                  # Ecrans de l'app
│   ├── auth_wrapper.dart
│   ├── login_screen.dart
│   ├── prof_home_screen.dart
│   ├── student_home_screen.dart
│   ├── create_schedule_screen.dart
│   ├── scan_qr_screen.dart
│   └── attendance_list_screen.dart
└── services/                 # Services backend
    ├── auth_service.dart
    └── firestore_service.dart
```

---

## Scripts Utiles

### Nettoyer le projet :
```bash
.\fix_all.ps1
```
Ce script fait tout le menage : cache Flutter, cache Gradle, reconstruction complete.

### Deployer sur Firebase :
```bash
# Deployer les index
firebase deploy --only firestore:indexes

# Deployer les regles de securite
firebase deploy --only firestore:rules
```

---

## Resolution de Problemes

### Erreur : "The query requires an index"

Solution :
```bash
firebase deploy --only firestore:indexes
```
Ou clique sur le lien dans l'erreur pour creer l'index automatiquement !

### Erreur Gradle : "enableBuildCache is deprecated"

Solution :
```bash
.\fix_all.ps1
```

### L'app crash au demarrage

Verifications :
1. Firebase bien configure ? (`firebase_options.dart` existe)
2. `google-services.json` dans `android/app/` ?
3. Index Firebase deployes ?
4. Internet active ?

---

## Documentation Complete

- RAPPORT_KEVIN.md - Rapport complet des corrections et ameliorations
- COMMANDES.txt - Toutes les commandes utiles (copier-coller facile)
- LISEZMOI_URGENT.txt - Guide visuel rapide

---

## TODOs / Ameliorations Futures

- Export CSV des presences
- Notifications push pour les seances
- Mode sombre
- Statistiques de presence (graphiques)
- Gestion des retards
- Multi-langue (FR/EN)

---

## Statistiques du Projet

Lignes de code : ~2000 lignes Dart  
Fichiers : 15 ecrans/services  
Temps de dev : 3 jours  
Status : Fonctionnel et pret pour la prod !

---

## Contribution

Cette app a ete developpee dans le cadre du projet L4 - UPC.

Equipe : Kevin et l'equipe de developpement  
Date : Fevrier 2026  
Version : 1.0.0

---

## Support

Si tu rencontres un probleme :

1. Verifie d'abord RAPPORT_KEVIN.md (la plupart des solutions y sont !)
2. Regarde COMMANDES.txt pour les commandes rapides
3. Lance `.\fix_all.ps1` pour nettoyer le projet

---

## Checklist Avant de Lancer

- `flutter pub get` execute
- Index Firebase deployes
- Regles Firebase deployees
- `google-services.json` configure
- Connexion Internet active

---

Made by Kevin - UPC L4 - Fevrier 2026

L'app est prete !



