import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/transactions/widgets/transaction_table.dart';

import '../../../../../framework/components/searchControllerComponent.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/sort_option.dart';
import '../../../../data/staking_dummy_data.dart';
import '../../../../domain/usecases/sort_data.dart';


class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {



  SortTransactionHistoryOption? _currentSort;
  final SortTransactionDataUseCase _sortDataUseCase = SortTransactionDataUseCase();
  TextEditingController inputController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _displayData = [];



  int selectedCard = 0;

  final List<Map<String, dynamic>> cards = [
    {
      'title': 'Total\nTransactions',
      'value': '125',
      'colors': [const Color(0xFF040C16), const Color(0xFF172C4B)],
    },
    {
      'title': 'Total\nEthereum',
      'value': '125',
      'colors': [const Color(0xFF040C16), const Color(0xFF172C4B)],
    },
    {
      'title': 'Total\neCommerce',
      'value': '100',
      'colors': [const Color(0xFF101A29), const Color(0xFF172C4B)],
    },
  ];



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




  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final bool isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    final containerWidth = screenWidth;
    final containerHeight = screenHeight * 0.12;
    final minContainerHeight = screenHeight * 0.13;

    final horizontalPadding = containerWidth * 0.03;
    final itemSpacing = screenWidth * 0.03;

    double getResponsiveRadius(double base) => base * (screenWidth / 360);


    return  Scaffold(
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
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.02,
                      ),
                      child: SingleChildScrollView(

                        child: ConstrainedBox(

                          constraints: BoxConstraints(
                            minHeight: screenHeight - kToolbarHeight, // or screenHeight * 0.9
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: screenHeight * 0.01),



                              Container(
                                width: double.infinity,
                                height: containerHeight < minContainerHeight ? minContainerHeight : containerHeight,

                                decoration: BoxDecoration(
                                  color: const Color(0xFF01090B),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/icons/buildStatCardBG.png'),
                                    fit: BoxFit.fill,
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
                                          title: 'Total \nTransactions',
                                          value: '125',
                                          gradient: const LinearGradient(
                                            begin: Alignment(0.99, 0.14),
                                            end: Alignment(-0.99, -0.14),
                                            colors: [Color(0xFF040C16), Color(0xFF162B4A)],
                                          ),
                                          imageUrl: "assets/icons/totalTransactionBg.png",
                                        ),
                                      ),
                                      SizedBox(width: itemSpacing),
                                      Expanded(
                                        child: _buildStatCard(
                                          title: 'Total \nEthereum',
                                          value: '125',
                                          gradient: const LinearGradient(
                                            begin: Alignment(0.99, 0.14),
                                            end: Alignment(-0.99, -0.14),
                                            colors: [Color(0xFF040C16), Color(0xFF162B4A)],
                                          ),
                                          imageUrl: "assets/icons/totalEthereumBG.png",
                                        ),
                                      ),
                                      SizedBox(width: itemSpacing),
                                      Expanded(
                                        child: _buildStatCard(
                                          title: 'Total \neCommerce',
                                          value: '100',
                                          gradient: const LinearGradient(
                                            begin: Alignment(0.99, 0.14),
                                            end: Alignment(-0.99, -0.14),
                                            colors: [Color(0xFF101A29), Color(0xFF162B4A), Color(0xFF132239)],
                                          ),
                                          imageUrl: "assets/icons/totalEcommerceBG.png",
                                        ),
                                      ),
                                    ],
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
                                  fontSize: getResponsiveFontSize(context, 18),
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
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.02,
                                    vertical:  screenHeight * 0.01
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
    final cardHeight = screenHeight * 0.13;
    final borderRadius = screenWidth * 0.02;
    final padding = screenWidth * 0.025;

    return Container(
      width: cardWidth,
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
          fit: BoxFit.cover,
          alignment: Alignment.center,
        )
            : null,
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
                  fontSize:getResponsiveFontSize(context, 12),
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
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



