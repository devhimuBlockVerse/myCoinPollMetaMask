import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/data/dummyData/wallet_transaction_dummy_data.dart';
 import 'package:provider/provider.dart';
import '../../../../../framework/components/searchControllerComponent.dart';
import '../../../../../framework/res/colors.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/sort_option.dart';
import '../../../../data/dummyData/milestone_llist_dummy_data.dart';
import '../../../../domain/model/milestone_list_models.dart';
import '../../../../domain/usecases/sort_data.dart';
import '../../viewmodel/side_navigation_provider.dart';
import '../../../side_nav_bar.dart';
import '../milestone/widget/milestone_lists.dart';
import '../wallet/widget/wallet_transaction_table.dart';
import 'package:intl/intl.dart';



// Data model for an ECM transaction
class EcmTransaction {
  final String coinName;
  final String refName;
  final DateTime date;
  final String contractName;
  final String senderName;
  final double ecmAmount;
  final String hash;

  EcmTransaction({
    required this.coinName,
    required this.refName,
    required this.date,
    required this.contractName,
    required this.senderName,
    required this.ecmAmount,
    required this.hash,
  });

  // Factory constructor to create an instance from JSON (for API)
  factory EcmTransaction.fromJson(Map<String, dynamic> json) {
    return EcmTransaction(
      coinName: json['coinName'],
      refName: json['refName'],
      date: DateTime.parse(json['date']), // Assuming date is in ISO 8601 format
      contractName: json['contractName'],
      senderName: json['senderName'],
      ecmAmount: json['ecmAmount'].toDouble(),
      hash: json['hash'],
    );
  }
}

extension DateTimeExtension on DateTime {
  static const List<String> monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
}

class EcmTransactionCard extends StatelessWidget {
  final EcmTransaction transaction;

  const EcmTransactionCard({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final DateFormat formatter = DateFormat('d MMMM yyyy');
    String formattedDate = formatter.format(transaction.date);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: ECM Coins | Ref: Jane Cooper
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: AppColors.accentOrange.withOpacity(0.2), // Lighter orange background
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: AppColors.accentOrange, width: 1.0),
                    ),
                    child: Icon(Icons.currency_bitcoin, color: AppColors.accentOrange, size: 24),
                    // Or an Image.asset for a custom logo
                    // child: Image.asset('assets/ecm_logo.png', width: 24, height: 24),
                  ),
                  const SizedBox(width: 12.0),
                  Text(
                    transaction.coinName,
                    style: const TextStyle(
                      color: AppColors.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.link, color: AppColors.lightTextColor, size: 18),
                  const SizedBox(width: 4.0),
                  Text(
                    'Ref: ${transaction.refName}',
                    style: const TextStyle(
                      color: AppColors.lightTextColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Date Row
              Row(
                children: [
                  Icon(Icons.calendar_today, color: AppColors.lightTextColor, size: 16),
                  const SizedBox(width: 8.0),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      color: AppColors.lightTextColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0), // More space before contract details

              // Contract Details
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3, // Give more space to the left column
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Contract Name',
                          style: TextStyle(
                            color: AppColors.lightTextColor,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          transaction.contractName,
                          style: const TextStyle(
                            color: AppColors.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          'Name of Sender',
                          style: TextStyle(
                            color: AppColors.lightTextColor,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          transaction.senderName,
                          style: const TextStyle(
                            color: AppColors.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2, // Give less space to the right column
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end, // Align right
                      children: [
                        const Text(
                          'ECM Amount',
                          style: TextStyle(
                            color: AppColors.lightTextColor,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          '${transaction.ecmAmount.toStringAsFixed(2)} ECM',
                          style: const TextStyle(
                            color: AppColors.accentGreen,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0), // Space before hash

              // Hash Section
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Hash: ${transaction.hash}',
                      style: const TextStyle(
                        color: AppColors.lightTextColor,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis, // Prevent text from overflowing
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: transaction.hash));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Hash copied to clipboard!')),
                      );
                    },
                    child: Icon(Icons.copy_all, color: AppColors.lightTextColor, size: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

 class PurchaseLogScreen extends StatefulWidget {
  const PurchaseLogScreen({super.key});

  @override
  State<PurchaseLogScreen> createState() => _PurchaseLogScreenState();
}

class _PurchaseLogScreenState extends State<PurchaseLogScreen> {

  SortMilestoneLists? _currentSort;
  final SortTransactionDataUseCase _sortDataUseCase = SortTransactionDataUseCase();
  TextEditingController inputController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final SortEcmTaskUseCase _sortEcmTaskUseCase = SortEcmTaskUseCase();


  List<EcmTaskModel> _masterData = []; // Holds the original, unfiltered list
  List<EcmTaskModel> _displayData = []; // Holds the filtered and sorted list for display



  ///
  List<EcmTransaction> transactions = [];
  bool isLoading = true;
  String? errorMessage;


  @override
  void initState() {
    super.initState();
    _masterData = List.from(milestoneListsData);
    _displayData = List.from(_masterData);

    _searchController.addListener(_applyFiltersAndSort);
    _applyFiltersAndSort();


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
        EcmTransaction(
          coinName: 'ECM Coins',
          refName: 'Jane Cooper',
          date: DateTime(2025, 2, 19),
          contractName: 'Smart Contract Alpha',
          senderName: 'John Doe',
          ecmAmount: 1000.00,
          hash: '0xB274429lcA7dF45278CcSGVFI2241xxaFlcl',
        ),
        EcmTransaction(
          coinName: 'ECM Coins',
          refName: 'Alice Smith',
          date: DateTime(2025, 3, 5),
          contractName: 'Rental Agreement',
          senderName: 'Property Manager',
          ecmAmount: 500.50,
          hash: '0x1A3B4C5D6E7F8A9B0C1D2E3F4A5B6C7D8E9F0A1B',
        ),
        EcmTransaction(
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

  void _onSearchChanged() {
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    final query = _searchController.text.toLowerCase();

    // Filter tasks by query
    var filtered = _masterData.where((task) {
      return task.title.toLowerCase().contains(query) ||
          task.milestoneMessage.toLowerCase().contains(query) ||
          task.targetSales.toLowerCase().contains(query);
    }).toList();

    // Sort if an option is selected
    if (_currentSort != null) {
      filtered = _sortEcmTaskUseCase(filtered, _currentSort!);
    }
    setState(() => _displayData = filtered);
  }

  void _sortData(SortMilestoneLists option) {
    setState(() {
      _currentSort = (_currentSort == option) ? null : option;
      _applyFiltersAndSort();
    });
  }


  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
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
                                  child: PopupMenuButton<SortMilestoneLists>(
                                    icon: SvgPicture.asset(
                                      'assets/icons/sortingList.svg',
                                      fit: BoxFit.contain,
                                    ),
                                    onSelected: (SortMilestoneLists option) {
                                      _sortData(option);
                                    },
                                    itemBuilder: (BuildContext context) => <PopupMenuEntry<SortMilestoneLists>>[
                                      const PopupMenuItem<SortMilestoneLists>(
                                        value: SortMilestoneLists.active,
                                        child: Text('Priority: Active'),
                                      ),
                                      const PopupMenuItem<SortMilestoneLists>(
                                        value: SortMilestoneLists.onGoing,
                                        child: Text('Priority: Ongoing'),
                                      ),
                                      const PopupMenuItem<SortMilestoneLists>(
                                        value: SortMilestoneLists.completed,
                                        child: Text('Priority: Completed'),
                                      ),
                                      if (_currentSort != null) const PopupMenuDivider(),
                                      if (_currentSort != null)
                                        PopupMenuItem<SortMilestoneLists>(
                                          child: const Text('Clear Sort'),
                                          onTap: () => Future(() => _sortData(_currentSort!)),
                                        ),
                                    ],
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),

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
                            return EcmTransactionCard(transaction: transactions[index]);
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
