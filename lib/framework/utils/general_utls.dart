import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class Utils {


  //calculate Average rating
  static double averageRating(List<int> rating){
    var avgRating = 0;
    for(int i = 0 ; i< rating.length ; i++){
      avgRating = avgRating + rating[i];
    }
    return double.parse((avgRating / rating.length).toStringAsFixed(1));
  }

  //Focus Node
  static void fieldFocusChange(BuildContext context, FocusNode current, FocusNode nextFocus){
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  //Normal Toast
  static toastMessage(String message) {
    Fluttertoast.showToast(msg: message);
  }

  //FlushBar Toast
  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        message: message,
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.fastOutSlowIn,
        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        borderRadius: BorderRadius.circular(15),
        padding: EdgeInsets.all(15),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        positionOffset: 10,
        icon: Icon(Icons.error_outline_rounded, size: 25, color: Colors.white,),
        flushbarPosition: FlushbarPosition.BOTTOM,
      )..show(context),
    );
  }

  //SnackBar Toast
  static snackBar(String message, BuildContext context){
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
            content: Text(message)
        )
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