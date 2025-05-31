import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
 import 'package:provider/provider.dart';
import '../../../../../framework/res/colors.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../domain/model/PurchaseLogModel.dart';
import '../../viewmodel/side_navigation_provider.dart';
import '../../../side_nav_bar.dart';
import 'widget/purchase_card.dart';





class PurchaseLogScreen extends StatefulWidget {
  const PurchaseLogScreen({super.key});

  @override
  State<PurchaseLogScreen> createState() => _PurchaseLogScreenState();
}

class _PurchaseLogScreenState extends State<PurchaseLogScreen> {

  TextEditingController inputController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<PurchaseLogModel> transactions = [];
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
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
      transactions = [
        PurchaseLogModel(
          coinName: 'ECM Coins',
          refName: 'Jane Cooper',
          date: DateTime(2025, 2, 19),
          contractName: 'Smart Contract Alpha',
          senderName: 'John Doe',
          ecmAmount: 1000.00,
          hash: '0xB274429lcA7dF45278CcSGVFI2241xxaFlcl',
        ),
        PurchaseLogModel(
          coinName: 'ECM Coins',
          refName: 'Alice Smith',
          date: DateTime(2025, 3, 5),
          contractName: 'Rental Agreement',
          senderName: 'Property Manager',
          ecmAmount: 500.50,
          hash: '0x1A3B4C5D6E7F8A9B0C1D2E3F4A5B6C7D8E9F0A1B',
        ),
        PurchaseLogModel(
          coinName: 'ECM Coins',
          refName: 'Bob Johnson',
          date: DateTime(2025, 1, 10),
          contractName: 'Service Payment',
          senderName: 'Company XYZ',
          ecmAmount: 250.75,
          hash: '0xFEFDFCFBF8F7F6F5F4F3F2F1F0EFEAE9E8E7E6E5E4',
        ),
      ];
    } catch (e) {
      errorMessage = 'Failed to load transactions: $e';
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
                      // Container(
                      //   width: double.infinity,
                      //   decoration: BoxDecoration(
                      //     color: const Color(0xff040C16),
                      //     borderRadius: BorderRadius.circular(5),
                      //   ),
                      //   padding: EdgeInsets.symmetric(
                      //       horizontal: screenWidth * 0.02,
                      //       vertical:  screenHeight * 0.001
                      //   ),
                      //
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       Expanded(
                      //         flex: 2,
                      //         child: ResponsiveSearchField(
                      //           controller: _searchController,
                      //           // onChanged:  (value) => _onSearchChanged(),
                      //           onChanged:  (value) => _applyFiltersAndSort(),
                      //           svgAssetPath: 'assets/icons/search.svg',
                      //
                      //         ),
                      //       ),
                      //
                      //
                      //       /// Data Sorting  Button
                      //       Expanded(
                      //         flex: 1,
                      //         child: Align(
                      //             alignment: Alignment.centerRight,
                      //             child: PopupMenuButton<SortMilestoneLists>(
                      //               icon: SvgPicture.asset(
                      //                 'assets/icons/sortingList.svg',
                      //                 fit: BoxFit.contain,
                      //               ),
                      //               onSelected: (SortMilestoneLists option) {
                      //                 _sortData(option);
                      //               },
                      //               itemBuilder: (BuildContext context) => <PopupMenuEntry<SortMilestoneLists>>[
                      //                 const PopupMenuItem<SortMilestoneLists>(
                      //                   value: SortMilestoneLists.active,
                      //                   child: Text('Priority: Active'),
                      //                 ),
                      //                 const PopupMenuItem<SortMilestoneLists>(
                      //                   value: SortMilestoneLists.onGoing,
                      //                   child: Text('Priority: Ongoing'),
                      //                 ),
                      //                 const PopupMenuItem<SortMilestoneLists>(
                      //                   value: SortMilestoneLists.completed,
                      //                   child: Text('Priority: Completed'),
                      //                 ),
                      //                 if (_currentSort != null) const PopupMenuDivider(),
                      //                 if (_currentSort != null)
                      //                   PopupMenuItem<SortMilestoneLists>(
                      //                     child: const Text('Clear Sort'),
                      //                     onTap: () => Future(() => _sortData(_currentSort!)),
                      //                   ),
                      //               ],
                      //             )
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      SizedBox(height: screenHeight * 0.016),


                      isLoading
                          ? const Center(child: CircularProgressIndicator(color: AppColors.accentOrange))
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
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            return PurchaseCard(transaction: transactions[index]);
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
