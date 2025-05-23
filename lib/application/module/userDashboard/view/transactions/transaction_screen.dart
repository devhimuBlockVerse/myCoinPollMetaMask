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
  TextEditingController _searchController = TextEditingController();
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




  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final bool isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    return  Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,

        body: SafeArea(
          top: false,
          child: Container(
              width: screenWidth,
              height: screenHeight,
              decoration: BoxDecoration(
                color: const Color(0xFF01090B),
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
                      'ECM Staking',
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: screenHeight * 0.01),


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

                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xff040C16),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02,
                                  vertical:  screenHeight * 0.01
                              ),

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                ],
              )
          ),
        )
    );
  }

}
