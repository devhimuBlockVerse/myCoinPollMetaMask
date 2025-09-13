import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/transactions/widgets/transaction_table.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../framework/components/searchControllerComponent.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/sort_option.dart';
 import '../../../../data/services/api_service.dart';
import '../../../../domain/constants/api_constants.dart';
import '../../../../domain/usecases/sort_data.dart';
import '../../../../presentation/models/get_purchase_stats.dart';
import '../../../../presentation/models/user_model.dart';
import '../../../../presentation/viewmodel/wallet_view_model.dart';
import '../../viewmodel/side_navigation_provider.dart';
import '../../../side_nav_bar.dart';
import 'package:http/http.dart'as http;


class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {

  bool _hasLoaded = false;
  bool _isLoading = false;

  SortTransactionHistoryOption? _currentSort;
  final SortTransactionDataUseCase _sortDataUseCase = SortTransactionDataUseCase();
  TextEditingController inputController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _displayData = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
   List<Map<String, dynamic>> transactionData = [];

  PurchaseStatsModel? _purchaseStats;


  @override
  void initState() {
    super.initState();
     _searchController.addListener(_applyFiltersAndSort);
    _loadTransactions();
    _loadPurchaseStats();

  }


  void _applyFiltersAndSort() {
    List<Map<String, dynamic>> currentFilteredData = List.from(transactionData);
    String query = _searchController.text.toLowerCase();


    if (query.isNotEmpty) {
      currentFilteredData = currentFilteredData.where((row) {
        return (row['TxnHash']?.toLowerCase().contains(query) ?? false) ||
            (row['Status']?.toLowerCase().contains(query) ?? false) ||
            (row['Amount']?.toLowerCase().contains(query) ?? false) ||
            (row['DateTime']?.toLowerCase().contains(query) ?? false) ||
            (row['SL']?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

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
    _searchController.removeListener(_applyFiltersAndSort);
    _searchController.dispose();
    inputController.dispose();
    super.dispose();
  }


  /// re-fetch on wallet connection
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoaded) {
      final walletVM = Provider.of<WalletViewModel>(context);
      if (walletVM.isConnected && walletVM.walletAddress.isNotEmpty) {
        _loadTransactions();
        _loadPurchaseStats();

        _hasLoaded = true;
      }
    }
  }


  /// Fetch transactions from API with Wallet Connection
   Future<List<Map<String, dynamic>>> fetchTransactions(String walletAddress) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("No login token found.");
      return [];
    }

    final url = Uri.parse('${ApiConstants.baseUrl}/get-transactions?address=$walletAddress');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('fetchTransactions Response  ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['status'] == '1') {
          List<dynamic> results = decoded['result'];
          return results.asMap().entries.map((entry) {
            final tx = entry.value;
            return {
              'SL': (entry.key + 1).toString(),
              'DateTime': tx['timestamp'] ?? '',
              'TxnHash': tx['short_hash'] ?? '',
              'Status': tx['direction'] == 'in' ? 'In' : 'Out',
              'Amount': tx['converted_value'].toString(),
              'Details': tx['explorer_url'] ?? '',
              'FullHash': tx['hash'] ?? '',
              'From': tx['from'] ?? '',
              'To': tx['to'] ?? '',

            };
          }).toList();
        }
      } else {
        print('Failed to fetch with token: ${response.body}');
      }
    } catch (e) {
      print("Error fetching with token: $e");
    }

    return [];
  }


  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);

    final walletVM = Provider.of<WalletViewModel>(context, listen: false);
    String? address;

    if (walletVM.isConnected && walletVM.walletAddress.isNotEmpty) {
      address = walletVM.walletAddress;
    } else {
      /// getting eth address from user profile stored after login
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson != null) {
        final user = UserModel.fromJson(jsonDecode(userJson));
        if (user.ethAddress.isNotEmpty) {
          address = user.ethAddress;
        }
      }
    }

    try {
      if (address == null || address.isEmpty) {
        throw 'No valid Ethereum wallet address found from wallet or login.';
      }
      print("✅ Fetching transactions for address: $address");
      final fetchedData = await fetchTransactions(address);
      if (!mounted) return;
      setState(() {
        transactionData = fetchedData;
        _displayData = List.from(fetchedData);
        _isLoading = false;
      });
    } catch (e) {
      print("Failed to load transactions: $e");
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadPurchaseStats() async {
    try {
      final stats = await ApiService().fetchPurchaseStats();
      setState(() {
        _purchaseStats = stats;
      });
    } catch (e) {
      debugPrint('Error fetching stats: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final containerWidth = screenWidth;

    final horizontalPadding = containerWidth * 0.03;
    final itemSpacing = screenWidth * 0.02;

    double getResponsiveRadius(double base) => base * (screenWidth / 360);
    final navProvider = Provider.of<NavigationProvider>(context);
    final currentScreenId = navProvider.currentScreenId;
    final navItems = navProvider.drawerNavItems;
    const baseWidth = 375.0;
    const baseHeight = 812.0;

    double scaleHeight(double size) => size * screenHeight / baseHeight;
    double scaleText(double size) => size * screenWidth / baseWidth;

    return  Scaffold(
        key: _scaffoldKey,
        drawerEnableOpenDragGesture: true,
        drawerEdgeDragWidth: 80,
        drawer: SideNavBar(
          currentScreenId: currentScreenId,
          navItems: navItems,
          onScreenSelected: (id) => navProvider.setScreen(id),
          onLogoutTapped: () {

          },
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,

        body: SafeArea(
           child: Container(
              width: screenWidth,
              height: screenHeight,
              decoration: const BoxDecoration(
                color: Color(0xFF01090B),
                image: DecorationImage(
                  image: AssetImage('assets/images/starGradientBg.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topRight,
                  filterQuality: FilterQuality.low
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Align(
                    alignment: Alignment.topCenter,
                    child:  Text(
                      'Transactions',
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
                        child: RefreshIndicator(

                          onRefresh: () async {
                            await _loadTransactions();
                            setState(() {});
                          },

                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: screenHeight - kToolbarHeight,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: screenHeight * 0.01),

                                  IntrinsicHeight(
                                    child: Container(
                                      width: double.infinity,
                                      // height: containerHeight < minContainerHeight ? minContainerHeight : containerHeight,

                                      decoration: BoxDecoration(
                                         image: const DecorationImage(
                                          image: AssetImage('assets/images/buildStatCardBG.png'),
                                          fit: BoxFit.fill, filterQuality: FilterQuality.low
                                         ),
                                        borderRadius: BorderRadius.circular(getResponsiveRadius(4)),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: horizontalPadding,
                                          vertical: screenHeight * 0.014,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: _buildStatCard(
                                                title: 'Total\nPurchases',
                                                // value: '125',
                                                value: _purchaseStats != null ? _purchaseStats!.totalPurchases.toString() : '0',

                                            gradient: const LinearGradient(
                                                  begin: Alignment(0.99, 0.14),
                                                  end: Alignment(-0.99, -0.14),
                                                  colors: [Color(0xFF040C16), Color(0xFF162B4A)],
                                                ),
                                                imageUrl: "assets/images/totalTransactionBg.png",
                                              ),
                                            ),
                                            SizedBox(width: itemSpacing),
                                            Expanded(
                                              child: _buildStatCard(
                                                title: 'Attendant',
                                                // value: '125',
                                                value: _purchaseStats != null ? _purchaseStats!.uniqueStages.toString() : '0',
                                                gradient: const LinearGradient(
                                                  begin: Alignment(0.99, 0.14),
                                                  end: Alignment(-0.99, -0.14),
                                                  colors: [Color(0xFF040C16), Color(0xFF162B4A)],
                                                ),
                                                imageUrl: "assets/images/totalEthereumBG.png",
                                              ),
                                            ),
                                            SizedBox(width: itemSpacing),
                                            Expanded(
                                              child: _buildStatCard(
                                                title: 'Purchased\nAmount',
                                                value: _purchaseStats != null ? _purchaseStats!.totalPurchaseAmount.toStringAsFixed(2)
                                                    : '0.00',

                                                gradient: const LinearGradient(
                                                  begin: Alignment(0.99, 0.14),
                                                  end: Alignment(-0.99, -0.14),
                                                  colors: [Color(0xFF101A29), Color(0xFF162B4A), Color(0xFF132239)],
                                                ),
                                                imageUrl: "assets/images/totalEcommerceBG.png",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),


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

                                    _isLoading ? const Center(child: CircularProgressIndicator()) : _displayData.isNotEmpty
                                        ? buildTransactionTable(_displayData, screenWidth, context)
                                        : Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: scaleHeight(38)),
                                          Text(
                                            'No transactions Found',
                                            textAlign: TextAlign.center,
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
                                    ),

                                  ],



                                ],
                              ),
                            ),
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
    final cardHeight = screenHeight * 0.12;
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



