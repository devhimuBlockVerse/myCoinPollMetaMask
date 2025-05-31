import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
 import 'package:provider/provider.dart';
import '../../../../../framework/components/searchControllerComponent.dart';
import '../../../../../framework/res/colors.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/sort_option.dart';
import '../../../../domain/model/PurchaseLogModel.dart';
import '../../../../domain/usecases/sort_data.dart';
import '../../viewmodel/side_navigation_provider.dart';
import '../../../side_nav_bar.dart';
import 'widget/purchase_card.dart';





class PurchaseLogScreen extends StatefulWidget {
  const PurchaseLogScreen({super.key});

  @override
  State<PurchaseLogScreen> createState() => _PurchaseLogScreenState();
}

class _PurchaseLogScreenState extends State<PurchaseLogScreen> {



  SortPurchaseLogOption? _currentSort;
  final SortPurchaseLogUseCase _sortDataUseCase = SortPurchaseLogUseCase();

  TextEditingController inputController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<PurchaseLogModel> _transactionData = [];
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
      await Future.delayed(const Duration(seconds: 2));

      List<String> names = [
        'Alice Smith', 'Bob Johnson', 'Charlie Brown', 'David Lee', 'Eva Green',
        'Frank Harris', 'Grace Kim', 'Hank Adams', 'Ivy Moore', 'Jack White',
        'Kara Black', 'Liam Young', 'Mia Scott', 'Nina Hill', 'Oscar Reed',
        'Paul King', 'Quinn Price', 'Rachel Cook', 'Steve Bell', 'Tina Ward'
      ];

      _transactionData = List.generate(40, (index) {
        final name = names[index % names.length];
        return PurchaseLogModel(
          coinName: 'ECM Coins',
          refName: name,
          date: DateTime(2025, 1 + (index % 12), 1 + (index % 28)),
          contractName: 'Contract ${String.fromCharCode(65 + (index % 5))}', // A–E
          senderName: 'Sender ${index + 1}',
          ecmAmount: 100.0 + (index * 25.5),
          hash: '0xHASH${index.toString().padLeft(4, '0')}',
        );
      });
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

    // Filter transactions
    List<PurchaseLogModel> filtered = _transactionData.where((tx) {
      if (query.isEmpty) return true;

      return tx.hash.toLowerCase().contains(query) ||
          tx.refName.toLowerCase().contains(query) ||
          tx.senderName.toLowerCase().contains(query) ||
          tx.contractName.toLowerCase().contains(query) ||
          tx.ecmAmount.toString().toLowerCase().contains(query) ||
          tx.date.toIso8601String().toLowerCase().contains(query);
    }).toList();

    //  Sort using your use case
    if (_currentSort != null) {
      filtered = _sortDataUseCase(filtered, _currentSort!);
    }

    //   Update UI
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
                  child: ListView(
                    children: [
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
                          shrinkWrap: true, // Add this
                          physics: const NeverScrollableScrollPhysics(), // Add this
                          itemCount: _transactionData.length,
                          itemBuilder: (context, index) {
                            return PurchaseCard(transaction: _transactionData[index]);
                          },
                        ),
                      ),




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
