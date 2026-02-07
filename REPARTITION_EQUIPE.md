# Répartition de l'Équipe - Plateforme Présence QR

**Projet:** Application mobile de gestion des présences par QR Code  
**Effectif:** 10 personnes  
**Durée:** 3 jours  
**Stack:** Firebase + Flutter

---

## Équipe Développement (4 personnes)

### Kevin - Lead Technique & Full-Stack
**Responsabilités:**
- Architecture globale du projet
- Setup Firebase (Auth, Firestore, Rules)
- Intégration Firebase SDK dans Flutter
- Coordination technique de l'équipe
- Code review et merge
- Résolution des bugs critiques

**Livrables:**
- Configuration Firebase complète
- Service Auth Firebase
- Architecture projet Flutter
- Documentation technique

---

### Melvin - Full-Stack Backend
**Responsabilités:**
- Structure Firestore (collections, documents)
- Firestore Security Rules
- Service Firestore (CRUD schedules/attendances)
- Optimisation queries et index
- Tests backend

**Livrables:**
- Collections Firestore configurées
- Security Rules en production
- Service firestore_service.dart
- Documentation Firestore

---

### Magloir - Développeur Mobile
**Responsabilités:**
- Écrans Flutter (Login, Prof Home, Student Home)
- Navigation entre écrans
- State management (Provider)
- Intégration services Firebase
- Tests fonctionnels

**Livrables:**
- Écrans principaux Flutter
- Navigation complète
- Providers configurés
- Tests manuels app

---

### Jonathan - Développeur Front-End
**Responsabilités:**
- UI/UX des écrans
- Composants réutilisables (widgets)
- Intégration packages QR (qr_flutter, mobile_scanner)
- Scanner QR + Génération QR
- Polish UI final

**Livrables:**
- Interface utilisateur complète
- Scanner QR fonctionnel
- Génération QR codes
- Widgets réutilisables

---

## Équipe Design (1 personne)

### Dieuvie - Designer UI/UX
**Responsabilités:**
- Maquettes des écrans (Figma/Adobe XD)
- Design system (couleurs, typographie, icônes)
- Wireframes basse/haute fidélité
- Prototypes interactifs
- Guide de style

**Livrables:**
- Maquettes Figma/XD des 5-6 écrans
- Design system documenté
- Assets (logos, icônes)
- Guide d'utilisation UI

---

## Équipe Analyse (1 personne)

### Guyf - Analyste Fonctionnel
**Responsabilités:**
- Analyse du sujet et des besoins
- Rédaction cahier des charges
- Identification des contraintes
- Spécifications fonctionnelles
- Validation des user stories

**Livrables:**
- Cahier des charges complet
- Spécifications fonctionnelles
- Document d'analyse des besoins
- User stories validées

---

## Équipe Documentation (4 personnes)

### JoMab - Responsable Documentation & Rapport Principal
**Responsabilités:**
- Rédaction rapport de projet (structure complète)
- Sections: Introduction, Contexte, Méthodologie
- Diagramme de Gantt (Excel/Word ou Mermaid)
- Relecture et cohérence générale
- Mise en forme finale du rapport

**Livrables:**
- Rapport de projet (50-70% du contenu)
- Diagramme de Gantt
- Table des matières
- Document final formaté

---

### Chris - Documentation Technique & Architecture
**Responsabilités:**
- Section Architecture logicielle du rapport
- Diagrammes UML (cas d'utilisation, classes, séquence)
- Documentation technique (API Firestore, Firebase)
- Schéma base de données Firestore
- Annexes techniques

**Livrables:**
- Diagrammes UML complets
- Section Architecture (rapport)
- Documentation API Firebase
- Schémas techniques

---

### Kitenge - Spécifications & Tests
**Responsabilités:**
- Spécifications techniques détaillées
- Plan de tests (scénarios, cas de test)
- Documentation des tests effectués
- Section Tests & Validation (rapport)
- Tableau des résultats de tests

**Livrables:**
- Spécifications techniques
- Plan de tests complet
- Rapport de tests
- Section Tests (rapport)

---

### Kerene - Guide Utilisateur & Conclusion
**Responsabilités:**
- Guide utilisateur (Prof et Étudiant)
- Screenshots de l'application
- Section Résultats & Discussion (rapport)
- Conclusion et perspectives
- Bibliographie et références

**Livrables:**
- Guide utilisateur illustré
- Section Résultats (rapport)
- Conclusion (rapport)
- Bibliographie

---

## Planning des Livrables

### Jour 1
- **Dev (Kevin, Melvin, Magloir, Jonathan):** Setup Firebase + Auth + Navigation
- **Guyf:** Cahier des charges + Spécifications fonctionnelles
- **Dieuvie:** Maquettes Figma (5-6 écrans)
- **JoMab:** Structure rapport + Introduction + Gantt
- **Chris:** Diagrammes UML (cas d'utilisation)
- **Kitenge:** Plan de tests initial
- **Kerene:** Début guide utilisateur

### Jour 2
- **Dev:** Flow QR complet (création séance → scan → présence)
- **Guyf:** Finaliser cahier des charges, aider documentation
- **Dieuvie:** Design system, assets, polish maquettes
- **JoMab:** Sections Contexte + Méthodologie (rapport)
- **Chris:** Diagrammes classes + séquence, architecture
- **Kitenge:** Spécifications techniques + tests en cours
- **Kerene:** Guide utilisateur (screenshots dev)

### Jour 3
- **Dev:** Polish final + Build APK + Tests
- **Guyf:** Relecture cahier des charges + specs
- **Dieuvie:** Screenshots finaux + mise en forme assets
- **JoMab:** Gantt final + relecture rapport complet
- **Chris:** Finaliser architecture + schémas techniques
- **Kitenge:** Rapport de tests + section Tests (rapport)
- **Kerene:** Finaliser guide + Conclusion + Bibliographie

---

## Matrice de Responsabilités (RACI)

| Livrable | Kevin | Melvin | Magloir | Jonathan | Dieuvie | Guyf | JoMab | Chris | Kitenge | Kerene |
|----------|-------|--------|---------|----------|---------|------|-------|-------|---------|--------|
| **Code Firebase** | R | C | I | I | - | - | - | - | - | - |
| **Code Flutter** | A | C | R | R | C | - | - | - | - | - |
| **UI/UX Design** | I | - | C | C | R | - | - | - | - | I |
| **Cahier des charges** | C | - | - | - | - | R | C | - | C | - |
| **Specs techniques** | C | C | - | - | - | C | I | I | R | - |
| **Diagrammes UML** | C | - | - | - | - | I | I | R | C | - |
| **Gantt** | I | - | - | - | - | C | R | - | - | - |
| **Rapport projet** | I | I | I | I | C | C | R | C | C | C |
| **Guide utilisateur** | I | - | I | I | C | - | C | - | - | R |
| **Tests** | C | C | C | C | - | - | I | - | R | I |

**Légende:**
- **R** (Responsible): Réalise la tâche
- **A** (Accountable): Responsable final
- **C** (Consulted): Consulté
- **I** (Informed): Informé

---

## Communication & Coordination

### Réunions quotidiennes (Daily Standup)
- **Matin 9h:** 10 min - Point de la journée
- **Soir 17h:** 10 min - Bilan + blocages

### Outils collaboration
- **Code:** GitHub (https://github.com/KEVINBMK/plateform_presence_qr_beta)
- **Documentation:** Google Docs partagé
- **Design:** Figma partagé
- **Communication:** WhatsApp/Discord groupe

### Points de synchronisation
- **Kevin ↔ Melvin/Magloir/Jonathan:** Code review quotidien
- **Guyf ↔ JoMab/Chris/Kitenge:** Cohérence docs chaque soir
- **Dieuvie ↔ Jonathan:** Validation UI matin + soir
- **JoMab:** Centralise tous les documents finaux

---

**Chef de Projet:** Kevin (coordination globale)  
**Responsable Doc:** JoMab (centralisation livrables)  
**QA:** Kitenge (validation tests)
