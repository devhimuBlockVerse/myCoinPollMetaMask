import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';

import '../../../../../framework/components/ListingFields.dart';
const List<String> dummyPercentageOptions = ['25%', '50%', '75%', 'Max'];

class StakingScreen extends StatefulWidget {
  const StakingScreen({super.key});

  @override
  State<StakingScreen> createState() => _StakingScreenState();
}

class _StakingScreenState extends State<StakingScreen> {


  TextEditingController inputController = TextEditingController();
  String? _selectedDuration; // State for the selected dropdown item


  // String _currentSelectedPercentage = '25%'; // Initial selected value
  String _currentSelectedPercentage = dummyPercentageOptions[0]; // Initial selected value from dummy data


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  void dispose() {
    inputController.dispose();
     super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return  Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,

        body: SafeArea(
          top: false,
          child: Container(
              width: screenWidth,
              height: screenHeight,
              decoration: BoxDecoration(
                color: const Color(0xFF01090B),
                image: DecorationImage(
                  image: AssetImage('assets/icons/starGradientBg.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topRight,
                ),
              ),
              child:
              Column(
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Align(
                    alignment: Alignment.topCenter,
                    child:  Text(
                      'ECM Staking',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        // fontSize: 20
                        fontSize: screenWidth * 0.05,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.02,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: screenHeight * 0.01),

                            _header(),

                            SizedBox(height: screenHeight * 0.04),

                            _stakingDetails(),
                            SizedBox(height: screenHeight * 0.04),


                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
          ),
        )
    );
  }


  Widget _header(){
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

     final containerWidth = screenWidth * 0.9;
    final containerHeight = screenHeight * 0.05;
    final imageSize = screenWidth * 0.04;
    return Column(
      children: [
        Container(
          width: screenWidth,
          height: containerHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/headerbg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: Row(
               crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/icons/ecmSmall.png'),
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.low
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  'My 0 ECM Stack for 180 Days',
                  style: TextStyle(
                    color: Color(0xffFFFFFF),
                    fontSize: getResponsiveFontSize(context, 12),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }



  Widget _stakingDetails() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final listingFieldHeight = screenHeight * 0.048;

    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/stakingFrame.png'),
              fit: BoxFit.fill,
            ),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02,
              vertical:  screenHeight * 0.01
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: screenHeight * 0.005),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side: Max + Input Amount
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Max: 5000',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 6),
                        ListingField(
                          labelText: 'Input Amounts',
                          controller: inputController,
                          height: listingFieldHeight,
                          width: double.infinity,
                          prefixPngPath: 'assets/icons/ecm.png',
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 10),

                  // Right side: Dropdown
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(height: 26),
                        ListingField(
                          isDropdown: true,
                          labelText: '', // no label
                          prefixSvgPath: 'assets/icons/timerImg.svg',
                          dropdownItems: const ['7 Days', '30 Days', '90 Days', '180 Days', '365 Days'],
                          selectedDropdownItem: _selectedDuration,
                          height: listingFieldHeight,
                          width: double.infinity,
                          onDropdownChanged: (newValue) {
                            setState(() {
                              _selectedDuration = newValue;
                            });
                            print('Selected duration: $newValue');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.02),

              /// Percentage Section
              PercentageSelectorComponent(
                options: dummyPercentageOptions,
                initialSelection: _currentSelectedPercentage,
                onSelected: (selected) {
                  setState(() {
                    _currentSelectedPercentage = selected;
                  });
                  print('Selected: $_currentSelectedPercentage');
                },
              ),
              SizedBox(height: screenHeight * 0.02),

              Center(
                child: SizedBox(
                  width: screenWidth * 0.4,
                  child: Divider(
                    color: Color(0xff2C2E41),
                    thickness: 1,
                    height: 1,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              /// Detail Table Section
              Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.2),
                      child: _detailsFrame(),
                    ),
                  ]
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _detailsFrame(){
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.03),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow("Stack amount", "0.0000 ECM"),
                  SizedBox(height: 10),
                  _buildInfoRow("Estimated Profit", "0 ECM", valueColor: Color(0xFF1CD494)),
                  SizedBox(height: 10),
                  _buildInfoRow("Total with Reward", "0 ECM"),
                ],
              ),
            ),

            SizedBox(width: 10),

            // Vertical Divider
            Container(
              width: 1,
              color: Color(0xCC2C2E41),
            ),

            SizedBox(width: 10),

            // Right Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow("Annual Return Rate", "0 %"),
                  SizedBox(height: 10),
                  _buildInfoRow("Duration", "0 days", valueColor: Color(0xFF1CD494)),
                  SizedBox(height: 10),
                  _buildInfoRow("Unlocked on", "20th, May 2025"),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
  Widget _buildInfoRow(String label, String value, {Color valueColor = Colors.white}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: getResponsiveFontSize(context, 10),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: valueColor,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: getResponsiveFontSize(context, 10),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }


}






/// Reusable Component
class PercentageSelectorComponent extends StatefulWidget {
  final List<String> options;
  final ValueChanged<String> onSelected;
  final String initialSelection;

  const PercentageSelectorComponent({
    Key? key,
    required this.options,
    required this.onSelected,
    required this.initialSelection,
  }) : super(key: key);

  @override
  State<PercentageSelectorComponent> createState() => _PercentageSelectorComponentState();
}

class _PercentageSelectorComponentState extends State<PercentageSelectorComponent> {
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final orientation = mediaQuery.orientation;

    double baseFontSize = (orientation == Orientation.portrait)
        ? screenWidth * 0.045
        : screenHeight * 0.045;

    double baseIconSize = (orientation == Orientation.portrait)
        ? screenWidth * 0.01
        : screenHeight * 0.01;

    double horizontalPadding = screenWidth * 0.02;
    double spacing = screenWidth * 0.006;

    baseFontSize = baseFontSize.clamp(14.0, 24.0);
    baseIconSize = baseIconSize.clamp(20.0, 35.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(widget.options.length, (index) {
          final option = widget.options[index];
          final isSelected = (_selectedOption == option);

          final gestureWidget = GestureDetector(
            onTap: () {
              setState(() {
                _selectedOption = option;
              });
              widget.onSelected(option);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [Color(0xFF2AFFED), Color(0xFF3893FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: Container(
                    width: baseIconSize,
                    height: baseIconSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0 * (baseIconSize / 20),
                      ),
                    ),
                    child: Center(
                      child: isSelected
                          ? Container(
                        width: baseIconSize * 0.5,
                        height: baseIconSize * 0.5,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF2AFFED), Color(0xFF3893FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      )
                          : null,
                    ),
                  ),
                ),
                SizedBox(width: spacing),
                Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                    fontSize: getResponsiveFontSize(context, 12),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              gestureWidget,
              if (index < widget.options.length - 1) SizedBox(width: screenWidth * 0.015), // spacing between GestureDetectors
            ],
          );
        }),
      ),
    );
  }

}


