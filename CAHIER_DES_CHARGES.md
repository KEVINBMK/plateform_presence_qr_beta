# CAHIER DES CHARGES
## Plateforme de Gestion des Présences par QR Code

**Client:** Université Protestante au Congo (UPC)  
**Équipe Projet:** Groupe L4 Informatique (10 développeurs)  
**Date:** Février 2026  
**Version:** 1.0

---

## 1. CONTEXTE ET ENJEUX

### 1.1 Contexte général

L'Université Protestante au Congo (UPC) fait face à des défis significatifs dans la gestion des présences
 des étudiants lors des cours. Le système actuel, basé sur des feuilles d'émargement papier, présente plusieurs problèmes :

- **Inefficacité:** Perte de temps en début de cours (5-10 minutes par séance)
- **Fraude:** Signatures multiples, présences fictives
- **Difficultés de suivi:** Compilation manuelle des présences chronophage
- **Perte de données:** Feuilles perdues ou illisibles
- **Pas de statistiques:** Impossibilité d'analyses en temps réel

### 1.2 Problématique

Comment moderniser le système de gestion des présences universitaires pour le rendre :
- **Rapide:** Moins de 30 secondes par étudiant
- **Fiable:** Impossibilité de tricher
- **Traçable:** Historique complet et consultable
- **Économique:** Pas d'infrastructure lourde

### 1.3 Opportunités

- **100% des étudiants** possèdent un smartphone
- Infrastructure WiFi disponible sur le campus
- Forte adoption des technologies mobiles par la génération actuelle
- Gratuité des services Firebase (jusqu'à 50 000 lectures/jour)

---

## 2. OBJECTIFS DU PROJET

### 2.1 Objectif principal

Développer une **application mobile** permettant l'enregistrement automatique des présences via la technologie QR Code, connectée à une base de données temps réel Firebase.

### 2.2 Objectifs spécifiques

**Pour les enseignants:**
1. Créer des séances de cours avec génération automatique de QR Code unique
2. Visualiser en temps réel la liste des étudiants présents
3. Consulter l'historique des présences par cours

**Pour les étudiants:**
4. Scanner le QR Code affiché en classe pour enregistrer sa présence
5. Consulter son historique personnel de présences
6. Recevoir une confirmation immédiate de l'enregistrement

**Pour l'administration:**
7. Centraliser toutes les données de présence dans une base sécurisée
8. Garantir la traçabilité et l'intégrité des données
9. Permettre des analyses futures (taux de présence, assiduité, etc.)

---

## 3. PÉRIMÈTRE DU PROJET

### 3.1 Inclus dans la version Beta (3 jours)

#### Fonctionnalités essentielles

**Authentification:**
- Login par email/mot de passe (Firebase Auth)
- Distinction Prof / Étudiant
- Gestion de session persistante

**Gestion des séances (Enseignant):**
- Création de séance avec nom du cours
- Génération automatique d'un QR Code unique
- Affichage du QR Code en plein écran
- Liste des présents en temps réel

**Enregistrement de présence (Étudiant):**
- Scanner QR Code via caméra smartphone
- Validation automatique du code
- Enregistrement dans Firebase Firestore
- Notification de succès/échec

**Consultation:**
- Liste des présences par séance
- Affichage du nom et de l'heure d'enregistrement

#### Stack technique

- **Backend:** Firebase (Authentication + Firestore + Cloud Functions si nécessaire)
- **Frontend:** Flutter (application mobile multiplateforme)
- **QR:** qr_flutter (génération), mobile_scanner (scan)
- **Infrastructure:** Firebase Console (gratuit)

### 3.2 Exclus de la version Beta

**Non prioritaires pour le POC:**
- Interface web (administration)
- Export CSV/PDF des présences
- Statistiques et graphiques avancés
- Géolocalisation (vérifier que l'étudiant est sur le campus)
- Notifications push
- Gestion multi-campus
- Mode hors ligne
- Historique complet par étudiant
- Dashboard administration complexe

**Report en version future:**
- Intégration avec système de notation
- API pour systèmes tiers
- Reconnaissance faciale
- Planification automatique des cours
- Gestion des absences justifiées

---

## 4. EXIGENCES FONCTIONNELLES

### 4.1 Gestion des utilisateurs

| ID | Exigence | Priorité | Acteur |
|----|----------|----------|--------|
| RF-01 | L'utilisateur doit pouvoir se connecter avec email/mot de passe | Critique | Prof, Étudiant |
| RF-02 | Le système doit distinguer le rôle (PROF / ETUDIANT) | Critique | Système |
| RF-03 | La session doit persister entre les fermetures de l'app | Haute | Tous |
| RF-04 | L'utilisateur doit pouvoir se déconnecter | Moyenne | Tous |

### 4.2 Gestion des séances (Enseignant)

| ID | Exigence | Priorité | Acteur |
|----|----------|----------|--------|
| RF-05 | Le prof doit pouvoir créer une nouvelle séance | Critique | Prof |
| RF-06 | La séance doit contenir au minimum : nom du cours, date/heure | Critique | Prof |
| RF-07 | Un QR Code unique doit être généré automatiquement | Critique | Système |
| RF-08 | Le QR Code doit s'afficher en plein écran pour faciliter le scan | Haute | Prof |
| RF-09 | Le prof doit voir la liste des présents en temps réel | Haute | Prof |
| RF-10 | Le prof doit pouvoir consulter l'historique de ses séances | Moyenne | Prof |

### 4.3 Enregistrement de présence (Étudiant)

| ID | Exigence | Priorité | Acteur |
|----|----------|----------|--------|
| RF-11 | L'étudiant doit pouvoir scanner un QR Code | Critique | Étudiant |
| RF-12 | Le système doit vérifier la validité du QR Code | Critique | Système |
| RF-13 | La présence doit être enregistrée automatiquement si QR valide | Critique | Système |
| RF-14 | L'étudiant doit recevoir une confirmation visuelle | Haute | Étudiant |
| RF-15 | Un étudiant ne peut scanner qu'une seule fois par séance | Critique | Système |
| RF-16 | L'étudiant doit voir un message d'erreur si QR invalide/déjà scanné | Haute | Étudiant |

### 4.4 Consultation et historique

| ID | Exigence | Priorité | Acteur |
|----|----------|----------|--------|
| RF-17 | Le système doit afficher la liste des présents pour une séance | Critique | Prof |
| RF-18 | Chaque présence doit afficher : nom, prénom, heure | Haute | Prof |
| RF-19 | L'étudiant doit pouvoir consulter son historique de présences | Moyenne | Étudiant |

---

## 5. EXIGENCES NON FONCTIONNELLES

### 5.1 Performance

| ID | Exigence | Critère de succès |
|----|----------|-------------------|
| RNF-01 | Temps de scan QR | < 2 secondes |
| RNF-02 | Enregistrement présence | < 3 secondes |
| RNF-03 | Chargement liste présents | < 5 secondes |
| RNF-04 | Mise à jour temps réel | < 2 secondes après scan |

### 5.2 Sécurité

| ID | Exigence | Implémentation |
|----|----------|----------------|
| RNF-05 | Authentification sécurisée | Firebase Auth (hash bcrypt automatique) |
| RNF-06 | Protection des données | Firestore Security Rules |
| RNF-07 | QR Code unique non-rejouable | Token aléatoire unique par séance |
| RNF-08 | Empêcher double scan | Contrainte unique (scheduleId + userId) |

### 5.3 Disponibilité

| ID | Exigence | Critère |
|----|----------|---------|
| RNF-09 | Disponibilité du service | 99% (Firebase SLA) |
| RNF-10 | Connexion internet requise | WiFi campus obligatoire |

### 5.4 Utilisabilité

| ID | Exigence | Critère |
|----|----------|---------|
| RNF-11 | Interface intuitive | Utilisable sans formation |
| RNF-12 | Langue | Français |
| RNF-13 | Design | Material Design (Flutter) |
| RNF-14 | Accessibilité | Taille de police ajustable |

### 5.5 Compatibilité

| ID | Exigence | Support |
|----|----------|---------|
| RNF-15 | Android | Version 6.0+ (API 23+) |
| RNF-16 | iOS | Version 12+ (optionnel en Beta) |
| RNF-17 | Taille écran | 4.5" minimum |
| RNF-18 | Caméra | Résolution 5 MP minimum |

---

## 6. CONTRAINTES DU PROJET

### 6.1 Contraintes temporelles

- **Durée totale:** 3 jours (72 heures)
- **Date de livraison:** Fin Jour 3
- **Démo fonctionnelle:** Obligatoire en fin de projet

### 6.2 Contraintes humaines

- **Équipe:** 10 personnes (compétences hétérogènes)
- **Expérience Firebase:** Limitée (apprentissage en cours de projet)
- **Disponibilité:** Temps plein pendant 3 jours

### 6.3 Contraintes techniques

- **Budget:** 0 € (services gratuits uniquement)
- **Firebase Spark Plan:** Gratuit, limites :
  - 50 000 lectures/jour
  - 20 000 écritures/jour
  - 1 GB stockage
- **Pas de serveur dédié:** Tout en cloud
- **Connexion internet:** Obligatoire (pas de mode offline)

### 6.4 Contraintes fonctionnelles

- **Scope réduit:** Uniquement les fonctions essentielles
- **Pas de refonte UI:** Material Design par défaut
- **Tests manuels:** Pas de tests unitaires automatisés dans les 3 jours
- **Documentation minimale:** README + guide utilisateur basique

---

## 7. ACTEURS DU SYSTÈME

### 7.1 Utilisateurs directs

**Enseignant:**
- **Rôle:** Créer des séances, générer QR, consulter présences
- **Nombre:** ~50 enseignants
- **Niveau technique:** Moyen
- **Dispositifs:** Smartphone Android/iOS

**Étudiant:**
- **Rôle:** Scanner QR, consulter historique
- **Nombre:** ~500 étudiants (phase pilote)
- **Niveau technique:** Bon (natifs du numérique)
- **Dispositifs:** Smartphone Android principalement

### 7.2 Administrateurs

**Administrateur système (futur):**
- **Rôle:** Gestion users, backup données, statistiques globales
- **Nombre:** 2-3 personnes
- **Accès:** Firebase Console (pas d'interface custom en Beta)

---

## 8. LIVRABLES ATTENDUS

### 8.1 Livrables techniques

1. **Code source:**
   - Repository GitHub complet
   - Code Flutter commenté
   - Configuration Firebase documentée

2. **Application mobile:**
   - APK Android release signé
   - Installation testée sur minimum 3 devices

3. **Base de données:**
   - Firestore configuré avec Security Rules
   - Collections: users, schedules, attendances
   - Données de test chargées

### 8.2 Livrables documentaires

1. **Cahier des charges** (ce document)
2. **Spécifications fonctionnelles et techniques**
3. **Architecture logicielle** (diagrammes UML)
4. **Diagramme de Gantt** (planning détaillé)
5. **Rapport de projet complet** (50+ pages)
6. **Guide utilisateur** (Prof + Étudiant)
7. **Documentation technique** (Firebase, Flutter)

### 8.3 Présentation

- **Démo live:** 5 minutes maximum
- **Slides PowerPoint:** 5-7 slides
- **Scénario de test:** Préparé et répété

---

## 9. CRITÈRES DE SUCCÈS

### 9.1 Critères techniques

✅ L'application se lance sans crash  
✅ Login fonctionne pour prof et étudiant  
✅ Création de séance + génération QR OK  
✅ Scan QR enregistre la présence dans Firestore  
✅ Liste des présents s'affiche en temps réel  
✅ Impossible de scanner 2 fois (contrainte unique)

### 9.2 Critères métier

✅ Temps de scan < 30 secondes par étudiant  
✅ Taux de réussite scan > 95%  
✅ Aucune fraude possible (double scan bloqué)  
✅ Données persistantes (survivent au redémarrage app)

### 9.3 Critères projet

✅ Respect du délai (3 jours)  
✅ Budget 0 € respecté  
✅ Tous les livrables documentaires fournis  
✅ Démo fonctionnelle réussie devant jury

---

## 10. RISQUES ET MITIGATION

| Risque | Probabilité | Impact | Mitigation |
|--------|-------------|--------|-----------|
| Problème config Firebase | Moyenne | Élevé | Documentation détaillée, support Dev 1 |
| Bugs caméra Android | Moyenne | Moyen | Tests sur plusieurs devices, permissions |
| Dépassement scope | Élevée | Moyen | Focus strict sur MVP, pas de features extra |
| Manque de temps | Élevée | Élevé | Planning serré, daily standups, priorisation |
| Conflits Git | Moyenne | Faible | Branches par feature, code review |
| Quotas Firebase dépassés | Faible | Moyen | Monitoring usage, mode test limité |

---

## 11. BUDGET ET RESSOURCES

### 11.1 Coûts

- **Firebase Spark Plan:** 0 € (gratuit)
- **Flutter SDK:** 0 € (open source)
- **Outils développement:** 0 € (VS Code, Android Studio gratuits)
- **Hébergement:** 0 € (Firebase)
- **Total:** **0 €**

### 11.2 Ressources humaines

- 10 développeurs × 3 jours = 30 jours-homme
- Compétences: Flutter, Firebase, Design, Documentation

### 11.3 Matériel

- 10 ordinateurs de développement
- Minimum 3 smartphones Android pour tests
- Connexion internet stable

---

## 12. PLANNING MACRO

**Jour 1 :** Setup + Authentification  
**Jour 2 :** Flow QR complet  
**Jour 3 :** Polish + Documentation + Démo

_(Voir diagramme de Gantt détaillé pour le planning précis)_

---

## 13. GLOSSAIRE

- **QR Code:** Quick Response Code - code-barres 2D scannable par caméra
- **Firebase:** Backend-as-a-Service (BaaS) de Google
- **Firestore:** Base de données NoSQL temps réel de Firebase
- **Flutter:** Framework mobile cross-platform de Google
- **APK:** Android Package - fichier d'installation Android
- **MVP:** Minimum Viable Product - version minimale fonctionnelle
- **POC:** Proof of Concept - preuve de concept

---

## 14. VALIDATION ET APPROBATION

| Rôle | Nom | Signature | Date |
|------|-----|-----------|------|
| Chef de projet | Kevin | _________ | __/__/2026 |
| Analyste | Guyf | _________ | __/__/2026 |
| Responsable Doc | JoMab | _________ | __/__/2026 |
| Client (UPC) | _________ | _________ | __/__/2026 |

---

**Fin du Cahier des Charges - Version 1.0**
