import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/transactions/widgets/transaction_table.dart';
import 'package:provider/provider.dart';

import '../../../../../framework/components/AddressFieldComponent.dart';
import '../../../../../framework/components/searchControllerComponent.dart';
import '../../../../../framework/res/colors.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/sort_option.dart';
import '../../../../data/dummyData/staking_dummy_data.dart';
import '../../../../domain/usecases/sort_data.dart';
import '../../viewmodel/side_navigation_provider.dart';
import '../../../side_nav_bar.dart';


class ReferralStatScreen extends StatefulWidget {
  const ReferralStatScreen({super.key});

  @override
  State<ReferralStatScreen> createState() => _ReferralStatScreenState();
}

class _ReferralStatScreenState extends State<ReferralStatScreen> {
  SortTransactionHistoryOption? _currentSort;
  final SortTransactionDataUseCase _sortDataUseCase = SortTransactionDataUseCase();
  TextEditingController inputController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _displayData = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

    final containerWidth = screenWidth;
    final containerHeight = screenHeight * 0.12;
    final minContainerHeight = screenHeight * 0.13;

    final horizontalPadding = containerWidth * 0.03;
    final itemSpacing = screenWidth * 0.02;

    double getResponsiveRadius(double base) => base * (screenWidth / 360);
    final navProvider = Provider.of<NavigationProvider>(context);
    final currentScreenId = navProvider.currentScreenId;
    final navItems = navProvider.drawerNavItems;

    return  Scaffold(
        key: _scaffoldKey,
        drawerEnableOpenDragGesture: true,
        drawerEdgeDragWidth: 80,
        drawer: SideNavBar(
          currentScreenId: currentScreenId,
          navItems: navItems,
          onScreenSelected: (id) => navProvider.setScreen(id),
          onLogoutTapped: () {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Logout Pressed")));
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
                  image: AssetImage('assets/icons/starGradientBg.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topRight,
                ),
              ),
              child:
              Column(
                children: [
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
                            'Referral Stat',
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

                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.01,
                        vertical: screenHeight * 0.02,
                      ),
                      child: SingleChildScrollView(

                        child: ConstrainedBox(

                          constraints: BoxConstraints(
                            minHeight: screenHeight - kToolbarHeight,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // SizedBox(height: screenHeight * 0.01),
                              _buildHeader(context),

                              SizedBox(height: screenHeight * 0.03),

                               /// Referral Link
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: const Color(0xff040C16).withOpacity(0.50),
                                    borderRadius: BorderRadius.circular(12)
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

                              SizedBox(height: screenHeight * 0.03),


                              Container(
                                width: double.infinity,
                                height: containerHeight < minContainerHeight ? minContainerHeight : containerHeight,

                                decoration: BoxDecoration(
                                  // color: const Color(0xFF01090B),
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
                                          value: '202',
                                          gradient: const LinearGradient(
                                            begin: Alignment(0.99, 0.14),
                                            end: Alignment(-0.99, -0.14),
                                            colors: [Color(0xFF040C16), Color(0xFF162B4A)],
                                          ),
                                          imageUrl: "assets/icons/totalTransactionRefBg.png",
                                        ),
                                      ),
                                      SizedBox(width: itemSpacing),
                                      Expanded(
                                        child: _buildStatCard(
                                          title: 'Total ECM Bought',
                                          value: '30.000',
                                          gradient: const LinearGradient(
                                            begin: Alignment(0.99, 0.14),
                                            end: Alignment(-0.99, -0.14),
                                            colors: [Color(0xFF040C16), Color(0xFF162B4A)],
                                          ),
                                          imageUrl: "assets/icons/totalEcmRefBg.png",
                                        ),
                                      ),
                                      SizedBox(width: itemSpacing),
                                      Expanded(
                                        child: _buildStatCard(
                                          title: 'Total Referral User',
                                          value: '450',
                                          gradient: const LinearGradient(
                                            begin: Alignment(0.99, 0.14),
                                            end: Alignment(-0.99, -0.14),
                                            colors: [Color(0xFF101A29), Color(0xFF162B4A), Color(0xFF132239)],
                                          ),
                                          imageUrl: "assets/icons/totalRefUserBg.png",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),


                              SizedBox(height: screenHeight * 0.030),
                              Text(
                                'Referral User List',
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


  Widget _buildHeader(BuildContext context) {
    final drawerWidth = MediaQuery.of(context).size.width ;
    final double avatarRadius = drawerWidth * 0.054;
    final double verticalPadding = drawerWidth * 0.08;

     final double containerPadding = drawerWidth * 0.025;

    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: drawerWidth * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: avatarRadius,
            backgroundImage: const AssetImage('assets/icons/ecm.png'), // Ensure asset exists
            backgroundColor: Colors.white.withOpacity(0.3),
          ),
          SizedBox(width: drawerWidth * 0.02),

          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Abdur Salam',
                style: TextStyle(
                  color: AppColors.profileName,
                  fontSize: getResponsiveFontSize(context, 16),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  height: 1.3,
                ),
              ),
              SizedBox(height: drawerWidth * 0.01),

              Container(

                padding: EdgeInsets.symmetric(
                  vertical: containerPadding * 0.2,
                  horizontal: containerPadding,
                ),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(drawerWidth * 0.01),
                  border: Border.all(color: Color(0XFF1CD494).withOpacity(0.40)),
                  color: Color(0XFF1CD494).withOpacity(0.20),
                 ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: AppColors.whiteColor, size: drawerWidth * 0.035),
                    SizedBox(width: drawerWidth * 0.010),
                    Text(
                      'User ID: 5268574132',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: getResponsiveFontSize(context, 10),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        height: 1.6,

                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),



        ],
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
          fit: BoxFit.fitHeight,
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
