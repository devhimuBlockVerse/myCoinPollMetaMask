import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
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



// class CustomToast extends StatelessWidget {
//   const CustomToast({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final media = MediaQuery.of(context);
//     final screenWidth = media.size.width;
//     final screenHeight = media.size.height;
//
//     double toastWidth = screenWidth * 0.9;
//     double toastHeight = screenHeight * 0.1;
//
//     return Center(
//       child: Container(
//         width: toastWidth,
//         padding: EdgeInsets.symmetric(
//           horizontal: toastWidth * 0.045,
//           vertical: toastHeight * 0.15,
//         ),
//          decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xffF04248), Color(0xFF242C32)],
//             stops: [0.05, 0.3], // 20% red, then smoothly fade to dark
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//             ).withOpacity(0.50),
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black38,
//               blurRadius: 20,
//               offset: Offset(0, 6),
//             ),
//           ],
//         ),
//
//
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Circular icon or image container
//             Container(
//               width: toastHeight * 0.55,
//               height: toastHeight * 0.55,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF303746),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(Icons.error_outline, color: Colors.white, size: 20),
//             ),
//             const SizedBox(width: 12),
//
//             // Texts
//             Expanded(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: const [
//                   Text(
//                     'Charger is under maintenance',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                       fontFamily: 'Poppins',
//                       fontWeight: FontWeight.w600,
//                       height: 1.4,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     'Please select another charger.',
//                     style: TextStyle(
//                       color: Color(0xFFC7C5C5),
//                       fontSize: 12,
//                       fontFamily: 'Poppins',
//                       fontWeight: FontWeight.w400,
//                       height: 1.4,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//      );
//   }
// }
///
// class CustomToast extends StatelessWidget {
//   final Widget icon;
//   final Color iconBackgroundColor;
//   final List<Color> backgroundGradientColors;
//   final String title;
//   final String? subtitle;
//   final TextStyle? titleTextStyle;
//   final TextStyle? subtitleTextStyle;
//   final double widthFactor;  // fraction of screen width, default 0.9
//   final double heightFactor; // fraction of screen height, default 0.1
//
//   const CustomToast({
//     super.key,
//     required this.icon,
//     this.iconBackgroundColor = const Color(0xFF303746),
//     this.backgroundGradientColors = const [Color(0xffF04248), Color(0xFF242C32)],
//     required this.title,
//     this.subtitle,
//     this.titleTextStyle,
//     this.subtitleTextStyle,
//     this.widthFactor = 0.9,
//     this.heightFactor = 0.1,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final media = MediaQuery.of(context);
//     final screenWidth = media.size.width;
//     final screenHeight = media.size.height;
//
//     double toastWidth = screenWidth * widthFactor;
//     double toastHeight = screenHeight * heightFactor;
//
//     return Center(
//       child: Container(
//         width: toastWidth,
//         padding: EdgeInsets.symmetric(
//           horizontal: toastWidth * 0.045,
//           vertical: toastHeight * 0.15,
//         ),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: backgroundGradientColors,
//             stops: const [0.05, 0.3],
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//           ).withOpacity(0.50),
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black38,
//               blurRadius: 20,
//               offset: Offset(0, 6),
//             ),
//           ],
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Circular icon container
//             Container(
//               width: toastHeight * 0.55,
//               height: toastHeight * 0.55,
//               decoration: BoxDecoration(
//                 color: iconBackgroundColor,
//                 shape: BoxShape.circle,
//               ),
//               child: Center(child: icon),
//             ),
//             SizedBox(width: toastWidth * 0.03),
//
//             // Texts
//             Expanded(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: titleTextStyle ??
//                         const TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.w600,
//                           height: 1.4,
//                         ),
//                   ),
//                   if (subtitle != null) ...[
//                     SizedBox(height: toastHeight * 0.04),
//                     Text(
//                       subtitle!,
//                       style: subtitleTextStyle ??
//                           const TextStyle(
//                             color: Color(0xFFC7C5C5),
//                             fontSize: 12,
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.w400,
//                             height: 1.4,
//                           ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class CustomToast extends StatelessWidget {
  final Widget icon;
  final Color iconBackgroundColor;
  final List<Color> backgroundGradientColors;
  final String title;
  final String? subtitle;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final double widthFactor;  // fraction of screen width, default 0.9
  final double heightFactor; // fraction of screen height, default 0.1

  const CustomToast({
    super.key,
    required this.icon,
    this.iconBackgroundColor = const Color(0xFF303746), // Default from previous context
    this.backgroundGradientColors = const [Color(0xffF04248), Color(0xFF242C32)], // Default from previous context
    required this.title,
    this.subtitle,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.widthFactor = 0.9,
    this.heightFactor = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;

    double toastWidth = screenWidth * widthFactor;
    double toastHeight = screenHeight * heightFactor;

    return Center(
      child: Container(
        width: toastWidth,
        padding: EdgeInsets.symmetric(
          horizontal: toastWidth * 0.045,
          vertical: toastHeight * 0.15,
        ),
        decoration: BoxDecoration(
          // Linear gradient for the background
          gradient: LinearGradient(
            colors: backgroundGradientColors,

            stops: const [0.05, 0.3], // Example: first color dominant for 5%, then transition to second by 30%
            begin: Alignment.centerLeft, // Gradient starts from the left
            end: Alignment.centerRight, // Gradient ends towards the right
          ),
          borderRadius: BorderRadius.circular(12), // Rounded corners for the toast
          boxShadow: const [
            BoxShadow(
              color: Colors.black38, // Shadow color
              blurRadius: 20, // How diffused the shadow is
              offset: Offset(0, 6), // Shadow offset (x, y)
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically in the center
          children: [
            // Circular icon container
            Container(
              width: toastHeight * 0.55,
              height: toastHeight * 0.55,
              decoration: BoxDecoration(
                color: iconBackgroundColor, // Background color for the icon circle
                shape: BoxShape.circle, // Makes the container circular
              ),
              child: Center(child: icon), // Centers the icon within its container
            ),
            SizedBox(width: toastWidth * 0.03), // Space between icon and text

            // Texts (title and optional subtitle)
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Takes minimum vertical space
                crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the start (left)
                children: [
                  Text(
                    title,
                    style: titleTextStyle ??
                        const TextStyle(
                          color: Colors.white, // Default title color
                          fontSize: 14,
                          fontFamily: 'Poppins', // Custom font family
                          fontWeight: FontWeight.w600, // Semi-bold
                          height: 1.4, // Line height
                        ),
                  ),
                  if (subtitle != null) ...[ // Only show subtitle if it's provided
                    SizedBox(height: toastHeight * 0.04), // Space between title and subtitle
                    Text(
                      subtitle!,
                      style: subtitleTextStyle ??
                          const TextStyle(
                            color: Color(0xFFC7C5C5), // Default subtitle color
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400, // Regular weight
                            height: 1.4,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}