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




//  class CardPrice extends StatelessWidget {
//   final List<String> _labels = ['Withdraw', 'Transfer', 'Scan', 'Gift'];
//   final List<String> _imgPaths = [
//     'assets/icons/home.svg',
//     'assets/icons/features.svg',
//     'assets/icons/news.svg',
//     'assets/icons/profileIcon.svg',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     final currentIndex = Provider.of<BottomNavProvider>(context).currentIndex;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(
//         vertical: screenWidth * 0.05,
//         horizontal: screenWidth * 0.04,
//       ),
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage('assets/icons/walletCardBg.png'),
//           fit: BoxFit.fill,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// Wallet Info Row
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// Left Section - Wallet Info + Growth
//               Expanded(
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     /// Wallet Info
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Total Wallet Balance:',
//                           style: TextStyle(
//                             color: Color(0xCCFFF5ED),
//                             fontSize: 12,
//                             fontFamily: 'Poppins',
//                             height: 1.4,
//                           ),
//                         ),
//                         SizedBox(height: 6),
//                         Text(
//                           '\$ 10,1542.00',
//                           style: TextStyle(
//                             color: Color(0xFFFFF5ED),
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: 'Poppins',
//                             height: 1.3,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(width: 10),
//                     /// Growth Box
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Color(0x1915FF10),
//                         borderRadius: BorderRadius.circular(24),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(Icons.arrow_drop_up_sharp, color: Color(0xFF37CAB0), size: 18),
//                           SizedBox(width: 4),
//                           Text(
//                             '+0.8%',
//                             style: TextStyle(
//                               color: Color(0xFF37CAB0),
//                               fontSize: 12,
//                               fontFamily: 'Poppins',
//                               height: 1.4,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               /// Right Section - Add Funds
//               Column(
//                 children: [
//                   Container(
//                     width: 36,
//                     height: 36,
//                     padding: const EdgeInsets.all(6),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.05),
//                       borderRadius: BorderRadius.circular(6),
//                       border: Border.all(color: Color(0x9900EFFF)),
//                     ),
//                     child: Image.network(
//                       "https://picsum.photos/20/20",
//                       width: 18,
//                       height: 18,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   SizedBox(height: 6),
//                   Text(
//                     'Add Funds',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                       fontFamily: 'Poppins',
//                       height: 1.4,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//
//           SizedBox(height: 20),
//
//           /// Balance Info
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               /// Available Funds
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: const [
//                   Text(
//                     'Available Funds:',
//                     style: TextStyle(
//                       color: Color(0xCCFFF5ED),
//                       fontSize: 12,
//                       fontFamily: 'Poppins',
//                     ),
//                   ),
//                   SizedBox(height: 6),
//                   Text(
//                     '\$ 1541.00',
//                     style: TextStyle(
//                       color: Color(0xFFFFF5ED),
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       fontFamily: 'Poppins',
//                     ),
//                   ),
//                 ],
//               ),
//
//               /// ETH Balance
//               Row(
//                 children: [
//                   Image.network("https://picsum.photos/20/20", width: 20),
//                   SizedBox(width: 6),
//                   const Text(
//                     '265.0 ETH',
//                     style: TextStyle(
//                       color: Color(0xFFFFF5ED),
//                       fontSize: 14,
//                       fontFamily: 'Poppins',
//                     ),
//                   ),
//                 ],
//               ),
//
//               /// BTC Balance
//               Row(
//                 children: [
//                   Image.network("https://picsum.photos/20/20", width: 20),
//                   SizedBox(width: 6),
//                   const Text(
//                     '1.25 BTC',
//                     style: TextStyle(
//                       color: Color(0xFFFFF5ED),
//                       fontSize: 14,
//                       fontFamily: 'Poppins',
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//
//           /// Divider
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             child: Divider(color: Colors.white12, thickness: 1),
//           ),
//
//           /// Action Buttons Row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: List.generate(4, (index) {
//               return InkWell(
//                 onTap: () {
//                   Provider.of<BottomNavProvider>(context, listen: false).setIndex(index);
//                 },
//                 child: Column(
//                   children: [
//                     SvgPicture.asset(
//                       _imgPaths[index],
//                       color: Colors.white,
//                       width: 24,
//                       height: 24,
//                     ),
//                     SizedBox(height: 6),
//                     Text(
//                       _labels[index],
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontFamily: 'Poppins',
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }

class CardPrice extends StatelessWidget {
  final List<String> _labels = ['With Draw', 'Transfer', 'Scan', 'Gift'];
  final List<String> _imgPaths = [
    'assets/icons/home.svg',
    'assets/icons/features.svg',
    'assets/icons/news.svg',
    'assets/icons/profileIcon.svg',
  ];

  TextStyle textStyle(Color color, double size,
      {FontWeight weight = FontWeight.normal}) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontFamily: 'Poppins',
      fontWeight: weight,
      height: 1.4,
    );
  }

  Widget coinRow(String text, String imageUrl) {
    return Row(
      children: [
        Image.network(
          imageUrl,
          width: 20,
          height: 20,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: textStyle(const Color(0xFFFFF5ED), 14),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = Provider.of<BottomNavProvider>(context).currentIndex;
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.04;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
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
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Wallet Info and Growth
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          /// Wallet Info
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Wallet Balance:',
                                style: textStyle(
                                    const Color(0xCCFFF5ED), 12),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '\$ 10,1542.00',
                                style: textStyle(
                                  const Color(0xFFFFF5ED),
                                  18,
                                  weight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),

                          /// Growth %
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0x1915FF10),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.arrow_drop_up_sharp,
                                    color: Color(0xFF37CAB0), size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '+0.8%',
                                  style: textStyle(
                                      const Color(0xFF37CAB0), 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Add Funds
                    Column(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: const Color(0x9900EFFF)),
                          ),
                          child: Center(
                            child: Image.network(
                              "https://picsum.photos/11/11",
                              width: 18,
                              height: 18,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Add Funds',
                          style: textStyle(Colors.white, 12),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

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
                          style:
                          textStyle(const Color(0xCCFFF5ED), 12),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '\$ 1541.00',
                          style: textStyle(
                            const Color(0xFFFFF5ED),
                            18,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    /// Coins
                    Row(
                      children: [
                        coinRow('265.0 ETH', "https://picsum.photos/20/20"),
                        const SizedBox(width: 16),
                        coinRow('1.25 BTC', "https://picsum.photos/20/20"),
                      ],
                    ),
                  ],
                ),

                /// Divider
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Divider(
                    color: Colors.white12,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                ),

                /// Action Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_labels.length, (index) {
                    return InkWell(
                      onTap: () {
                        Provider.of<BottomNavProvider>(context,
                            listen: false)
                            .setIndex(index);
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            _imgPaths[index],
                            color: Colors.white,
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _labels[index],
                            style: textStyle(Colors.white, 12),
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
      ),
    );
  }
}
