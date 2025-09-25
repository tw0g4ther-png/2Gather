# Kosmos UI ThemeData

## Resume

[ThemeData for the Kosmos UI cards widget](#themedata-for-the-kosmos-ui-cards-widget)

[ThemeData for the Kosmos UI CTA buttons widget](#themedata-for-the-kosmos-ui-cta-buttons-widget)

[ThemeData for the Kosmos UI checkbox widget](#themedata-for-the-kosmos-ui-checkbox-widget)

[ThemeData for the Kosmos UI form widgets](#themedata-for-the-kosmos-ui-form-widgets)

[ThemeData for the Kosmos UI headers](#themedata-for-the-kosmos-ui-headers)

[Classic Loader theme data for kosmos widgets](#classic-loader-theme-data-for-kosmos-widgets)

[Progress Bar theme data for kosmos widgets](#progress-bar-theme-data-for-kosmos-widgets)

[Notif banner theme data for kosmos widget](#notif-banner-theme-data-for-kosmos-widget)


### ThemeData for the Kosmos UI Cards widget 

``` dart 
CustomCardsThemeData()
```

Default CustomCardsThemeData exists under the name "cards_x" (x needs to be replaced by one, two, ..., nine). You are able to customize the default CustomCardsThemeData's by overriding them in the appThemeInitializer function.

``` dart
    final appThemeInitializer = (_) {
        final appTheme = AppTheme();

        appTheme.addTheme("cards_one", CustomCardsThemeData());

        return appTheme
    }
```

You can even create your own ThemeData by adding it to the appTheme

``` dart
    final appThemeInitializer = (_) {
        final appTheme = AppTheme();

        appTheme.addTheme("my_card_theme", CustomCardsThemeData());

        return appTheme
    }
```

| properties | type | description |
|------------|------|-------------|
| maxWidth | double? | maximum width of card |
| maxHeight | double? | maximum height of card |
| verticalPadding | double? | amount of padding for vertical padding |
| horizontalPadding | double? | amount of padding for horizontal padding |
| backgroundColor | Color? | color for background |
| radius | double? | border radius for card |
| blurRadius | double? | blur radius for shadow of card |
| spreadRadius | double? | spread radius for shadow of card |
| shadowColor | Color? | color for card's shadow |
| offset | Offset? | color for card's shadow |
----

### ThemeData for the Kosmos UI CTA Buttons widget

``` dart 
CtaThemeData()
```

Default CtaThemeData exists under the name "primary_button", "secondary_button",
"tiers_button" and "back_button" for CTA.primary, CTA.secondary, CTA.tiers and CTA.back respectively. You are able to customize the default CtaThemeData's by overriding them in the appThemeInitializer function.

``` dart
    final appThemeInitializer = (_) {
        final appTheme = AppTheme();

        appTheme.addTheme("primary_button", CtaThemeData());

        return appTheme
    }
```

You can even create your own ThemeData by adding it to the appTheme

``` dart
    final appThemeInitializer = (_) {
        final appTheme = AppTheme();

        appTheme.addTheme("my_cta_theme", CtaThemeData());

        return appTheme
    }
```
----

### ThemeData for the Kosmos UI Checkbox widget

``` dart 
CustomCheckBoxThemeData()
```
Default CustomCheckBoxThemeData exists under the names of "checkbox_square" and "checkbox_circle". You are able to customize the default CustomCheckBoxThemeData's by overriding them in the appThemeInitializer function.

``` dart
    final appThemeInitializer = (_) {
        final appTheme = AppTheme();

        appTheme.addTheme("checkbox_square", CustomCheckBoxThemeData());

        return appTheme
    }
```

You can even create your own ThemeData by adding it to the appTheme

``` dart
    final appThemeInitializer = (_) {
        final appTheme = AppTheme();

        appTheme.addTheme("my_checkbox_theme", CustomCheckBoxThemeData());

        return appTheme
    }
```
----

### ThemeData for the Kosmos UI Form widgets

``` dart 
CustomFormFieldThemeData()
```
default CustomFormFieldThemeData exists under the names of "input_field". you are able to customize the default CustomFormFieldThemeData's by overriding them in the appThemeInitializer function.

``` dart
    final appThemeInitializer = (_) {
        final appTheme = AppTheme();

        appTheme.addTheme("input_field", CustomFormFieldThemeData());

        return appTheme
    }
```

You can even create your own ThemeData by adding it to the appTheme

``` dart
    final appThemeInitializer = (_) {
        final appTheme = AppTheme();

        appTheme.addTheme("my_form_theme", CustomFormFieldThemeData());

        return appTheme
    }
```

The default "input_field" CustomFormFieldThemeData is used in the following widgets: 

- TextFormUpdated.classic
- TextFormUpdated.phoneNumber
- TextFormUpdated.dateTime,
- TextFormUpdated.immatriculation
- TextFormUpdated.textarea
- SelectForm
- Input.image
- Input.files
- Input.validatedFile
----

### ThemeData for the Kosmos UI Headers widgets

``` dart 
CustomHeadersThemeData()
```

default CustomHeadersThemeData exists under the names of "headers_x" (x needs to be repalced by one, two or three). you are able to customize the default CustomHeadersThemeData's by overriding them in the appThemeInitializer function.

``` dart
    final appThemeInitializer = (_) {
        final appTheme = AppTheme();

        appTheme.addTheme("headers_one", CustomHeadersThemeData());

        return appTheme
    }
```

You can even create your own ThemeData by adding it to the appTheme

``` dart
    final appThemeInitializer = (_) {
        final appTheme = AppTheme();

        appTheme.addTheme("my_header_theme", CustomHeadersThemeData());

        return appTheme
    }
```

| Header | default ThemeData name |
|--------|------------------------|
| Header.primary | "headers_one" |
| Header.secondary | "headers_two" |
| Header.third | "headers_three" |
----

### ThemeData for the Kosmos UI Classic Loader

``` dart 
ClassicLoaderThemeData()
```

default ClassicLoaderThemeData exists under the name of "classic_loader". you are able to customize the default ClassicLoaderThemeData's by overriding them in the appThemeInitializer function.

``` dart
    final appThemeInitializer = (_) {
        final appTheme = AppTheme();

        appTheme.addTheme("classic_loader", ClassicLoaderThemeData());

        return appTheme
    }
```

You can even create your own ThemeData by adding it to the appTheme

``` dart
    final appThemeInitializer = (_) {
        final appTheme = AppTheme();

        appTheme.addTheme("my_loader_theme", ClassicLoaderThemeData());

        return appTheme
    }
```

The default "classic_loader" ClassicLoaderThemeData is used in the following widgets: 

- LoaderClassique
- ThreeBounce
----

### ThemeData for the Kosmos UI ProgressBar widgets

``` dart 
ProgressBarThemeData()
```

default ProgressBarThemeData exists under the name of "progress_bar". you are able to customize the default ProgressBarThemeData's by overriding them in the appThemeInitializer function.

``` dart
    final appThemeInitializer = (_) {
        final appTheme = AppTheme();

        appTheme.addTheme("progress_bar", ProgressBarThemeData());

        return appTheme
    }
```

You can even create your own ThemeData by adding it to the appTheme

``` dart
    final appThemeInitializer = (_) {
        final appTheme = AppTheme();

        appTheme.addTheme("my_bar_theme", ProgressBarThemeData());

        return appTheme
    }
```

The default "progress_bar" ProgressBarThemeData is used in the following widgets: 

- ProgressBar
- ProgressBar.separated
----

### ThemeData for the Kosmos UI Notif Banner widgets

``` dart 
NotifBannerThemeData()
```

default NotifBannerThemeData exists under the name of "notif_banner". you are able to customize the default NotifBannerThemeData's by overriding them in the appThemeInitializer function.

``` dart
    final appThemeInitializer = (_) {
        final appTheme = AppTheme();

        appTheme.addTheme("notif_banner", NotifBannerThemeData());

        return appTheme
    }
```

You can even create your own ThemeData by adding it to the appTheme

``` dart
    final appThemeInitializer = (_) {
        final appTheme = AppTheme();

        appTheme.addTheme("my_banner_theme", NotifBannerThemeData());

        return appTheme
    }
```
----

### ThemeData for the Kosmos UI Selector widgets

``` dart 
SelectorThemeData()
```

Default SelectorThemeData exists under the name of "selector". You are able to customize the default SelectorThemeData's by overriding them in the appThemeInitializer function.

``` dart
    final appThemeInitializer = (_) {
        final appTheme = AppTheme();

        appTheme.addTheme("selector", SelectorThemeData());

        return appTheme
    }
```

You can even create your own ThemeData by adding it to the appTheme

``` dart
    final appThemeInitializer = (_) {
        final appTheme = AppTheme();

        appTheme.addTheme("my_banner_theme", SelectorThemeData());

        return appTheme
    }
```
----

### ThemeData for the Kosmos UI Settings Cellule widgets 

``` dart
SettingsCelluleThemeData()
```

Default SettingsCelluleThemeData exists under the name of "settings_cellule". You are able to customize the default SettingsCelluleThemeData's by overriding them in the appThemeInitializer function.

``` dart
    final appThemeInitializer = (_) {
        final appTheme = AppTheme();

        appTheme.addTheme("settings_cellule", SettingsCelluleThemeData());

        return appTheme
    }
```
----

<!-- slider/slider.dart:
- CustomSlider.slider/_Slider: [SliderThemeData]
- CustomSlider.range/_Range: [SliderThemData] -->