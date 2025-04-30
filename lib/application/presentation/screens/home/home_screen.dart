import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFF0B0A1E),
      body: Stack(
       children: [
         Positioned(
           // top: -screenHeight * 0.12,
           // right: -screenWidth * 0.2,

           top: -screenHeight * 0.01,
           right: -screenWidth * 0.09,
           child: Container(
             // width: screenWidth * 0.7,
             // height: screenWidth * 0.7,
             width: screenWidth ,
             height: screenWidth ,
             decoration: BoxDecoration(
               shape: BoxShape.circle,
               // gradient: RadialGradient(
               //   colors: [
               //     Color(0xFF0066FF).withOpacity(0.4),
               //     Colors.transparent,
               //   ],
               //   radius: 0.8,
               // ),
             ),
             child: Image.asset(
               'assets/icons/gradientBgImage.png',
               width: screenWidth ,
               height: screenHeight ,
               fit: BoxFit.fill,
             ),
           ),

         ),

         SafeArea(
           child: Padding(
             padding: EdgeInsets.symmetric(
               horizontal: screenWidth * 0.04,
               vertical: screenHeight * 0.02,
             ),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Image.asset(
                   'assets/icons/mycoinpolllogo.png',
                   width: screenWidth * 0.32,
                   fit: BoxFit.contain,
                 ),
                 
                 Row(
                   children: [
                     // Settings Button
                     GestureDetector(
                       onTap: (){

                       },
                       child:  Image.asset(
                         'assets/icons/settingsIcon.png',
                         width: screenWidth * 0.06,
                         height: screenWidth * 0.06,
                         color: Colors.white,
                       ),
                     ),
                   ],
                 )
                 
               ],
             ),
           ),
         ),

         SafeArea(
             child: Center(
                 child: Text(
                   'Home Screen',
                   style: TextStyle(color: Colors.white),
                 )
             )
         ),

       ]
      ),
    );
  }
}
