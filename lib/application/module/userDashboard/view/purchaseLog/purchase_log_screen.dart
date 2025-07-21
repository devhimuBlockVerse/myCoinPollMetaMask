import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
 import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../framework/components/searchControllerComponent.dart';
import '../../../../../framework/res/colors.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/sort_option.dart';
import '../../../../data/services/api_service.dart';
import '../../../../domain/constants/api_constants.dart';
import '../../../../domain/model/PurchaseLogModel.dart';
import '../../../../domain/usecases/sort_data.dart';
import '../../../../presentation/models/user_model.dart';
import '../../../../presentation/viewmodel/wallet_view_model.dart';
import '../../viewmodel/side_navigation_provider.dart';
import '../../../side_nav_bar.dart';
import 'widget/purchase_card.dart';
import 'package:http/http.dart'as http;





class PurchaseLogScreen extends StatefulWidget {
  const PurchaseLogScreen({super.key});

  @override
  State<PurchaseLogScreen> createState() => _PurchaseLogScreenState();
}

class _PurchaseLogScreenState extends State<PurchaseLogScreen> {



  SortPurchaseLogOption? _currentSort;
  final SortPurchaseLogUseCase _sortDataUseCase = SortPurchaseLogUseCase();
  final TextEditingController _searchController = TextEditingController();


  List<PurchaseLogModel> _transactionData = [];
  List<PurchaseLogModel> _originalData = [];

  bool isLoading = true;
  String? errorMessage;


  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final walletVM = Provider.of<WalletViewModel>(context, listen: false);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print("WalletViewModel connected: ${walletVM.isConnected}");
      print("WalletViewModel walletAddress: ${walletVM.walletAddress}");
      String? walletAddress;



      if (walletVM.isConnected && walletVM.walletAddress.isNotEmpty) {
        walletAddress = walletVM.walletAddress.trim().toLowerCase();
        print(" Using wallet from WalletViewModel: $walletAddress");
      } else {

         final userJson = prefs.getString('user');

        if (userJson != null) {
          final user = UserModel.fromJson(jsonDecode(userJson));
          if (user.ethAddress.isNotEmpty) {
            walletAddress = user.ethAddress.trim().toLowerCase();
            print(" Using wallet from SharedPreferences (UserModel): $walletAddress");

          }
        }
      }

      final apiService = ApiService();
      // final logs = await apiService.fetchPurchaseLogs(walletAddress: walletAddress);
      final logs = await apiService.fetchPurchaseLogs(
        walletAddress: token == null || token.isEmpty ? walletAddress : null,

      );

      setState(() {
        _originalData = logs;
        _transactionData = List.from(logs);
      });

      print("Purchase logs fetched: ${logs.length}");

    } catch (e) {
      print(" Fetch error _fetchTransactions(): $e");

      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  void _applyFiltersAndSort() {
    String query = _searchController.text.toLowerCase().trim();

    List<PurchaseLogModel> filtered = _originalData.where((tx) {
      return tx.hash.toLowerCase().contains(query) ||
          tx.buyer.toLowerCase().contains(query) ||
          tx.amount.toString().contains(query) ||
          tx.createdAt.toLowerCase().contains(query) ||
          tx.icoStage.toLowerCase().contains(query);
    }).toList();

    if (_currentSort != null) {
      filtered = _sortDataUseCase(filtered, _currentSort!);
    }

    setState(() {
      _transactionData = filtered;
    });
  }


  void _sortData( SortPurchaseLogOption option) {
    setState(() {
      _currentSort = option;
      _applyFiltersAndSort();
    });
  }
  @override
  void dispose() {
     _searchController.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
      final navProvider = Provider.of<NavigationProvider>(context);
    final currentScreenId = navProvider.currentScreenId;
    final navItems = navProvider.drawerNavItems;

    const baseWidth = 375.0;
    const baseHeight = 812.0;

    double scaleHeight(double size) => size * screenHeight / baseHeight;
    double scaleText(double size) => size * screenWidth / baseWidth;


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
                        'Purchase Log',
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
                          SizedBox(height: screenHeight * 0.010),

                          Text(
                            'Purchase History',
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
                                    child: PopupMenuButton<SortPurchaseLogOption>(
                                      icon: SvgPicture.asset(
                                        'assets/icons/sortingList.svg',
                                        fit: BoxFit.contain,
                                      ),
                                      onSelected: _sortData,
                                      itemBuilder: (context) {
                                        final items = <PopupMenuEntry<SortPurchaseLogOption>>[
                                          const PopupMenuItem(
                                            value: SortPurchaseLogOption.dateLatest,
                                            child: Text('Date: Latest First'),
                                          ),
                                          const PopupMenuItem(
                                            value: SortPurchaseLogOption.dateOldest,
                                            child: Text('Date: Oldest First'),
                                          ),
                                          const PopupMenuItem(
                                            value: SortPurchaseLogOption.amountHighToLow,
                                            child: Text('Amount: High to Low'),
                                          ),
                                          const PopupMenuItem(
                                            value: SortPurchaseLogOption.amountLowToHigh,
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

                            isLoading
                                ? const Center(child: CircularProgressIndicator(color: AppColors.whiteColor))
                                : errorMessage != null
                                ? Center(child: Text(
                                errorMessage!,
                                style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                              ),
                            ) : _transactionData.isEmpty ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: scaleHeight(38)),
                                  Text(
                                    'No History Found',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: scaleText(16),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ) : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _transactionData.length,
                                  itemBuilder: (context, index) {
                                    return PurchaseCard(transaction: _transactionData[index]);
                                  },
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

}

