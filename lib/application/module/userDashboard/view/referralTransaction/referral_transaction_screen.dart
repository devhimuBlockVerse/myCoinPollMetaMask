import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/referralTransaction/widget/referral_transaction_card.dart';
import 'package:provider/provider.dart';
import '../../../../../framework/components/AddressFieldComponent.dart';
import '../../../../../framework/components/searchControllerComponent.dart';
import '../../../../../framework/res/colors.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/sort_option.dart';
import '../../../../data/dummyData/referral_transaction_dummy_data.dart';
 import '../../../../domain/usecases/sort_data.dart';
import '../../viewmodel/side_navigation_provider.dart';
import '../../../side_nav_bar.dart';
 import 'package:intl/intl.dart';

class ReferralTransactionScreen extends StatefulWidget {
  const ReferralTransactionScreen({super.key});

  @override
  State<ReferralTransactionScreen> createState() => _ReferralTransactionScreenState();
}

class _ReferralTransactionScreenState extends State<ReferralTransactionScreen> {

  SortReferralTransactionOption? _currentSort;
  final SortReferralTransactionUseCase _sortDataUseCase = SortReferralTransactionUseCase();

  TextEditingController inputController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<ReferralTransactionModel> _transactionData = [];
  List<ReferralTransactionModel> _allTransactionData = [];

  bool isLoading = true;
  String? errorMessage;
  Timer? _debounce;



  @override
  void initState() {
    super.initState();
    _fetchTransactions();
    _searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        _applyFiltersAndSort();
      });
    });
  }


  Future<void> _fetchTransactions() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));

      _transactionData = List.generate(40, (index) {
        return ReferralTransactionModel(
          coinName: 'ECM Coins',
          date: DateTime(2025, 2, 19).add(Duration(days: index)),
          userName: 'User ${index + 1}',
          uuId: '53625${100 + index}',
          purchaseAmountECM: 1000.00 + (index * 50),
          referralBonusMCM: 10 + (index % 5),
          referralBonusETH: 12 + (index % 4),
        );
      });
      _allTransactionData = List.from(_transactionData);

    } catch (e) {
      errorMessage = 'Failed to load transactions: $e';
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  void _applyFiltersAndSort() {
    String query = _searchController.text.toLowerCase().trim();

     // List<ReferralTransactionModel> filtered = _transactionData.where((tx) {
     List<ReferralTransactionModel> filtered = _allTransactionData.where((tx) {
      if (query.isEmpty) return true;

       return tx.userName.toLowerCase().contains(query) ||
          tx.uuId.toLowerCase().contains(query) ||
          tx.purchaseAmountECM.toString().toLowerCase().contains(query) ||
          tx.referralBonusMCM.toString().toLowerCase().contains(query) ||
          tx.referralBonusETH.toString().toLowerCase().contains(query) ||
           DateFormat('d MMMM yyyy').format(tx.date).toLowerCase().contains(query);
    }).toList();

    if (_currentSort != null) {
        filtered = _sortDataUseCase(filtered, _currentSort!);
    }

    // Update UI
    setState(() {
      _transactionData = filtered;
    });
  }

  void _sortData( SortReferralTransactionOption option) {
    setState(() {
      _currentSort = option;
      _applyFiltersAndSort();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
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
    final containerHeight = screenHeight * 0.12;
    final minContainerHeight = screenHeight * 0.13;

    final horizontalPadding = containerWidth * 0.05;
    final itemSpacing = screenWidth * 0.05;

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
              image: AssetImage('assets/images/starGradientBg.png'),
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
                        'Referral Transaction',
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


                          Container(
                            width: screenWidth,
                            height: containerHeight < minContainerHeight ? minContainerHeight : containerHeight,

                            decoration: BoxDecoration(
                              // color: const Color(0xFF01090B),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/buildStatCardBG.png'),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.circular(getResponsiveRadius(4)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding,
                                vertical: screenHeight * 0.016,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      title: 'Total ECM Earn with Refer :',
                                      value: '202',
                                      gradient: const LinearGradient(
                                        begin: Alignment(0.99, 0.14),
                                        end: Alignment(-0.99, -0.14),
                                        colors: [Color(0xFF101A29), Color(0xFF162B4A), Color(0xFF132239)],
                                      ),
                                      imageUrl: "assets/images/totalEcommerceBG.png",
                                    ),
                                  ),
                                  SizedBox(width: itemSpacing),

                                  Expanded(
                                    child: _buildStatCard(
                                      title: 'Total ETH Earn with Refer :',
                                      value: '30.000',
                                      gradient: const LinearGradient(
                                        begin: Alignment(0.99, 0.14),
                                        end: Alignment(-0.99, -0.14),
                                        colors: [Color(0xFF040C16), Color(0xFF162B4A)],
                                      ),
                                      imageUrl: "assets/images/totalEthereumBG.png",
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.020),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: const Color(0xff040C16),
                                borderRadius: BorderRadius.circular(10)
                            ),

                            child: ClipRRect(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CustomLabeledInputField(
                                  labelText: 'Referral Link:',
                                  hintText: ' https://mycoinpoll.com?ref=125482458661',
                                  isReadOnly: true,
                                  trailingIconAsset: 'assets/icons/copyImg.svg',
                                  onTrailingIconTap: () {
                                    debugPrint('Trailing icon tapped');
                                  },
                                ),
                              ),
                            ),
                          ),



                          SizedBox(height: screenHeight * 0.030),

                          Text(
                            'Referral Transactions',
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
                                    child: PopupMenuButton<SortReferralTransactionOption>(
                                      icon: SvgPicture.asset(
                                        'assets/icons/sortingList.svg',
                                        fit: BoxFit.contain,
                                      ),
                                      onSelected: _sortData,
                                      itemBuilder: (context) {
                                        final items = <PopupMenuEntry<SortReferralTransactionOption>>[
                                          const PopupMenuItem(
                                            value: SortReferralTransactionOption.dateLatest,
                                            child: Text('Date: Latest First'),
                                          ),
                                          const PopupMenuItem(
                                            value: SortReferralTransactionOption.dateOldest,
                                            child: Text('Date: Oldest First'),
                                          ),
                                          const PopupMenuItem(
                                            value: SortReferralTransactionOption.amountHighToLow,
                                            child: Text('Amount: High to Low'),
                                          ),
                                          const PopupMenuItem(
                                            value: SortReferralTransactionOption.amountLowToHigh,
                                            child: Text('Amount: Low to High'),
                                          ),
                                        ];

                                        if (_currentSort != null) {
                                          items.add(const PopupMenuDivider());
                                          items.add(
                                            PopupMenuItem(
                                              value: _currentSort!,
                                              child: const Text('Clear Sort'),
                                              onTap: () {
                                                Future(() {
                                                  setState(() {
                                                    _currentSort = null;
                                                    _applyFiltersAndSort();
                                                  });
                                                });
                                              },
                                            ),
                                          );
                                        }

                                        return items;
                                      },
                                    ),
                                  ),
                                )

                              ],
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.016),

                          /// Lists
                          isLoading
                              ? const Center(child: CircularProgressIndicator(color: AppColors.whiteColor))
                              : errorMessage != null
                              ? Center(
                            child: Text(
                              errorMessage!,
                              style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                            ),
                          )
                              : RefreshIndicator(
                            onRefresh: _fetchTransactions,
                            color: AppColors.accentOrange,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _transactionData.length,
                              itemBuilder: (context, index) {
                                return ReferralTransactionCard(transaction: _transactionData[index]);
                              },
                            ),
                          ),




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



  Widget _buildStatCard({
    required String title,
    required String value,
    required LinearGradient gradient,
    String? imageUrl,
    Color? borderColor,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final cardWidth = screenWidth / 3.5;
    final cardHeight = screenHeight * 0.13;
    final borderRadius = screenWidth * 0.02;
    final padding = screenWidth * 0.025;

    return Container(
      width: screenWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: gradient,
        border: Border.all(
          color: borderColor ?? const Color(0xFF2B2D40),
          width: 1,
        ),
        image: imageUrl != null
            ? DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.fill,
          // alignment: Alignment.center,
        ) : null,
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 3,
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize:getResponsiveFontSize(context, 12),
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.003),
            Flexible(
              flex: 2,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'Poppins',

                    fontSize:getResponsiveFontSize(context, 16),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
