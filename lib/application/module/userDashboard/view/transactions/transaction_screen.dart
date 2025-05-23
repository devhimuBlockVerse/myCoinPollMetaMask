import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/framework/components/buy_Ecm.dart';
import 'package:provider/provider.dart';

 import 'package:intl/intl.dart';

import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/components/searchControllerComponent.dart';
import '../../../../../framework/components/statke_now_animation_button.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/sort_option.dart';
import '../../../../../framework/utils/routes/route_names.dart';
import '../../../../data/staking_dummy_data.dart';
import '../../../../domain/usecases/sort_data.dart';
import '../../../../presentation/viewmodel/wallet_view_model.dart';
import '../staking/widgets/staking_table.dart';


class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {



  SortOption? _currentSort;
  final SortDataUseCase _sortDataUseCase = SortDataUseCase();

  TextEditingController inputController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  String? _selectedDuration;
  List<Map<String, dynamic>> _filteredData = [];


  @override
  void initState() {
    super.initState();
    _filteredData = List.from(stakingData);
    _searchController.addListener(_onSearchChanged);

  }

  void _onSearchChanged() {

    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredData = stakingData.where((row){
        return row.values.any((value) => value.toLowerCase().contains(query));
      }).toList();
    });
  }

  void _sortData(SortOption option) {
    setState(() {
      _currentSort = option;
      _filteredData = _sortDataUseCase(_filteredData, option);
    });
  }

  @override
  void dispose() {
    inputController.dispose();
    _searchController.dispose();
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
                                      onChanged:  (value) => _onSearchChanged(),
                                      svgAssetPath: 'assets/icons/search.svg',

                                    ),
                                  ),


                                  Expanded(
                                    flex: 1,
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: PopupMenuButton<SortOption>(
                                          icon: SvgPicture.asset(
                                            'assets/icons/sortingList.svg',
                                            fit: BoxFit.contain,
                                          ),
                                          onSelected: (SortOption option) {
                                            _sortData(option);
                                          },
                                          itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
                                            const PopupMenuItem<SortOption>(
                                              value: SortOption.dateLatest,
                                              child: Text('Date: Latest First'),
                                            ),
                                            const PopupMenuItem<SortOption>(
                                              value: SortOption.dateOldest,
                                              child: Text('Date: Oldest First'),
                                            ),
                                            const PopupMenuItem<SortOption>(
                                              value: SortOption.statusAsc,
                                              child: Text('Status: A-Z'),
                                            ),
                                            const PopupMenuItem<SortOption>(
                                              value: SortOption.statusDesc,
                                              child: Text('Status: Z-A'),
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
                              _filteredData.isNotEmpty
                                  ? buildStakingTable(_filteredData, screenWidth, context)
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
