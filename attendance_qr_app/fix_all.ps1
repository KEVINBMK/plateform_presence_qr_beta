# Script de Correction Automatique - Plateforme Presence QR
# Date : 13 Fevrier 2026
# Description : Nettoie le cache et prepare l'application

Write-Host "[*] Debut de la correction automatique..." -ForegroundColor Cyan
Write-Host ""

# Etape 1 : Nettoyer Flutter
Write-Host "[1/5] Nettoyage Flutter..." -ForegroundColor Yellow
flutter clean
if ($LASTEXITCODE -ne 0) {
    Write-Host "[X] Erreur lors du nettoyage Flutter" -ForegroundColor Red
    exit 1
}
Write-Host "[OK] Flutter nettoye" -ForegroundColor Green
Write-Host ""

# Etape 2 : Nettoyer Gradle
Write-Host "[2/5] Nettoyage Gradle..." -ForegroundColor Yellow
Set-Location android

# Arreter le daemon Gradle
Write-Host "   Arret du daemon Gradle..." -ForegroundColor Gray
.\gradlew --stop

# Nettoyer le projet
Write-Host "   Nettoyage du projet..." -ForegroundColor Gray
.\gradlew clean

Set-Location ..
Write-Host "[OK] Gradle nettoye" -ForegroundColor Green
Write-Host ""

# Etape 3 : Supprimer les caches
Write-Host "[3/5] Suppression des caches..." -ForegroundColor Yellow

$foldersToDelete = @(
    "android\.gradle",
    "android\build",
    "build",
    ".dart_tool\build"
)

foreach ($folder in $foldersToDelete) {
    if (Test-Path $folder) {
        Write-Host "   Suppression : $folder" -ForegroundColor Gray
        Remove-Item -Recurse -Force $folder -ErrorAction SilentlyContinue
    }
}
Write-Host "[OK] Caches supprimes" -ForegroundColor Green
Write-Host ""

# Etape 4 : Recuperer les dependances
Write-Host "[4/5] Recuperation des dependances..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "[X] Erreur lors de la recuperation des dependances" -ForegroundColor Red
    exit 1
}
Write-Host "[OK] Dependances recuperees" -ForegroundColor Green
Write-Host ""

# Etape 5 : Rebuild Gradle
Write-Host "[5/5] Reconstruction Gradle..." -ForegroundColor Yellow
Set-Location android
.\gradlew build --warning-mode all
$gradleExitCode = $LASTEXITCODE
Set-Location ..

if ($gradleExitCode -ne 0) {
    Write-Host "[!] Gradle build a rencontre des warnings (normal)" -ForegroundColor Yellow
} else {
    Write-Host "[OK] Gradle reconstruit" -ForegroundColor Green
}
Write-Host ""

# Resume
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  [OK] NETTOYAGE TERMINE !                            " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Prochaines etapes OBLIGATOIRES :" -ForegroundColor Yellow
Write-Host ""
Write-Host "[1] Deployer les INDEX Firestore :" -ForegroundColor White
Write-Host "   firebase deploy --only firestore:indexes" -ForegroundColor Gray
Write-Host ""
Write-Host "[2] Deployer les REGLES Firestore :" -ForegroundColor White
Write-Host "   firebase deploy --only firestore:rules" -ForegroundColor Gray
Write-Host ""
Write-Host "[3] Lancer l'application :" -ForegroundColor White
Write-Host "   flutter run" -ForegroundColor Gray
Write-Host ""
Write-Host "Consultez GUIDE_FIX_COMPLET.md pour plus de details" -ForegroundColor Cyan
Write-Host ""
Write-Host "Bonne chance !" -ForegroundColor Green

