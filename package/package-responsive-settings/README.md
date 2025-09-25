```yaml
DeployToken: gitlab+deploy-token-1235964
Password: zunZ-x88vVA44Hx8eb9R
```

<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

Package de gestion des paramètres responsifs pour l'application TwoGather.
Permet de gérer les configurations d'interface utilisateur selon la taille d'écran.

## Features

- Gestion responsive des paramètres d'interface
- Adaptation automatique selon la taille d'écran
- Configuration centralisée des éléments UI
- Support mobile et tablette

## Getting started

Prérequis :
- Flutter SDK 3.0+
- Dart 2.17+

Ajoutez la dépendance dans votre pubspec.yaml et importez le package.

## Usage

Exemple d'utilisation basique :

```dart
import 'package:package_responsive_settings/package_responsive_settings.dart';

// Configuration responsive
final settings = ResponsiveSettings();
settings.configure(context);
``` 

```dart
const like = 'sample';
```

## Additional information

Ce package fait partie de l'écosystème TwoGather. Pour plus d'informations :
- Documentation interne du projet
- Support via l'équipe de développement
- Intégration avec les autres packages Kosmos
