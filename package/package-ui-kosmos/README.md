
# KOSMOS WIDGETS V4 CORE

### GETTING STARTING

```yaml
core_kosmos:
  git:
    publish_to: none
    url:  package-core-link
    ref: main

ui_kosmos_v4:
  git:  
    publish_to: none
    url:  package-ui-you-link
    ref: main

get_it: ^7.2.0
flutter_screenutil: ^5.5.3+2
responsive_framework: 0.1.7
```

### ADD THIS TO YOU'RE MAIN

```dart
GetIt.instance.registerSingleton<AppTheme>(AppTheme());
final appTheme = GetIt.instance<AppTheme>();
```

### IF U WAN'T TO CHANGE SOME THEME

```dart
appTheme.addTheme(
  "secondary_button",
  CtaThemeData(
    borderRadius: 8,
    border: Border.all(color: Colors.blue, width: 0.5),
    textButtonStyle: const TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w400),
  ),
);
```

## DIFFERENT WIDGETS

### • [Call To Action](https://gitlab.com/package16/package-ui-kosmos/-/tree/main/lib/cta/README.md)

### • [Inputs and Form](https://gitlab.com/package16/package-ui-kosmos/-/tree/main/lib/form/README.md)

### • [Search Bar](https://gitlab.com/package16/package-ui-kosmos/-/tree/main/lib/search_bar/README.md)

### • [Micro-éléments](https://gitlab.com/package16/package-ui-kosmos/-/tree/main/lib/micro_element/README.md)

### • [TabBar](https://gitlab.com/package16/package-ui-kosmos/-/tree/main/lib/tab_bar/README.md)

### • [Header](https://gitlab.com/package16/package-ui-kosmos/-/tree/main/lib/header/README.md)

### • [Checkbox/slider/switch/radio](https://gitlab.com/package16/package-ui-kosmos/-/tree/main/lib/checkbox/README.md)

### • [Alerts](https://gitlab.com/package16/package-ui-kosmos/-/tree/main/lib/alert/README.md)

### • [Interns Notifications](https://gitlab.com/package16/package-ui-kosmos/-/tree/main/lib/notif/README.md)

### • [Warning Messages](https://gitlab.com/package16/package-ui-kosmos/-/tree/main/lib/notif/README.md)

### • [Cards](https://gitlab.com/package16/package-ui-kosmos/-/tree/main/lib/card/README.md)

### • [Image Cropper]()

### • [Settings Cellule](https://gitlab.com/package16/package-ui-kosmos/-/tree/main/lib/settings_cellule/README.md)

### ⚠ All links redirects to an example. ⚠
