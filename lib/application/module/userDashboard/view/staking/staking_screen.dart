import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycoinpoll_metamask/application/data/dummyData/staking_dummy_data.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';
import 'package:provider/provider.dart';
import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/components/ListingFields.dart';
import '../../../../../framework/components/buy_Ecm.dart';
import '../../../../../framework/components/percentageSelectorComponent.dart';
import '../../../../../framework/components/searchControllerComponent.dart';
 import '../../../../../framework/utils/enums/sort_option.dart';
import '../../../../domain/usecases/sort_data.dart';
import '../../../../presentation/viewmodel/wallet_view_model.dart';
import '../../viewmodel/dashboard_nav_provider.dart';
import '../../viewmodel/side_navigation_provider.dart';
import '../../../side_nav_bar.dart';
import 'widgets/staking_table.dart';
import 'package:intl/intl.dart';



class StakingScreen extends StatefulWidget {
  const StakingScreen({super.key});

  @override
  State<StakingScreen> createState() => _StakingScreenState();
}

// class _StakingScreenState extends State<StakingScreen> {
//
//   SortOption? _currentSort;
//   final SortDataUseCase _sortDataUseCase = SortDataUseCase();
//
//   TextEditingController inputController = TextEditingController();
//   final TextEditingController _searchController = TextEditingController();
//   String? _selectedDuration;
//   List<Map<String, dynamic>> _filteredData = [];
//   String _currentSelectedPercentage = dummyPercentageOptions[0];
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//
//   @override
//   void initState() {
//      super.initState();
//      _filteredData = List.from(stakingData);
//      _searchController.addListener(_onSearchChanged);
//
//   }
//
//   void _onSearchChanged() {
//
//     String query = _searchController.text.toLowerCase();
//     setState(() {
//       _filteredData = stakingData.where((row){
//         return row.values.any((value) => value.toLowerCase().contains(query));
//       }).toList();
//     });
//   }
//
//   void _sortData(SortOption option) {
//     setState(() {
//       _currentSort = option;
//       _filteredData = _sortDataUseCase(_filteredData, option);
//     });
//   }
//
//   @override
//   void dispose() {
//     inputController.dispose();
//     _searchController.dispose();
//      super.dispose();
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     final bool isPortrait = screenHeight > screenWidth;
//     final baseSize = isPortrait ? screenWidth : screenHeight;
//     final navProvider = Provider.of<NavigationProvider>(context);
//     final currentScreenId = navProvider.currentScreenId;
//     final navItems = navProvider.drawerNavItems;
//     return  Scaffold(
//         key: _scaffoldKey,
//         drawerEnableOpenDragGesture: true,
//         drawerEdgeDragWidth: 80,
//         drawer: SideNavBar(
//           currentScreenId: currentScreenId,
//           navItems: navItems,
//           onScreenSelected: (id) => navProvider.setScreen(id),
//           onLogoutTapped: () {
//             ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("Logout Pressed")));
//           },
//         ),
//         extendBodyBehindAppBar: true,
//         backgroundColor: Colors.transparent,
//
//         body: SafeArea(
//           top: false,
//           child: Container(
//               width: screenWidth,
//               height: screenHeight,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF01090B),
//                 image: DecorationImage(
//                   image: AssetImage('assets/icons/starGradientBg.png'),
//                   fit: BoxFit.cover,
//                   alignment: Alignment.topRight,
//                 ),
//               ),
//               child:
//               Column(
//                 children: [
//                   SizedBox(height: screenHeight * 0.02),
//                   Align(
//                     alignment: Alignment.topCenter,
//                     child:  Text(
//                       'ECM Staking',
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                         // fontSize: 20
//                         fontSize: screenWidth * 0.05,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: screenWidth * 0.01,
//                         vertical: screenHeight * 0.02,
//                       ),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             // SizedBox(height: screenHeight * 0.01),
//
//                             _header(),
//
//                             SizedBox(height: screenHeight * 0.02),
//
//                             _stakingDetails(),
//                             SizedBox(height: screenHeight * 0.04),
//
//                             Center(
//                               child: BlockButton(
//                                 height: baseSize * 0.12,
//                                 width: screenWidth * 0.7,
//                                 label: "Stake Now",
//                                 textStyle: TextStyle(
//                                   fontWeight: FontWeight.w700,
//                                   color: Colors.white,
//                                   fontSize: baseSize * 0.048,
//                                 ),
//                                 gradientColors: const [
//                                   Color(0xFF2680EF),
//                                   Color(0xFF1CD494),
//                                 ],
//                                 onTap: () {
//                                   debugPrint('Button tapped');
//                                 },
//                               ),
//                             ),
//
//                             SizedBox(height: screenHeight * 0.02),
//
//                             Center(
//                               child: BlockButtonV2(
//                                 text: 'Buy ECM',
//                                 trailingIcon:  Icon(Icons.shopping_cart, color: Colors.white, size: screenHeight * 0.02),
//                                 onPressed: () {
//                                   debugPrint('Button tapped!');
//                                 },
//                                 height: baseSize * 0.12,
//                                 width: screenWidth * 0.7,
//                               ),
//                             ),
//
//
//                             SizedBox(height: screenHeight * 0.030),
//                             Text(
//                               'Staking History',
//                               textAlign: TextAlign.left,
//                               style: TextStyle(
//                                 fontFamily: 'Poppins',
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: getResponsiveFontSize(context, 18),
//                                 height: 1.6,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             SizedBox(height: screenHeight * 0.030),
//
//
//
//
//                             Container(
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                   color: const Color(0xff040C16),
//                                 borderRadius: BorderRadius.circular(5),
//
//                               ),
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: screenWidth * 0.02,
//                                   vertical:  screenHeight * 0.001
//                               ),
//
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Expanded(
//                                     flex: 2,
//                                     child: ResponsiveSearchField(
//                                       controller: _searchController,
//                                       onChanged:  (value) => _onSearchChanged(),
//                                       svgAssetPath: 'assets/icons/search.svg',
//
//                                     ),
//                                   ),
//
//
//                                   Expanded(
//                                     flex: 1,
//                                     child: Align(
//                                       alignment: Alignment.centerRight,
//                                       child: PopupMenuButton<SortOption>(
//                                         icon: SvgPicture.asset(
//                                           'assets/icons/sortingList.svg',
//                                           fit: BoxFit.contain,
//                                         ),
//                                         onSelected: (SortOption option) {
//                                           _sortData(option);
//                                         },
//                                         itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
//                                           const PopupMenuItem<SortOption>(
//                                             value: SortOption.dateLatest,
//                                             child: Text('Date: Latest First'),
//                                           ),
//                                           const PopupMenuItem<SortOption>(
//                                             value: SortOption.dateOldest,
//                                             child: Text('Date: Oldest First'),
//                                           ),
//                                           const PopupMenuItem<SortOption>(
//                                             value: SortOption.statusAsc,
//                                             child: Text('Status: A-Z'),
//                                           ),
//                                           const PopupMenuItem<SortOption>(
//                                             value: SortOption.statusDesc,
//                                             child: Text('Status: Z-A'),
//                                           ),
//                                         ],
//                                       )
//                                      ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                              SizedBox(height: screenHeight * 0.016),
//                             ...[
//                               _filteredData.isNotEmpty
//                                   ? buildStakingTable(_filteredData, screenWidth, context)
//                                   : Container(
//                                 alignment: Alignment.center,
//                                 padding: const EdgeInsets.all(20),
//                                 child: const Text(
//                                   'No data found',
//                                   style: TextStyle(color: Colors.white70),
//                                 ),
//                               ),
//                             ],
//
//
//
//
//
//
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//           ),
//         )
//     );
//   }
//
//
//
//   Widget _header(){
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//      final containerWidth = screenWidth * 0.9;
//     final containerHeight = screenHeight * 0.05;
//     final imageSize = screenWidth * 0.04;
//     return Column(
//       children: [
//         Container(
//           width: screenWidth,
//           height: containerHeight,
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/icons/headerbg.png'),
//               fit: BoxFit.fill,
//             ),
//           ),
//           child: Center(
//             child: Row(
//                crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: imageSize,
//                   height: imageSize,
//                   decoration: const BoxDecoration(
//                     image: DecorationImage(
//                         image: AssetImage('assets/icons/ecmSmall.png'),
//                         fit: BoxFit.cover,
//                         filterQuality: FilterQuality.low
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 5),
//                 Text(
//                   'My 0 ECM Stack for 180 Days',
//                   style: TextStyle(
//                     color: const Color(0xffFFFFFF),
//                     fontSize: getResponsiveFontSize(context, 12),
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w600,
//                     height: 1.1,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//
//
//   Widget _stakingDetails() {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final listingFieldHeight = screenHeight * 0.048;
//
//     return Column(
//       children: [
//         Container(
//           width: double.infinity,
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/icons/stakingFrame.png'),
//               fit: BoxFit.fill,
//             ),
//           ),
//           padding: EdgeInsets.symmetric(
//               horizontal: screenWidth * 0.02,
//               vertical:  screenHeight * 0.01
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               SizedBox(height: screenHeight * 0.005),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Left side: Max + Input Amount
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         const Text(
//                           'Max: 5000',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             fontFamily: 'Poppins',
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         ListingField(
//                           labelText: 'Input Amounts',
//                           controller: inputController,
//                           height: listingFieldHeight,
//
//                           width: double.infinity,
//                           prefixPngPath: 'assets/icons/ecm.png',
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(width: 10),
//
//                   // Right side: Dropdown
//                   Expanded(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         const SizedBox(height: 26),
//                         ListingField(
//                           isDropdown: true,
//                           labelText: '', // no label
//                           prefixSvgPath: 'assets/icons/timerImg.svg',
//                           dropdownItems: const ['7 Days', '30 Days', '90 Days', '180 Days', '365 Days'],
//                           selectedDropdownItem: _selectedDuration,
//                           height: listingFieldHeight,
//                           width: double.infinity,
//                           onDropdownChanged: (newValue) {
//                             setState(() {
//                               _selectedDuration = newValue;
//                             });
//                             print('Selected duration: $newValue');
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//
//               SizedBox(height: screenHeight * 0.02),
//
//               /// Percentage Section
//               PercentageSelectorComponent(
//                 options: dummyPercentageOptions,
//                 initialSelection: _currentSelectedPercentage,
//                 onSelected: (selected) {
//                   setState(() {
//                     _currentSelectedPercentage = selected;
//                   });
//                   print('Selected: $_currentSelectedPercentage');
//                 },
//               ),
//               SizedBox(height: screenHeight * 0.02),
//
//               Center(
//                 child: SizedBox(
//                   width: screenWidth * 0.4,
//                   child: const Divider(
//                     color: Color(0xff2C2E41),
//                     thickness: 1,
//                     height: 1,
//                   ),
//                 ),
//               ),
//               SizedBox(height: screenHeight * 0.02),
//
//               /// Detail Table Section
//               Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: _detailsFrame(),
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _detailsFrame(){
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01, vertical: screenHeight * 0.008),
//       child: IntrinsicHeight(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Left Column
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _buildInfoRow("Stack amount", "0.0000 ECM"),
//                   SizedBox(height: screenHeight * 0.01),
//                   _buildInfoRow("Estimated Profit", "0 ECM", valueColor: const Color(0xFF1CD494)),
//                   SizedBox(height: screenHeight * 0.01),
//                   _buildInfoRow("Total with Reward", "0 ECM"),
//                 ],
//               ),
//             ),
//
//             SizedBox(width: screenWidth * 0.03),
//
//             // Vertical Divider
//             Container(
//               width: 1,
//               color: const Color(0xCC2C2E41),
//               height: null,
//             ),
//
//             SizedBox(width: screenWidth * 0.03),
//
//             // Right Column
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _buildInfoRow("Annual Return Rate", "0 %"),
//                   SizedBox(height: screenHeight * 0.01),
//                   _buildInfoRow("Duration", "0 days", valueColor: const Color(0xFF1CD494)),
//                   SizedBox(height: screenHeight * 0.01),
//                   _buildInfoRow("Unlocked on", "20th, May 2025"),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//
//   }
//
//   Widget _buildInfoRow(String label, String value, {Color valueColor = Colors.white}) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Flexible(
//           child: Text(
//             label,
//             style: TextStyle(
//               color: Colors.white,
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.w400,
//               fontSize: getResponsiveFontSize(context, 12),
//             ),
//           ),
//         ),
//          SizedBox(width: screenWidth * 0.01),
//         Flexible(
//           child: Text(
//             value,
//             textAlign: TextAlign.right,
//             style: TextStyle(
//               color: valueColor,
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.w400,
//               fontSize: getResponsiveFontSize(context, 12),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//
//
// }
class _StakingScreenState extends State<StakingScreen> {
   List<String> ecmPercentageOptions = ['25%', '50%', '75%', 'Max'];
  SortOption? _currentSort;
  final SortDataUseCase _sortDataUseCase = SortDataUseCase();
  TextEditingController ecmAmountController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String? _selectedDuration;
  List<Map<String, dynamic>> _filteredData = [];
  // String _currentSelectedPercentage = dummyPercentageOptions[0];
  String _currentSelectedPercentage = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  String selectedPercentage = '';

  String selectedDay = '';

  double estimatedProfit = 0.0;
  double totalWithReward = 0.0;
  DateTime? unlockDate;

  String lockOverviewText = '';
  String durationDisplayText = '';

  @override
  void initState() {
    super.initState();
    _filteredData = List.from(stakingData);
    _searchController.addListener(_onSearchChanged);
    ecmAmountController.addListener(calculateRewards);
    _selectedDuration = 'Select Duration';
    calculateRewards();
    final walletProvider = Provider.of<WalletViewModel>(context, listen: false);
    walletProvider.getBalance();
    walletProvider.getMinimunStake();
    walletProvider.getMaximumStake();

  }

  void _onSearchChanged() {

    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredData = stakingData.where((row){
        return row.values.any((value) => value.toLowerCase().contains(query));
      }).toList();
    });
  }

  void _sortData(SortOption option) {
    setState(() {
      _currentSort = option;
      _filteredData = _sortDataUseCase(_filteredData, option);
    });
  }

  @override
  void dispose() {
    ecmAmountController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  final Map<String, double> annualReturnRates = {

     '7 Days': 0.05,
    '30 Days': 0.08,
    '90 Days': 0.11,
    '180 Days': 0.15,
    '365 Days': 0.20,

  };

   void calculateRewards() {
     double ecmAmount = double.tryParse(ecmAmountController.text) ?? 0.0;
     int? numberOfDays = int.tryParse(selectedDay.replaceAll('Days', ''));
     double annualRate = annualReturnRates[selectedDay] ?? 0.00;
     double dailyRate = annualRate / 365;
     estimatedProfit = (ecmAmount > 0 && numberOfDays != null) ? ecmAmount * dailyRate * numberOfDays : 0.0;
     totalWithReward = ecmAmount + estimatedProfit;
     unlockDate = (numberOfDays != null) ? DateTime.now().add(Duration(days: numberOfDays)) : null;
     lockOverviewText = (ecmAmount > 0 && numberOfDays != null)
         ? "My ${ecmAmount.toStringAsFixed(2)} ECM Staked for $numberOfDays Days"
         : (ecmAmount > 0)
         ? "My ${ecmAmount.toStringAsFixed(2)}  ECM Staked for 0 Days"
         : (numberOfDays != null)
         ? "Staking for $numberOfDays Days selected"
         : "";
     setState(() {});
   }


   String formatDateWithSuffix(DateTime date) {
    int day = date.day;
    String suffix = 'th';
    if (day == 1 || day == 21 || day == 31) {
      suffix = 'st';
    } else if (day == 2 || day == 22) suffix = 'nd';
    else if (day == 3 || day == 23) suffix = 'rd';

    String formatted = "$day$suffix, ${DateFormat('MMMM yyyy hh:mm a').format(date)}";
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final bool isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;
    final navProvider = Provider.of<NavigationProvider>(context);
    final currentScreenId = navProvider.currentScreenId;
    final navItems = navProvider.drawerNavItems;
    return  Scaffold(
        key: _scaffoldKey,
        drawerEnableOpenDragGesture: true,
        drawerEdgeDragWidth: 80,
        drawer: SideNavBar(
          currentScreenId: currentScreenId,
          navItems: navItems,
          onScreenSelected: (id) => navProvider.setScreen(id),
          onLogoutTapped: () {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Logout Pressed")));
          },
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,

        body: SafeArea(
          top: false,
          child: Container(
              width: screenWidth,
              height: screenHeight,
              decoration: const BoxDecoration(
                color: Color(0xFF01090B),
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
                        horizontal: screenWidth * 0.01,
                        vertical: screenHeight * 0.02,
                      ),
                      child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(overscroll: false),

                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),


                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // SizedBox(height: screenHeight * 0.01),

                              _header(),

                              SizedBox(height: screenHeight * 0.02),

                              _stakingDetails(),
                              SizedBox(height: screenHeight * 0.04),

                              Center(
                                child: BlockButton(
                                  height: baseSize * 0.12,
                                  width: screenWidth * 0.7,
                                  label: "Stake Now",
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: baseSize * 0.048,
                                  ),
                                  gradientColors: const [
                                    Color(0xFF2680EF),
                                    Color(0xFF1CD494),
                                  ],
                                  onTap: () {
                                    debugPrint('Button tapped');
                                  },
                                  leadingIconPath: 'assets/icons/arrowIcon.svg',
                                  iconSize : screenHeight * 0.013,
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.02),

                              Center(
                                child: BlockButtonV2(
                                  text: 'Buy ECM',
                                  leadingImagePath: 'assets/icons/buyEcmLeadingImg.svg',
                                  // trailingIcon:  Icon(Icons.shopping_cart, color: Colors.white, size: screenHeight * 0.02),
                                  onPressed: () {
                                    debugPrint('Button tapped!');
                                    Provider.of<DashboardNavProvider>(context, listen: false).setIndex(1);

                                  },
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: baseSize * 0.048,
                                  ),
                                  height: baseSize * 0.12,
                                  width: screenWidth * 0.7,
                                ),
                              ),


                              SizedBox(height: screenHeight * 0.030),
                              Text(
                                'Staking History',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: getResponsiveFontSize(context, 18),
                                  height: 1.6,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.030),




                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xff040C16),
                                  borderRadius: BorderRadius.circular(5),

                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.02,
                                    vertical:  screenHeight * 0.001
                                ),

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: ResponsiveSearchField(
                                        controller: _searchController,
                                        onChanged:  (value) => _onSearchChanged(),
                                        svgAssetPath: 'assets/icons/search.svg',

                                      ),
                                    ),


                                    Expanded(
                                      flex: 1,
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: PopupMenuButton<SortOption>(
                                            icon: SvgPicture.asset(
                                              'assets/icons/sortingList.svg',
                                              fit: BoxFit.contain,
                                            ),
                                            onSelected: (SortOption option) {
                                              _sortData(option);
                                            },
                                            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
                                              const PopupMenuItem<SortOption>(
                                                value: SortOption.dateLatest,
                                                child: Text('Date: Latest First'),
                                              ),
                                              const PopupMenuItem<SortOption>(
                                                value: SortOption.dateOldest,
                                                child: Text('Date: Oldest First'),
                                              ),
                                              const PopupMenuItem<SortOption>(
                                                value: SortOption.statusAsc,
                                                child: Text('Status: A-Z'),
                                              ),
                                              const PopupMenuItem<SortOption>(
                                                value: SortOption.statusDesc,
                                                child: Text('Status: Z-A'),
                                              ),
                                            ],
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.016),
                              ...[
                                _filteredData.isNotEmpty
                                    ? buildStakingTable(_filteredData, screenWidth, context)
                                    : Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(20),
                                  child: const Text(
                                    'No data found',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                              ],






                            ],
                          ),
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
                  // 'My 0 ECM Stack for 180 Days',
                  lockOverviewText.isNotEmpty ? lockOverviewText : "Enter ECM to Stake",
                  style: TextStyle(
                    color: const Color(0xffFFFFFF),
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

                        Consumer<WalletViewModel>(builder: (context, model, child){
                          return Text(
                            // 'Max: 5000',
                            'Max: ${model.maximumStake ?? '...'} ECM',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          );

                        }
                        ),


                        const SizedBox(height: 6),
                        ListingField(
                          labelText: 'Input Amounts',
                          controller: ecmAmountController,
                          height: listingFieldHeight,
                          onChanged: (value) {
                            setState(() {
                              selectedPercentage = '';
                            });
                          },
                          width: double.infinity,
                          prefixPngPath: 'assets/icons/ecm.png',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Right side: Dropdown
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(height: 26),
                        ListingField(
                          isDropdown: true,
                          labelText: '', // no label
                          prefixSvgPath: 'assets/icons/timerImg.svg',
                          dropdownItems: const ['Select Duration','7 Days', '30 Days', '90 Days', '180 Days', '365 Days'],
                           selectedDropdownItem: _selectedDuration,
                          height: listingFieldHeight,
                          width: double.infinity,
                          onDropdownChanged: (newValue) {

                            if (newValue == null || newValue.isEmpty || newValue == 'Select Duration') return;
                            setState(() {
                              _selectedDuration = newValue;
                              selectedDay = newValue;
                            });
                            calculateRewards();
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
              Consumer<WalletViewModel>(builder: (context, walletVM, child){
                final balanceStr = walletVM.balance;
                final balance = double.tryParse(balanceStr ?? '0') ?? 0.0;
                print('UI sees balance: $balance');
                return PercentageSelectorComponent(
                  options: ecmPercentageOptions,
                  initialSelection: _currentSelectedPercentage,
                  onSelected: (selected) {

                    double percentageValue;
                    switch (selected) {
                      case '25%':
                        percentageValue = balance * 0.25;
                        break;
                      case '50%':
                        percentageValue = balance * 0.50;
                        break;
                      case '75%':
                        percentageValue = balance * 0.75;
                        break;
                      case 'Max':
                        percentageValue = balance;
                        break;
                      default:
                        percentageValue = 0.0;
                    }
                    ecmAmountController.text = percentageValue.toStringAsFixed(2);
                    calculateRewards();
                    setState(() {
                      _currentSelectedPercentage = selected;
                    });
                    print('Selected: $_currentSelectedPercentage');

                  },
                );
              }),
              SizedBox(height: screenHeight * 0.02),

              Center(
                child: SizedBox(
                  width: screenWidth * 0.4,
                  child: const Divider(
                    color: Color(0xff2C2E41),
                    thickness: 1,
                    height: 1,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              /// Detail Table Section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _detailsFrame(),
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
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01, vertical: screenHeight * 0.008),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildInfoRow("Stack amount", "${ecmAmountController.text} ECM"),
                  SizedBox(height: screenHeight * 0.01),
                  _buildInfoRow("Estimated Profit","${estimatedProfit.toStringAsFixed(3)} ECM", valueColor: const Color(0xFF1CD494)),
                  SizedBox(height: screenHeight * 0.01),
                  _buildInfoRow("Total with Reward","${totalWithReward.toStringAsFixed(3)} ECM"),
                ],
              ),
            ),

            SizedBox(width: screenWidth * 0.03),

            // Vertical Divider
            Container(
              width: 1,
              color: const Color(0xCC2C2E41),
              height: null,
            ),

            SizedBox(width: screenWidth * 0.03),

            // Right Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildInfoRow("Annual Return Rate",  "${(annualReturnRates[selectedDay] ?? 0.00) * 100}%"),
                  SizedBox(height: screenHeight * 0.01),
                  _buildInfoRow("Duration", "${selectedDay.replaceAll('Days', '')} Days", valueColor: const Color(0xFF1CD494)),
                  SizedBox(height: screenHeight * 0.01),
                  _buildInfoRow("Unlocked on", unlockDate != null ? formatDateWithSuffix(unlockDate!) : "Not Available"),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }

  Widget _buildInfoRow(String label, String value, {Color valueColor = Colors.white}) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: getResponsiveFontSize(context, 12),
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.01),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: valueColor,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: getResponsiveFontSize(context, 12),
            ),
          ),
        ),
      ],
    );
  }



}






