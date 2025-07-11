import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
 import 'package:http/http.dart' as http;
 import 'package:mycoinpoll_metamask/application/module/userDashboard/view/referralStat/widgets/referral_stat_table.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../framework/components/AddressFieldComponent.dart';
import '../../../../../framework/components/searchControllerComponent.dart';
import '../../../../../framework/res/colors.dart';
import '../../../../../framework/utils/customToastMessage.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/sort_option.dart';
import '../../../../../framework/utils/enums/toast_type.dart';
  import '../../../../data/services/api_service.dart';
import '../../../../domain/model/ReferralUserListModel.dart';
import '../../../../domain/usecases/sort_data.dart';
import '../../../../presentation/models/get_referral_stats.dart';
import '../../../../presentation/models/user_model.dart';
import '../../../../presentation/viewmodel/wallet_view_model.dart';
import '../../viewmodel/side_navigation_provider.dart';
import '../../../side_nav_bar.dart';


class ReferralStatScreen extends StatefulWidget {
  const ReferralStatScreen({super.key});

  @override
  State<ReferralStatScreen> createState() => _ReferralStatScreenState();
}

class _ReferralStatScreenState extends State<ReferralStatScreen> {
  UserModel? currentUser;
  ReferralStatsModel? _referralStats;


  SortReferralUserListOption? _currentSort;
  final SortReferralUseListUseCase _sortDataUseCase = SortReferralUseListUseCase();
  TextEditingController inputController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<ReferralUserListModel> _displayData = [];
  List<ReferralUserListModel> _originalData = [];

  bool _isLoading = true;
  String? _errorMessage;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // _displayData = List.from(referralUserListData);
    _searchController.addListener(_applyFiltersAndSort);

    _loadCurrentUser();
    _loadReferralUsers();
    _loadReferralStats();

  }


  void _applyFiltersAndSort() {
    String query = _searchController.text.toLowerCase().trim();

    List<ReferralUserListModel> filtered = _originalData.where((userLog) {
      return userLog.sl.toLowerCase().contains(query) ||
          userLog.date.toLowerCase().contains(query) ||
          userLog.name.toLowerCase().contains(query) ||
          userLog.userId.toLowerCase().contains(query) ||
          userLog.status.toLowerCase().contains(query);
    }).toList();

    if (_currentSort != null) {
      filtered = _sortDataUseCase(filtered, _currentSort!);
    }

    setState(() {
      _displayData = filtered;
    });
  }


  Future<void> _loadReferralUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final logs = await ApiService().fetchReferralUsers();
      setState(() {
        _originalData = logs;
        _displayData = List.from(logs);
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _sortData(SortReferralUserListOption option) {
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


  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    if (userJson != null) {
      setState(() {
        currentUser = UserModel.fromJson(jsonDecode(userJson));
      });
    }
  }

  Future<void> _loadReferralStats() async {
    try {
      final stats = await ApiService().fetchReferralStats();
      setState(() {
        _referralStats = stats;
      });
    } catch (e) {
      debugPrint('Error fetching stats: $e');
    }
  }


  Future<List<ReferralUserListModel>> fetchReferralUsers({String? search}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    final url = Uri.parse(
      search != null && search.isNotEmpty
          ? 'https://app.mycoinpoll.com/api/v1/get-referral-users?page=1&search=$search'
          : 'https://app.mycoinpoll.com/api/v1/get-referral-users?page=1',
    );

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = json.decode(response.body);
      final List<dynamic> data = decoded['data'];
      return data.map((e) => ReferralUserListModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch referral users: ${response.statusCode}');
    }
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
    final WalletViewModel model = Provider.of<WalletViewModel>(context, listen: true);



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
                      child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(overscroll: false),

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
                                // SizedBox(height: screenHeight * 0.01),
                                _buildHeader(context,model),

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
                                          const referralLink = 'https://mycoinpoll.com?ref=125482458661';

                                          Clipboard.setData(const ClipboardData(text:referralLink));

                                          ToastMessage.show(
                                            message: "Referral link copied!",
                                            subtitle: referralLink,
                                            type: MessageType.success,
                                            duration: CustomToastLength.SHORT,
                                            gravity: CustomToastGravity.BOTTOM,
                                          );

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
                                            title: 'Total \nReferrals',
                                             value: _referralStats != null ? _referralStats!.totalReferrals.toString() : '0',

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
                                            // value: '30.000',
                                            value: _referralStats != null ? _referralStats!.totalReferralAmount.truncate().toString() : '0',
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
                                            title: 'Total ECM Paid',
                                            // value: '450',
                                            value: _referralStats != null ? _referralStats!.totalPurchaseUsers.toString() : '0',
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
                                            child: PopupMenuButton<SortReferralUserListOption>(
                                              icon: SvgPicture.asset(
                                                'assets/icons/sortingList.svg',
                                                fit: BoxFit.contain,
                                              ),
                                              onSelected: (SortReferralUserListOption option) {
                                                _sortData(option);
                                              },
                                              itemBuilder: (BuildContext context) => <PopupMenuEntry<SortReferralUserListOption>>[
                                                const PopupMenuItem<SortReferralUserListOption>(
                                                  value: SortReferralUserListOption.dateDesc,
                                                  child: Text('Date: Latest First'),
                                                ),
                                                const PopupMenuItem<SortReferralUserListOption>(
                                                  value: SortReferralUserListOption.dateAsc,
                                                  child: Text('Date: Oldest First'),
                                                ),
                                                const PopupMenuItem<SortReferralUserListOption>(
                                                  value: SortReferralUserListOption.nameAsc,
                                                  child: Text('Status: A-Z'),
                                                ),
                                                const PopupMenuItem<SortReferralUserListOption>(
                                                  value: SortReferralUserListOption.nameDesc,
                                                  child: Text('Status: Z-A'),
                                                ),
                                                const PopupMenuItem<SortReferralUserListOption>(
                                                  value: SortReferralUserListOption.userIdAsc,
                                                  child: Text('Amount: Low to High'),
                                                ),
                                                const PopupMenuItem<SortReferralUserListOption>(
                                                  value: SortReferralUserListOption.userIdDesc,
                                                  child: Text('Amount: High to Low'),
                                                ),
                                                const PopupMenuItem<SortReferralUserListOption>(
                                                  value: SortReferralUserListOption.statusAsc,
                                                  child: Text('Status: Active First'),
                                                ),
                                                const PopupMenuItem<SortReferralUserListOption>(
                                                  value: SortReferralUserListOption.statusDesc,
                                                  child: Text('Status: Inactive First'),
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

                                  _isLoading
                                      ? const Center(child: CircularProgressIndicator())
                                      : _displayData.isNotEmpty
                                      ? buildReferralUserListTable(_displayData, screenWidth, context)
                                       : Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(height: scaleHeight(38)),
                                            Text(
                                              'No Data Found',
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
                ],
              )
          ),
        )
    );
  }


  Widget _buildHeader(BuildContext context, WalletViewModel model) {
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
                model.walletConnectedManually || currentUser == null ? 'Hi, Ethereum User!': currentUser!.name,
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
