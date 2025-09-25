#deploy token 
```yaml
deploy-token: gitlab+deploy-token-1182250
password: rXFGo_Azy97Vxn9x-pJw
```
# firebase_auth_kosmos

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

Package d'authentification Firebase personnalisé pour l'écosystème Kosmos.
Fournit une couche d'abstraction pour l'authentification Firebase dans TwoGather.

## Features

- Authentification Firebase simplifiée
- Gestion des sessions utilisateur
- Intégration avec les packages Kosmos
- Support email et téléphone
- Gestion des erreurs personnalisée

## Getting started

Prérequis :
- Flutter SDK 3.0+
- Firebase configuré dans le projet
- Packages Kosmos installés

Configuration Firebase requise avant utilisation.

## Usage

Exemple d'utilisation :

```dart
import 'package:firebase_auth_kosmos/firebase_auth_kosmos.dart';

// Authentification
final auth = FirebaseAuthKosmos();
await auth.signInWithEmail(email, password);
``` 

```dart
const like = 'sample';
```

## Additional information

Package interne TwoGather pour l'authentification Firebase.
- Intégration avec l'architecture Kosmos
- Support technique via l'équipe de développement
- Documentation interne disponible
