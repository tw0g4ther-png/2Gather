# Guide de développement - Projet Flutter

Ce projet utilise Flutter avec les versions suivantes :

- Flutter: 3.35.3
- Dart: 3.5.3
- Java: 17

## 1) Prérequis

- macOS
- Xcode + CocoaPods: `sudo gem install cocoapods`
- Android Studio (SDK + émulateur)
- Flutter SDK installé globalement

## 2) Configuration du projet

```bash
cd /CheminDuProjet/

# Installer les dépendances
flutter pub get

# Vérifier la version Flutter
flutter --version
```

## 3) Lancer l'application

- Android:

```bash
flutter pub get
flutter devices
flutter run -d <device_id>
```

- iOS (simulateur):

```bash
cd ios && pod install && cd ..
flutter devices
flutter run -d "iPhone 15"
```

## 4) Versions du projet

- Flutter: 3.35.3
- Dart: 3.5.3
- Java: 17
- Android: compile/target SDK 34, Build-Tools 34.0.0
