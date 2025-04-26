import 'package:flutter/material.dart';

import '../../../framework/components/gradient_animation_button.dart';


class EcmStakingScreen extends StatefulWidget {
  const EcmStakingScreen({super.key});

  @override
  State<EcmStakingScreen> createState() => _EcmStakingScreenState();
}
class _EcmStakingScreenState extends State<EcmStakingScreen> {
  String selectedPercentage = '25%'; // Default selected
  String selectedDay = '7D'; // Default selected

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFF0A1C2F),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'ECM Staking',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0x4d03080e),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF0A1C2F),
                Color(0xFF060D13),
              ],
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02), // 5% padding from each side
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),

                ///Stack Input ECM and Percentage Section
                ecmInputSection(textScale, screenWidth, screenHeight),

                SizedBox(height: 8),

                /// Stack ECM Validity And Day's Section
                validitySection(textScale, screenWidth, screenHeight),

                SizedBox(height: 8),

                /// Lock OverView Container
                lockOverViewSection(textScale, screenWidth, screenHeight),
                SizedBox(height: 18),

                /// Stack Amount , Profile , Total Reward Section
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                   decoration: BoxDecoration(
                     color: Colors.transparent,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.blueGrey.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                      _ecmAmountRow("Stack amount", "100 ECM"),
                      const Divider(color: Colors.white24,thickness: 1,),
                      _ecmAmountRow("Estimated Profit", "0.658 ECM", highlight: true),
                      const Divider(color: Colors.white24),
                      _ecmAmountRow("Total with Reward", "100.658 ECM"),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.blueGrey.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ecmValidityRow("Annual Return Rate", "5%"),
                      const Divider(color: Colors.white24,thickness: 1,),
                      _ecmValidityRow("Duration", "7 Days", highlight: true),
                      const Divider(color: Colors.white24),
                      _ecmValidityRow("Unlocked on", "3rd, May 2025 11:26 PM"),
                    ],
                  ),
                ),
                SizedBox(height: 8),

                Center(
                  child: GradientButton(
                    text: "Stake Now",
                    trailingIcon: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      //  Add your action here
                      print("Button Pressed!");
                    },
                  ),
                ),
               ],
            ),
          ),
        ),
      ),
    );
  }



  Widget ecmInputSection(double textScale, double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Min: 20 ECM',
                style: TextStyle(
                  fontSize: 12 * textScale,
                  color: Colors.white60,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                ),
              ),
              Text(
                'Max: 5000 ECM',
                style: TextStyle(
                  fontSize: 12 * textScale,
                  color: Colors.white60,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        // Input Field with Leading Icon and Trailing Balance
        Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01, vertical: screenHeight * 0.003),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
          ),
          child: Row(
            children: [
              // Leading icon
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/ecm.png',
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Input field
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),

              // Trailing balance
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Balance',
                    style: TextStyle(
                      fontSize: 12 * textScale,
                      color: Colors.white60,
                    ),
                  ),
                  Text(
                    '0 ECM',
                    style: TextStyle(
                      fontSize: 12 * textScale,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 3),

        // Percentage Buttons Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _percentageButton('25%', textScale),
            _percentageButton('50%', textScale),
            _percentageButton('75%', textScale),
            _percentageButton('Max', textScale),
          ],
        ),
      ],
    );
  }
  Widget _percentageButton(String text, double textScale) {
    bool isSelected = selectedPercentage == text;

    return InkWell(
      onTap: () {
        setState(() {
          selectedPercentage = text;
        });
        print('Selected Percentage: $selectedPercentage');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(

          // No gradient here, we'll create it in the root container
          borderRadius: BorderRadius.circular(30),
          color: Colors.transparent,
        ),
        child: Container(
          padding: const EdgeInsets.all(2), // Creates space for the border effect
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.transparent,
            ),
            child: Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white24,
                      width: 2,
                    ),
                    gradient: isSelected
                        ? LinearGradient(
                      colors: [
                        Color(0xFF2D8EFF),
                        Color(0xFF2EE4A4),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : null,
                  ),
                  child: isSelected
                      ? Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  )
                      : null,
                ),
                const SizedBox(width: 6),
                Text(
                  text,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14 * textScale,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _ecmAmountRow(String title, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: highlight ? Colors.greenAccent : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }




  Widget validitySection(double textScale, double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current: 0 ECM',
                style: TextStyle(
                  fontSize: 12 * textScale,
                  color: Colors.white60,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                ),
              ),
              Text(
                'Remaining: 0 ECM',
                style: TextStyle(
                  fontSize: 12 * textScale,
                  color: Colors.white60,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        // Input Field with Leading Icon and Trailing Balance
        Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01, vertical: screenHeight * 0.003),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
          ),
          child: Row(
            children: [
              // Leading icon
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/timer.png',
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Input field
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),

              // Trailing balance
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Days',
                    style: TextStyle(
                      fontSize: 12 * textScale,
                      color: Colors.white,
                    ),
                  ),
                 ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 2),

        // Percentage Buttons Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              _validityButton('7D', textScale),
              _validityButton('30D', textScale),
              _validityButton('90D', textScale),
              _validityButton('180D', textScale),
              _validityButton('365D', textScale),
            ],
          ),
        ),
      ],
    );
  }
  Widget _validityButton(String text, double textScale) {
    bool isSelected = selectedDay == text;

    return InkWell(
      onTap: () {
        setState(() {
          selectedDay = text;
        });
        print('Selected Percentage: $selectedDay');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.transparent,
        ),
        child: Container(
          padding: const EdgeInsets.all(2), // Creates space for the border effect
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white24,
                      width: 2,
                    ),
                    gradient: isSelected
                        ? LinearGradient(
                      colors: [
                        Color(0xFF2D8EFF),
                        Color(0xFF2EE4A4),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : null,
                  ),
                  child: isSelected
                      ? Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  )
                      : null,
                ),
                const SizedBox(width: 6),
                Text(
                  text,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14 * textScale,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _ecmValidityRow(String title, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: highlight ? Colors.greenAccent : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }




  Widget lockOverViewSection(double textScale, double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02), // Responsive padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Lock Overview',
                style: TextStyle(
                  fontSize: 14 * textScale, // Slightly bigger and responsive
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.01), // Responsive vertical space

        // Input Field with Leading Icon and Text
        Container(
          width: double.infinity, // Full width
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.01,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenWidth * 0.03), // Responsive border radius
            gradient: const LinearGradient(
              colors: [
                Color(0xFF2D8EFF),
                Color(0xFF2EE4A4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Leading icon
                Container(
                  width: screenWidth * 0.08, // Icon container width responsive
                  height: screenWidth * 0.08, // Icon container height responsive (square)
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/icons/timer.png',
                      width: screenWidth * 0.05, // Icon size responsive
                      height: screenWidth * 0.05,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.02), // Responsive spacing

                // Main Text
                Text(
                  'My 100 ECM Stack for 7 Days',
                  style: TextStyle(
                    fontSize: 18 * textScale, // Responsive text size
                    color: Colors.white,
                    // fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


}




