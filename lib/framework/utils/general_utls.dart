import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class Utils {


  //FlushBar Toast
  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        message: message,
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.fastOutSlowIn,
        margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        borderRadius: BorderRadius.circular(15),
        padding: const EdgeInsets.all(15),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        positionOffset: 10,
        icon: const Icon(Icons.error_outline_rounded, size: 25, color: Colors.white,),
        flushbarPosition: FlushbarPosition.TOP,
      )..show(context),
    );
  }



  static void showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: isError
          ? Colors.red
          : Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }


}

