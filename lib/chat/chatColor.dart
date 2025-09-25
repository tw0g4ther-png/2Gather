// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter/material.dart';

abstract class ChatColor {
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //-----------------------------------------------------Index-Chat-page--------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  static const pseudoHeader_color = Colors.black;
  static const add_to_group = Color(0XFF0BBBF0);

  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //-----------------------------------------------------Contact-list--------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  static const contact_list_type_messageIcon = Color(0XFF909090);
  static const contact_list_Mic_Icon = Color(0XFF909090);
  static const contact_list_type_message_text = Color(0XFF919191);
  static const contact_list_row_typing_or_recording_text_Color = Color(
    0XFF04B1E5,
  );

  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //-----------------------------------------------------bottom input color --------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//

  static Color bottom_background_color = Colors.white;
  static Color bottom_input_background_color = const Color(0XFFE5E5E5);
  static Color bottom_input_hint_message_color = const Color(0XFFC3C3C3);
  static Color bottom_input_message_color = const Color(0XFFC3C3C3);
  static Color bottom_input_icon_color = const Color(0XFFFF6D01);
  static Color bottom_input_mic_recording_color = const Color(0XFFBCECFA);
  static Color bottom_input_recording_glissez_pour_annuler_color = const Color(
    0XFFBCECFA,
  );
  static Color bottom_input_recording_annuler_color = const Color(0XFFBCECFA);

  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------- Bubble color ---------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  static Color bubble_color_right = const Color(0XFFEF561D);
  static const pseudo_bubble_color = Color(0XFF575757);
  static Color release_to_reply_color = const Color(0XFFC3C3C3);
  static Color bubble_color_left = Colors.white;
  static Color bubble_border_left_color = const Color(
    0XFF000000,
  ).withValues(alpha: 0.2);
  static Color bubble_border_right_color = Colors.transparent;
  static Color bubble_right_timeago_color = const Color(0XFFAAE7F9);
  static Color bubble_left_timeago_color = const Color(0XFFC3C3C3);
  static Color buuble_audio_right_duration = Colors.white.withValues(
    alpha: 0.67,
  );
  static Color buuble_audio_left_duration = Colors.black.withValues(
    alpha: 0.67,
  );

  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //---------------------------------------reply_message_replied_content--------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  static Color bubble_reply_message_replied_content_right =
      const Color.fromARGB(255, 232, 232, 232);
  static Color bubble_reply_message_replied_content_left = const Color.fromARGB(
    255,
    232,
    232,
    232,
  );
  static Color bubble_reply_message_replied_content_icon_type_right_color =
      Colors.black;
  static Color bubble_reply_message_replied_content_icon_type_left_color =
      const Color(0XFFF6F6F6);
  static Color bubble_reply_message_replied_content_icon_type__color =
      Colors.white;
  static Color bubble_reply_message_replied_content_pseudo_right_color =
      Colors.black;
  static Color bubble_reply_message_replied_content_pseudo_left_color =
      Colors.black;
  static Color bubble_reply_message_replied_text_right_color = Colors.black;
  static Color bubble_reply_message_replied_text_left_color = const Color(
    0XFF000000,
  ).withValues(alpha: 0.7);

  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //-------------------------------------------------------messageTEXT-conten --------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  static Color text_message_right = Colors.white;
  static Color text_message_left = const Color(
    0XFF676767,
  ).withValues(alpha: 0.7);

  //----------------------------------------------------------------------------------------------------------------------------//
  //---------------------------------------------messageTEXT-content-------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  static Color audio_message_right_thumb_color = Colors.white;
  static Color audio_message_right_track_color = Colors.white;
  static Color audio_message_left_track_color = const Color(0XFF0BBBF0);
  static Color audio_message_left_thumb_color = const Color(0XFF0BBBF0);
  static Color audio_message_left_thumb_color_before_play = const Color(
    0XFF0ADB6B,
  );
  static Color audio_message_right_thumb_color_before_play = const Color(
    0XFF69D5F6,
  );

  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//

  //--------------------------------------------------OLD CHAT--------------------------------------------------------------------//
  static Color bottom_bar_recording_arrow_color = const Color(0xffC3C3C3);

  static Color bottom_bar_recording_cancel_text_color = const Color(0XffC3C3C3);
  static double bottom_bar_recording_cancel_text_size = 15;
  static FontWeight bottom_bar_recording_cancel_text_font_weight =
      FontWeight.w400;

  static Color bottom_bar_lock_background_color = const Color(0xffDEDEDE);
  static Color bottom_bar_lock_content_color = Colors.white;

  static Color bottom_bar_recording_annuler_text_color = const Color(
    0XffF00B40,
  );
  static double bottom_bar_recording_annuler_text_size = 15;
  static FontWeight bottom_bar_recording_annuler_text_font_weight =
      FontWeight.w500;
}
