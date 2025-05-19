import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;

    // Dynamic multipliers
    final baseSize = isPortrait ? screenWidth : screenHeight;
    return Scaffold(

      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
             image: DecorationImage(
               image: AssetImage('assets/icons/starGradientBg.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.01,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                children: [

                  ///MyCoinPoll & Connected Wallet Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(
                        padding: EdgeInsets.only(
                            top: screenHeight * 0.01,
                            right: screenWidth * 0.02
                        ),
                        child: Image.asset(
                          'assets/icons/mycoinpolllogo.png',
                          width: screenWidth * 0.40,
                          height: screenHeight * 0.040,
                          fit: BoxFit.contain,
                        ),
                      ),

                      /// Connected Wallet Button
                      Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.01,
                          right: screenWidth * 0.02,
                        ), // Padding to Button
                        child:ButtonMedium()
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



class ButtonMedium extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 85.12,
          height: 20.36,
          padding: const EdgeInsets.only(
            top: 4.19,
            left: 7.95,
            right: 4.19,
            bottom: 4.19,
          ),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Color(0x0A5FECE2),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Color(0xFF17F1FF)),
              borderRadius: BorderRadius.circular(10.34),
            ),
            shadows: [
              BoxShadow(
                color: Color(0xFF1CD494),
                blurRadius: 6.10,
                offset: Offset(0, 0),
                spreadRadius: 0,
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '0xe2...e094',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontFamily: 'Poppins',
                        height: 0.08,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 11.99,
                      height: 11.99,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 11.99,
                              height: 11.99,
                              decoration: ShapeDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(0.71, -0.71),
                                  end: Alignment(-0.71, 0.71),
                                  colors: [Color(0xFF17F1FF), Color(0xFF3817FF)],
                                ),
                                shape: OvalBorder(),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 2.51,
                            top: 2.51,
                            child: Container(
                              width: 6.70,
                              height: 6.70,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(),
                              child: Stack(children: [

                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}