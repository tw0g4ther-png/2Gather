import 'chatColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class ChatStyle {
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //------------------------------------------------------Index chat page  --------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  static TextStyle pseudoHeaderStyle = TextStyle(
    color: ChatColor.pseudoHeader_color,
    fontSize: 17.sp,
    fontWeight: FontWeight.w600,
  );
  static TextStyle pseudoAboutStyle = TextStyle(
    color: ChatColor.pseudoHeader_color,
    fontSize: 19.sp,
    fontWeight: FontWeight.w600,
  );
  static TextStyle addMemberToGroup = TextStyle(
    color: ChatColor.add_to_group,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
  );

  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //-----------------------------------------------------Contact-list--------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  static TextStyle contactUsernameStyle =
      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black);
  static TextStyle contactListAllGroupName =
      TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle contactListAllGroupMember =
      TextStyle(color: const Color(0XFFAFAFAF), fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle contactListFromTextStyle =
      TextStyle(color: Colors.black, fontSize: 13.sp, fontWeight: FontWeight.w600);
  static TextStyle contactListRowTypingOrRecordingTextStyle = TextStyle(
      color: ChatColor.contact_list_row_typing_or_recording_text_Color, fontSize: 13.sp, fontWeight: FontWeight.w500);
  static TextStyle contactListRowStatusTextStyle = TextStyle(
      color: ChatColor.contact_list_row_typing_or_recording_text_Color, fontSize: 13.sp, fontWeight: FontWeight.w500);
  static TextStyle contactListTypeTextStyle =
      TextStyle(color: ChatColor.contact_list_type_message_text, fontSize: 11.sp, fontWeight: FontWeight.w400);
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //---------------------------------------reply_message_replied_content--------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  static TextStyle releaseToReply =
      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: ChatColor.release_to_reply_color);
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //---------------------------------------reply_message_replied_content--------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  static TextStyle repliedMessagePseudoRightStyle = TextStyle(
    fontSize: 9.sp,
    fontWeight: FontWeight.w600,
    color: ChatColor.bubble_reply_message_replied_content_pseudo_right_color,
  );

  static TextStyle repliedMessagePseudoLeftStyle = TextStyle(
    fontSize: 9.sp,
    fontWeight: FontWeight.w600,
    color: ChatColor.bubble_reply_message_replied_content_pseudo_left_color,
  );
  static TextStyle repliedMessageRightStyle = TextStyle(
    fontSize: 9.sp,
    fontWeight: FontWeight.w600,
    color: ChatColor.bubble_reply_message_replied_text_right_color,
  );
  static TextStyle repliedMessageLeftStyle = TextStyle(
    fontSize: 9.sp,
    fontWeight: FontWeight.w600,
    color: ChatColor.bubble_reply_message_replied_text_left_color,
  );
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------Message content Style------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  static TextStyle pseudoMessageStyle = TextStyle(
    color: ChatColor.pseudo_bubble_color,
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
  );
  static TextStyle pseudoMessageUtilisateurLeaveStyle = TextStyle(
    color: ChatColor.pseudo_bubble_color,
    fontSize: 8.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle messageRightStyle = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: ChatColor.text_message_right,
  );
  static TextStyle messageLeftStyle = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: ChatColor.text_message_left,
  );
  static TextStyle messageTimeagoRightStyle = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    color: ChatColor.bubble_right_timeago_color,
  );
  static TextStyle messageTimeagoLeftStyle = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    color: ChatColor.bubble_left_timeago_color,
  );
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------//
  static TextStyle messageInputHintStyle =
      TextStyle(color: ChatColor.bottom_input_hint_message_color, fontSize: 13.sp, fontWeight: FontWeight.w500);
  static TextStyle messageInputTextStyle =
      TextStyle(color: Colors.black, fontSize: 13.sp, fontWeight: FontWeight.w500);
  static OutlineInputBorder messageInputBorderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(29.r),
      borderSide: BorderSide(
        color: Colors.transparent,
        width: 0.5.w,
      ));
}
