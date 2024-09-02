import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text, {Exception? e, Color backgroundColor = const Color.fromARGB(255, 197, 92, 127), Color textColor = Colors.white, Duration duration = const Duration(seconds: 3)}) {
  final message = e != null ? '$text: ${e.toString()}' : text;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: IntrinsicHeight(
        // Use IntrinsicHeight to wrap the content
        child: Row(
          mainAxisSize: MainAxisSize.min, // Update size based on content
          children: [
            Icon(
              Icons.info_outline,
              color: textColor,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: textColor, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      duration: duration,
    ),
  );
}

void showSnackBarBlue(BuildContext context, String text, {double bottom = 20, icon = Icons.home, Exception? e, Color backgroundColor = Colors.lightBlue, Color textColor = Colors.white, Duration duration = const Duration(seconds: 3)}) {
  final message = e != null ? '$text: ${e.toString()}' : text;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: IntrinsicHeight(
        // Use IntrinsicHeight to wrap the content
        child: Row(
          mainAxisSize: MainAxisSize.min, // Update size based on content
          children: [
            Icon(
              icon,
              color: textColor,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: textColor, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: bottom, top: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      duration: duration,
    ),
  );
}
