import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Common Dialog Show
void showCommonDialog(
    {@required String title,
      @required BuildContext context,
      Widget content,
      Color titleTextColor = Colors.black,
      double titleTextFontSize = 18.0}) {
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color(0xffE2D3F6),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        title: Center(
          child: Text(
            title,
            style: TextStyle(
                fontSize: titleTextFontSize, color: titleTextColor),
          ),
        ),
        content: content,
      ));
}
