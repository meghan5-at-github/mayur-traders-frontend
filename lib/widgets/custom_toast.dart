import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  static void showToast(String msg, {String? qr}) {
    String formattedMsg = msg
        .trim()
        .toLowerCase()
        .split(" ")
        .map((String word) {
      return word[0].toUpperCase() + word.substring(1);
    })
        .join(' ');

    Fluttertoast.showToast(
      msg: formattedMsg,
      toastLength: qr == "qr" ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: qr == "qr" ? Colors.grey : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
