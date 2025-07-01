import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/data/dummyData/wallet_transaction_dummy_data.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/wallet/widget/wallet_card.dart';
import 'package:provider/provider.dart';
import '../../../../../framework/components/searchControllerComponent.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/sort_option.dart';
import '../../../../domain/usecases/sort_data.dart';
import '../../viewmodel/side_navigation_provider.dart';
import '../../../side_nav_bar.dart';
import 'widget/wallet_transaction_table.dart';
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
    _displayData = List.from(walletTransactionData);
    _searchController.addListener(_applyFiltersAndSort);

  }


  void _applyFiltersAndSort() {
    List<Map<String, dynamic>> currentFilteredData = List.from(walletTransactionData);
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
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          WalletCard(),

                          SizedBox(height: screenHeight * 0.030),
                           Text(
                            'Recent Transactions',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: getResponsiveFontSize(context, 16),
                              height: 1.6,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.020),


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
                                ? walletRecentTransaction(_displayData, screenWidth, context)
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
          ),
        ),
      ),
    );
  }

}




