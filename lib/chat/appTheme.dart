import 'appColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

abstract class AuthTheme {
  static TextStyle pageTitleStyle() => TextStyle(color: AppColor.primaryTextColor, fontSize: 25.sp, fontWeight: FontWeight.w600);
  static TextStyle pageTitleStyle20() => TextStyle(color: AppColor.primaryTextColor, fontSize: 20.sp, fontWeight: FontWeight.w600);
  static TextStyle slidingupTitleStyle() => TextStyle(color: AppColor.primaryTextColor, fontSize: 20.sp, fontWeight: FontWeight.w600);
}

abstract class AppTheme {
  //----------------------SETTINGS---------------------------------//
  static TextStyle settingsPageTitle() => TextStyle(color: AppColor.primaryTextColor, fontSize: 18.sp, fontWeight: FontWeight.w600);

  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // --------------------Primary Button-----------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  static const double primaryButtonDefaultHeight = 54;

  static const double primaryButtonFontSize = 17;
  static const FontWeight primaryButtonFontWeight = FontWeight.w500;
  static const double primaryButtonDefaultWidth = 139;

  static BoxShadow defaultBoxShadow = const BoxShadow(blurRadius: 35, offset: Offset(0, 0), spreadRadius: 0, color: Color(0XFFD8D8D8));
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//

  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // --------------------Secondary Button-----------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//

  static const double secondaryButtonDefaultHeight = 54;
  static const double secondaryButtonFontSize = 17;
  static const FontWeight secondaryButtonFontWeight = FontWeight.w600;
  static const double secondaryButtonDefaultWidth = 139;

  static BorderSide borderSideSecondaryButton = BorderSide(color: AppColor.secondaryButtonBorderColor, width: 0.5.w, style: BorderStyle.solid);
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//

  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // --------------------Third Button-----------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//

  static const FontWeight thirdButtonFontWeight = FontWeight.w600;
  static const double thirdButtonFontSize = 17;
  static const double thirdButtonDefaultheight = 54;
  static const double thirdButtonDefaultWidth = 139;
  static const double thirdButtonDefaultWidthWithoutText = 54;
  static const double thirdButtonDefaultHeightWithoutText = 54;
  static const Color thirdButtonColor = Color(0XFF0BBBF0);
  static const Color thirdButtonTextColor = Colors.white;
  static BorderSide borderSideThirdButton = BorderSide(color: const Color(0XFFCCCCCC), width: 0.5.w, style: BorderStyle.solid);
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//

  // -----------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------back Button-----------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//

  static const Color backButtonIconColor = Colors.black;
  static const Color backButtonBackgroundColor = Colors.white;
  static const backButtondefaultWidth = 47;
  static const backButtondefaultheight = 47;
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//

  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // --------------------Action Button-----------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//

  static const actionButtondefaultWidth = 47;
  static const actionButtondefaultHeight = 47;
  static const Color actionButtonIconColor = Colors.black;
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  //-----------------Form ----------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//

  static Color postFieldNameColor = AppColor.primaryButtonColor;

  static const double defaultRadius = 7;
  static TextStyle textFormFieldStyleDefault = TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, color: AppColor.primaryTextColor);

  static EdgeInsets contentPaddingInput = EdgeInsets.symmetric(horizontal: 0.w, vertical: 15.h);

  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ---------------------------UploadPicutre----------------------//
  // ----------------------------------------------------------------//
  //--------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  static const UploadStyleType uploadStyleDefault = UploadStyleType.Fill;
  static const UploadItemType uploadItemTypeDefault = UploadItemType.Picture;

  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  //----------------- ----------------------------------------//
  // ----------------------------------------------------------------//
// ----------------------------------------------------------------//
// ----------------------------------------------------------------//
// ----------------------------------------------------------------//
// ----------------------------------------------------------------//
// -------------------Commerce Header------------------------//
  static Color sbutitleColorCommerce = const Color(0XFFB5BDCC);
  static Color descriptionColorCommerce = const Color(0XFFB5BDCC);
  static double commerceHeaderHeight = 313.h;
  static TextStyle commerceHeaderTitleStyle = TextStyle(fontSize: 27.sp, fontWeight: FontWeight.w700, color: Colors.white);
  static TextStyle commerceSubtitleStyle = TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: descriptionColorCommerce);
  static TextStyle commerceHeaderDescriptionStyle = TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: descriptionColorCommerce);

// ----------------------------------------------------------------//
// ----------------------------------------------------------------//
// ----------------------------------------------------------------//
// ---------------------------------------------------------------//
// ----------------------------------------------------------------//
// ----------------------------------------------------------------//

  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//

  // ----------------------------------------------------------------//
  static Color loadingColor = Colors.white;

  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------NotifBanner------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  static TextStyle notifBannerLabelStyle = TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.white);
  static TextStyle notifBannerTextStyle = TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.75));

  static Color notifBannerSuccessColor = const Color(0XFF34E694);
  static Color notifBannerFaileColor = const Color(0XFFEB5353);
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//
  // ----------------------------Button Config---------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//

  static Color chevronColor = const Color(0XFFC3C3C3);
  static TextStyle titleConfigButtonStyle = TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColor.primaryTextColor);
  static TextStyle subtitleConfigButtonStyle = TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500, color: AppColor.secondaryTextColor);

  // -------------------------------------------- --------------------//
  // ----------------------------------------------------------------//
  // ----------------------------------------------------------------//

  // ----------------------------------------------------------------//
}

// ----------------------------------------------------------------//
// ----------------------------------------------------------------//
// ----------------------------------------------------------------//

// ----------------------------------------------------------------//
// --------------------------Enum--------------------------------//
// ----------------------------------------------------------------//

enum UploadStyleType { Fill, Bordered }
enum UploadItemType { File, Picture }

// ----------------------------------------------------------------//
// ----------------------------------------------------------------//
// ----------------------------------------------------------------//
abstract class CheckboxAppTheme {
  static const Color checkboxSelectedColor = Color(0XFF0BBBF0);
  static const Color checkboxUnselectedColor = Color(0XFFF6F6F6);
  static const IconData checkBoxIcon = CupertinoIcons.checkmark_alt;
  static const Color selectedIconColor = Colors.white;
  static const Color borderColor = Color(0XFF707070);
  static const double width = 26;
  static const double height = 26;
  static const double iconSize = 24;
  static const double borderWidth = 0.5;
  static const double borderRadius = 5;
}

// ----------------------------CARD-----------------------------//
// ----------------------------------------------------------------//

abstract class CardAppTheme {
  static const Color titleColor = Colors.black;
  static const Color descriptionColor = Color(0XFFA0A4AC);
  static const Color usernameColor = Colors.black;
  static const Color userRateColor = Colors.black;
  static const Color subtitleColor = Color(0XFFB5BDCC);
  static const Color dotsColorPrimary = Color(0XFF9199A7);
  static const Color dotsColorSecondary = Colors.white;

  static double cardWidth(CardStyle cardStyle) {
    switch (cardStyle) {
      case CardStyle.Style1:
        return 135;
      case CardStyle.Style1V:
        return 315;
      case CardStyle.Style2:
        return 135;
      case CardStyle.Style2V:
        return 315;
      case CardStyle.Style3:
        return 139;
      case CardStyle.Style4:
        return 146;
      case CardStyle.Style7:
        return 315;

      default:
        return 0;
    }
  }

  static double cardPictureHeight(CardStyle cardStyle) {
    switch (cardStyle) {
      case CardStyle.Style1:
        return 68;
      case CardStyle.Style2:
        return 68;
      case CardStyle.Style3:
        return 139;
      case CardStyle.Style4:
        return 173;
      default:
        return 0;
    }
  }

  static double cardRadius(CardStyle cardStyle) {
    switch (cardStyle) {
      case CardStyle.Style1:
        return 18;
      case CardStyle.Style2:
        return 18;
      case CardStyle.Style3:
        return 19;
      case CardStyle.Style4:
        return 19;
      case CardStyle.Style1V:
        return 18;
      case CardStyle.Style2V:
        return 19;
      case CardStyle.Style7:
        return 19;
      default:
        return 0;
    }
  }

  static double cardPictureRadius(CardStyle cardStyle) {
    switch (cardStyle) {
      case CardStyle.Style1:
        return 14;
      case CardStyle.Style1V:
        return 14;
      case CardStyle.Style2V:
        return 19;
      case CardStyle.Style2:
        return 14;
      case CardStyle.Style3:
        return 19;
      case CardStyle.Style4:
        return 22;

      default:
        return 0;
    }
  }

  static double cardMinHeight(CardStyle cardStyle) {
    switch (cardStyle) {
      case CardStyle.Style1:
        return 125;
      case CardStyle.Style1V:
        return 125;
      case CardStyle.Style2V:
        return 125;
      case CardStyle.Style2:
        return 135;
      case CardStyle.Style3:
        return 176;
      case CardStyle.Style4:
        return 195;
      case CardStyle.Style7:
        return 125;
      default:
        return 0;
    }
  }

  static double cardPicutreMaxWidthV(CardStyle cardStyle) {
    switch (cardStyle) {
      case CardStyle.Style1V:
        return 120;
      case CardStyle.Style2V:
        return 134;
      default:
        return 0;
    }
  }
}

//----------------------CardWidth--------------------------//

//----------------------TextStyle--------------------------//
TextStyle? descriptionStyle({required CardStyle cardStyle}) {
  switch (cardStyle) {
    case CardStyle.Style1V:
      return TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400, color: CardAppTheme.descriptionColor);
    default:
      return TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400, color: CardAppTheme.descriptionColor);
  }
}

TextStyle? titleStyle({required CardStyle cardStyle}) {
  switch (cardStyle) {
    case CardStyle.Style1:
      return TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: CardAppTheme.titleColor);
    case CardStyle.Style4VFullSize:
      return TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white);
    case CardStyle.Style6VFullSize:
      return TextStyle(fontSize: 21.sp, fontWeight: FontWeight.w500, color: Colors.white);
    case CardStyle.Style1V:
      return TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: CardAppTheme.titleColor);

    case CardStyle.Style2:
      return TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: CardAppTheme.titleColor);
    default:
      return null;
  }
}

TextStyle? subtitleStyle({required CardStyle cardStyle}) {
  switch (cardStyle) {
    case CardStyle.Style1:
      return TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500, color: CardAppTheme.subtitleColor);
    case CardStyle.Style4VFullSize:
      return TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500, color: const Color(0XFFB5BDCC));
    case CardStyle.Style6VFullSize:
      return TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500, color: const Color(0XFFB5BDCC));
    case CardStyle.Style1V:
      return TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500, color: CardAppTheme.subtitleColor);

    case CardStyle.Style2:
      return TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500, color: CardAppTheme.subtitleColor);
    case CardStyle.Style5VFullSize:
      return TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500, color: const Color(0XFFB5BDCC));
    default:
      return null;
  }
}

TextStyle? uesrnameStyle({required CardStyle cardStyle}) {
  switch (cardStyle) {
    case CardStyle.Style3:
      return TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400, color: CardAppTheme.usernameColor);
    case CardStyle.Style5VFullSize:
      return TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: CardAppTheme.usernameColor);

    default:
      return null;
  }
}

TextStyle? userRateStyle({required CardStyle cardStyle}) {
  switch (cardStyle) {
    case CardStyle.Style3:
      return TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w400, color: CardAppTheme.userRateColor);

    default:
      return null;
  }
}

enum CardStyle {
  Style1,
  Style2,
  Style3,
  Style4,
  Style1V,
  Style2V,
  Style4VFullSize,
  Style5VFullSize,
  Style6VFullSize,
  Style7,
}
