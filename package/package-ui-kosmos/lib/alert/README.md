### Add the following imports to your Dart code

```dart
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';
```

![picture/alert.gif](picture/alert.gif)


```dart
CTA.primary(
  textButton: 'Show Alert',
  onTap: () =>
      Alert.show(context: context, title: 'Titre', content: 'Desciption', defaultActionText: 'Fermer'),
),
```