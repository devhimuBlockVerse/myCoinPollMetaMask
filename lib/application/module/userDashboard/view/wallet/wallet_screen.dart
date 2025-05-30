import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../../framework/components/searchControllerComponent.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/sort_option.dart';
import '../../../../data/dummyData/staking_dummy_data.dart';
import '../../../../domain/usecases/sort_data.dart';
import '../../../../presentation/viewmodel/bottom_nav_provider.dart';
import '../../viewmodel/side_navigation_provider.dart';
import '../../../side_nav_bar.dart';
import '../transactions/widgets/transaction_table.dart';
 class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {


  SortTransactionHistoryOption? _currentSort;
  final SortTransactionDataUseCase _sortDataUseCase = SortTransactionDataUseCase();
  TextEditingController inputController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _displayData = [];


  @override
  void initState() {
    super.initState();
    _displayData = List.from(transactionData);
    _searchController.addListener(_applyFiltersAndSort);

  }


  void _applyFiltersAndSort() {
    List<Map<String, dynamic>> currentFilteredData = List.from(transactionData);
    String query = _searchController.text.toLowerCase();

    //  search filter
    if (query.isNotEmpty) {
      currentFilteredData = currentFilteredData.where((row) {
        return (row['TxnHash']?.toLowerCase().contains(query) ?? false) ||
            (row['Status']?.toLowerCase().contains(query) ?? false) ||
            (row['Amount']?.toLowerCase().contains(query) ?? false) ||
            (row['DateTime']?.toLowerCase().contains(query) ?? false) ||
            (row['SL']?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    //  sorting if a sort option is selected
    if (_currentSort != null) {
      currentFilteredData = _sortDataUseCase(currentFilteredData, _currentSort!);
    }

    setState(() {
      _displayData = currentFilteredData;
    });
  }



  void _sortData(SortTransactionHistoryOption option) {
    setState(() {
      _currentSort = option;
      _applyFiltersAndSort();
    });
  }

  @override
  void dispose() {
    inputController.dispose();
    _searchController.dispose();
    _searchController.removeListener(_applyFiltersAndSort);

    super.dispose();
  }



  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final bool isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    final containerWidth = screenWidth;
    final containerHeight = screenHeight * 0.10;
    final minContainerHeight = screenHeight * 0.002;

    final horizontalPadding = containerWidth * 0.03;
    final itemSpacing = screenWidth * 0.02;

    double getResponsiveRadius(double base) => base * (screenWidth / 360);
    final navProvider = Provider.of<NavigationProvider>(context);
    final currentScreenId = navProvider.currentScreenId;
    final navItems = navProvider.drawerNavItems;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: 80,
      drawer: SideNavBar(
        currentScreenId: currentScreenId,
        navItems: navItems,
        onScreenSelected: (id) => navProvider.setScreen(id),
        onLogoutTapped: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Logout Pressed")),
          );
        },
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          // height: screenHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/starGradientBg.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
            ),
          ),
          child: Column(
            children: [
              // App bar row
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/back_button.svg',
                      color: Colors.white,
                      width: screenWidth * 0.04,
                      height: screenWidth * 0.04,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Wallet',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.05,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.12),
                ],
              ),

              // Main content area
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.01,
                    vertical: screenHeight * 0.01,
                  ),
                  child: ListView(
                    children: [

                      CardPrice(),

                      SizedBox(height: screenHeight * 0.030),
                      SizedBox(height: screenHeight * 0.030),
                      Text(
                        'Recent Transactions',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: getResponsiveFontSize(context, 17),
                          height: 1.6,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.030),


                      /// Search Controller with Data Sorting Button
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              flex: 2,
                              child: ResponsiveSearchField(
                                controller: _searchController,
                                // onChanged:  (value) => _onSearchChanged(),
                                onChanged:  (value) => _applyFiltersAndSort(),
                                svgAssetPath: 'assets/icons/search.svg',

                              ),
                            ),


                            /// Data Sorting  Button
                            Expanded(
                              flex: 1,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: PopupMenuButton<SortTransactionHistoryOption>(
                                    icon: SvgPicture.asset(
                                      'assets/icons/sortingList.svg',
                                      fit: BoxFit.contain,
                                    ),
                                    onSelected: (SortTransactionHistoryOption option) {
                                      _sortData(option);
                                    },
                                    itemBuilder: (BuildContext context) => <PopupMenuEntry<SortTransactionHistoryOption>>[
                                      const PopupMenuItem<SortTransactionHistoryOption>(
                                        value: SortTransactionHistoryOption.dateLatest,
                                        child: Text('Date: Latest First'),
                                      ),
                                      const PopupMenuItem<SortTransactionHistoryOption>(
                                        value: SortTransactionHistoryOption.dateOldest,
                                        child: Text('Date: Oldest First'),
                                      ),
                                      const PopupMenuItem<SortTransactionHistoryOption>(
                                        value: SortTransactionHistoryOption.statusAsc,
                                        child: Text('Status: A-Z'),
                                      ),
                                      const PopupMenuItem<SortTransactionHistoryOption>(
                                        value: SortTransactionHistoryOption.statusDesc,
                                        child: Text('Status: Z-A'),
                                      ),
                                      const PopupMenuItem<SortTransactionHistoryOption>(
                                        value: SortTransactionHistoryOption.amountAsc,
                                        child: Text('Amount: Low to High'),
                                      ),
                                      const PopupMenuItem<SortTransactionHistoryOption>(
                                        value: SortTransactionHistoryOption.amountDesc,
                                        child: Text('Amount: High to Low'),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.016),


                      /// Table View
                      ...[

                        _displayData.isNotEmpty
                            ? buildTransactionTable(_displayData, screenWidth, context)
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
            ],
          ),
        ),
      ),
    );
  }

}


// class CardPrice extends StatelessWidget {
//   final List<String> _labels = ['With Draw', 'Transfer', 'Scan', 'Gift'];
//   final List<String> _imgPaths = [
//     'assets/icons/withDraw.svg',
//     'assets/icons/transfer.svg',
//     'assets/icons/scan.svg',
//     'assets/icons/gift.svg',
//   ];
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final currentIndex = Provider.of<BottomNavProvider>(context).currentIndex;
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/icons/walletCardBg.png'),
//               fit: BoxFit.fill,
//             ),
//           ),
//           padding:  EdgeInsets.symmetric(vertical: 24, horizontal: screenWidth * 0.05),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// Top Row
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//
//                 children: [
//                   /// Wallet Info and Growth
//                   Expanded(
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         /// Wallet Info
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               textAlign: TextAlign.start,
//                               'Total Wallet Balance:',
//                               style: TextStyle(
//                                 color: Color(0xCCFFF5ED),
//                                 fontFamily: 'Poppins',
//                                 fontSize: getResponsiveFontSize(context, 12),
//                                 fontWeight: FontWeight.w400,
//                                 height: 1.3,
//
//                               ),
//                             ),
//                             const SizedBox(height: 5),
//                             Text(
//                               '\$ 10,1542.00',
//                               style: TextStyle(
//                                 color: Color(0xffFFF5ED),
//                                 fontFamily: 'Poppins',
//                                 fontSize: getResponsiveFontSize(context, 18),
//                                 fontWeight: FontWeight.w500,
//                                 height: 1.3,
//                               ),
//                             ),
//                           ],
//                         ),
//
//                         /// Growth %
//                         Container(
//
//                           decoration: BoxDecoration(
//                             color: const Color(0x1915FF10),
//                             borderRadius: BorderRadius.circular(24),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               const Icon(Icons.arrow_drop_up_sharp, color: Color(0xFF37CAB0), size: 24),
//                                Text(
//                                 '+0.8%',
//                                  textAlign: TextAlign.start,
//                                  style: TextStyle(
//                                    color: Color(0xff37CBB0),
//                                    fontFamily: 'Poppins',
//                                    fontSize: getResponsiveFontSize(context, 12),
//                                    fontWeight: FontWeight.w500,
//                                    height: 1.3,
//                                  ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   /// Add Funds
//                   InkWell(
//                     onTap: (){
//                       debugPrint("Add Funds");
//                     },
//                     child: Column(
//                       children: [
//                         Container(
//                           width: 30,
//                           height: 30,
//                            decoration: BoxDecoration(
//                              image: DecorationImage(
//                                image: AssetImage('assets/icons/addFundsBg.png'),
//                                fit: BoxFit.fill,
//                              ),
//                           ),
//                           child: Center(
//                             child: SvgPicture.asset(
//                               "assets/icons/addIcon.svg",
//                               width: 18,
//                               height: 18,
//                               fit: BoxFit.fill,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           'Add Funds',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontFamily: 'Poppins',
//                             fontSize: getResponsiveFontSize(context, 12),
//                             fontWeight: FontWeight.w400,
//
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 10),
//
//               /// Balance Row
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   /// Available Funds
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Available Funds :',
//                         style: TextStyle(
//                           color: Color(0xffFFF5ED).withOpacity(0.80),
//                           fontFamily: 'Poppins',
//                           fontSize: getResponsiveFontSize(context, 12),
//                           fontWeight: FontWeight.w400,
//                           height: 1.3,
//                         ),
//
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         '\$ 1541.00',
//                         style: TextStyle(
//                           color: Color(0xffFFF5ED),
//                           fontFamily: 'Poppins',
//                           fontSize: getResponsiveFontSize(context, 18),
//                           fontWeight: FontWeight.w500,
//                           height: 1.3,
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   /// Coins
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//
//                       Row(
//                         children: [
//                           Image.asset(
//                             'assets/icons/BTC.png',
//                             width: 20,
//                             height: 20,
//                             fit: BoxFit.contain,
//                           ),
//                           const SizedBox(width: 5),
//                           Text(
//                             '1.25 BTC',
//                             style: TextStyle(
//                               color: Color(0xffFFF5ED),
//                               fontFamily: 'Poppins',
//                               fontSize: getResponsiveFontSize(context, 14),
//                               fontWeight: FontWeight.w500,
//                               height: 1.3,
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(width: 16),
//
//                       Row(
//                         children: [
//                           Image.asset(
//                             'assets/icons/EthCoin.png',
//                             width: 20,
//                             height: 20,
//                             fit: BoxFit.contain,
//                           ),
//                           const SizedBox(width: 5),
//                           Text(
//                             '265.0 ETH',
//                             style: TextStyle(
//                               color: Color(0xffFFF5ED),
//                               fontFamily: 'Poppins',
//                               fontSize: getResponsiveFontSize(context, 14),
//                               fontWeight: FontWeight.w500,
//                               height: 1.3,
//                             ),
//                           ),
//                         ],
//                       ),
//
//
//                      ],
//                   ),
//                 ],
//               ),
//
//               /// Divider
//
//               Center(
//                 child: SizedBox(
//                   width: screenWidth * 0.9,
//                   child: const Divider(
//                     color: Colors.white12,
//                     thickness: 2,
//                     height: 20,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 10),
//               /// Action Icons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: List.generate(_labels.length, (index) {
//                   return InkWell(
//                     onTap: () {
//                       Provider.of<BottomNavProvider>(context,
//                           listen: false)
//                           .setIndex(index);
//                     },
//                     child: Column(
//                       children: [
//                         SvgPicture.asset(
//                           _imgPaths[index],
//                           color: Colors.white,
//                           width: 26,
//                           height: 26,
//                         ),
//                         const SizedBox(height: 5),
//                         Text(
//                           _labels[index],
//                           style: TextStyle(
//                             color:Colors.white,
//                             fontFamily: 'Poppins',
//                             fontSize: getResponsiveFontSize(context, 12),
//                             fontWeight: FontWeight.w400,
//                             height: 1.6 ,
//
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }



class CardPrice extends StatelessWidget {
  final List<String> _labels = ['With Draw', 'Transfer', 'Scan', 'Gift'];
  final List<String> _imgPaths = [
    'assets/icons/withDraw.svg',
    'assets/icons/transfer.svg',
    'assets/icons/scan.svg',
    'assets/icons/gift.svg',
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = Provider.of<BottomNavProvider>(context).currentIndex;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/walletCardBg.png'),
              fit: BoxFit.fill,
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.03, // Original was 24
            horizontal: screenWidth * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /// Wallet Info and Growth
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        /// Wallet Info
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                textAlign: TextAlign.start,
                                'Total Wallet Balance:',
                                style: TextStyle(
                                  color: Color(0xCCFFF5ED),
                                  fontFamily: 'Poppins',
                                  fontSize: getResponsiveFontSize(context, 12),
                                  fontWeight: FontWeight.w400,
                                  height: 1.3,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.006), // Original was 5
                              Text(
                                '\$ 10,1542.0000000000000000',
                                style: TextStyle(
                                  color: Color(0xffFFF5ED),
                                  fontFamily: 'Poppins',
                                  fontSize: getResponsiveFontSize(context, 18),
                                  fontWeight: FontWeight.w500,
                                  height: 1.3,
                                  overflow: TextOverflow.ellipsis
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Growth %
                        Flexible(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.01,
                              vertical: screenHeight * 0.003,
                            ),
                            margin: EdgeInsets.only(left: screenWidth * 0.001), // Add margin to separate from wallet info
                            decoration: BoxDecoration(
                              color: const Color(0x1915FF10),
                              borderRadius: BorderRadius.circular(screenWidth * 0.06),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_drop_up_sharp, color: Color(0xFF37CAB0), size: screenWidth * 0.05), // Original was 24
                                Text(
                                  '+0.8%',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Color(0xff37CBB0),
                                    fontFamily: 'Poppins',
                                    fontSize: getResponsiveFontSize(context, 12),
                                    fontWeight: FontWeight.w500,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Add Funds
                  InkWell(
                    onTap: () {
                      debugPrint("Add Funds");
                    },
                    child: Column(
                      children: [
                        Container(
                          width: screenWidth * 0.08,
                          height: screenWidth * 0.08,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/icons/addFundsBg.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/icons/addIcon.svg",
                              width: screenWidth * 0.048,
                              height: screenWidth * 0.048,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.0075),
                        Text(
                          'Add Funds',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: getResponsiveFontSize(context, 12),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.010), // Original was 10

              /// Balance Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /// Available Funds
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Funds :',
                        style: TextStyle(
                          color: Color(0xffFFF5ED).withOpacity(0.80),
                          fontFamily: 'Poppins',
                          fontSize: getResponsiveFontSize(context, 12),
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.0075),
                      Text(
                        '\$ 1541.00',
                        style: TextStyle(
                          color: Color(0xffFFF5ED),
                          fontFamily: 'Poppins',
                          fontSize: getResponsiveFontSize(context, 18),
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),

                  /// Coins
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/BTC.png',
                            width: screenWidth * 0.053,
                            height: screenWidth * 0.053,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: screenWidth * 0.013) ,
                          Text(
                            '1.25 BTC',
                            style: TextStyle(
                              color: Color(0xffFFF5ED),
                              fontFamily: 'Poppins',
                              fontSize: getResponsiveFontSize(context, 14),
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: screenWidth * 0.042), // Original was 16

                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/EthCoin.png',
                            width: screenWidth * 0.053,
                            height: screenWidth * 0.053,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: screenWidth * 0.013),
                          Text(
                            '265.0 ETH',
                            style: TextStyle(
                              color: Color(0xffFFF5ED),
                              fontFamily: 'Poppins',
                              fontSize: getResponsiveFontSize(context, 14),
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              /// Divider
              Center(
                child: SizedBox(
                  width: screenWidth * 0.9,
                  child: Divider(
                    color: Colors.white12,
                    thickness: screenHeight * 0.0025,
                    height: screenHeight * 0.025,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.008),
              /// Action Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_labels.length, (index) {
                  return InkWell(
                    onTap: () {
                      Provider.of<BottomNavProvider>(context, listen: false).setIndex(index);
                    },
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          _imgPaths[index],
                          color: Colors.white,
                          width: screenWidth * 0.059,
                          height: screenWidth * 0.059,
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          _labels[index],
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: getResponsiveFontSize(context, 12),
                            fontWeight: FontWeight.w400,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
