import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycoinpoll_metamask/framework/utils/customToastMessage.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';
import 'package:mycoinpoll_metamask/framework/utils/enums/toast_type.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/components/ListingFields.dart';
import '../../../../../framework/components/buy_Ecm.dart';
import '../../../../../framework/components/percentageSelectorComponent.dart';
import '../../../../../framework/components/searchControllerComponent.dart';
import '../../../../../framework/utils/decimalFormat.dart';
import '../../../../../framework/utils/enums/sort_option.dart';
import '../../../../domain/constants/api_constants.dart';
import '../../../../domain/usecases/sort_data.dart';
import '../../../../presentation/models/get_staking_history.dart';
import '../../../../presentation/models/staking_plan.dart';
import '../../../../presentation/viewmodel/wallet_view_model.dart';
import '../../viewmodel/dashboard_nav_provider.dart';
import '../../viewmodel/side_navigation_provider.dart';
import '../../../side_nav_bar.dart';
import 'widgets/staking_table.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart'as http;

class StakingScreen extends StatefulWidget {
  const StakingScreen({super.key});

  @override
  State<StakingScreen> createState() => _StakingScreenState();
}

class _StakingScreenState extends State<StakingScreen> {
  List<String> ecmPercentageOptions = ['25%', '50%', '75%', 'Max'];
  SortOption? _currentSort;

  final SortDataUseCase _sortDataUseCase = SortDataUseCase();
  TextEditingController ecmAmountController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _selectedDuration;
  String selectedDay  = '';
  double estimatedProfit = 0.0;
  double totalWithReward = 0.0;
  DateTime? unlockDate;
  String lockOverviewText = '';

  bool isLoading = false;
  Map<int, double> annualReturnRates = {};
  String _currentSelectedPercentage = '';
  String selectedPercentage = '';



  List<StakingPlanModel> stakingPlans = [];
  List<StakingPlanModel> filteredPlans = [];

  List<StakingHistoryModel> stakingHistory = [];
  List<StakingHistoryModel> filteredHistory = [];
  bool _isLoadingHistory = false;
  List<String> durationDropdownItems = ['Select Duration'];


  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    ecmAmountController.addListener(calculateRewards);

    _loadStakingPlans();
    fetchStakingHistory();

    _selectedDuration = 'Select Duration';
    calculateRewards();

    final walletProvider = Provider.of<WalletViewModel>(context, listen: false);
    walletProvider.getBalance();
    walletProvider.getMinimunStake();
    walletProvider.getMaximumStake();

  }

  Future<List<StakingPlanModel>> fetchStakingPlans( ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("No login token found.");
      return [];
    }

    final url = Uri.parse('${ApiConstants.baseUrl}/get-staking-plans');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        print('Response Body staking-plans: ${response.body}');

        final List<dynamic> decoded = json.decode(response.body);
        return decoded.map((json) => StakingPlanModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching staking plans: $e");
    }

    return [];
  }

  Future<void> fetchStakingHistory() async {
    setState(() => _isLoadingHistory = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      setState(() => _isLoadingHistory = false);
      return;
    }
    final url = Uri.parse('${ApiConstants.baseUrl}/get-staking-history');

    try {
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {

        print(">> Response Staking history: ${response.body}");

        final List<dynamic> decoded = json.decode(response.body);
        final List<StakingHistoryModel> history = decoded.map((json) => StakingHistoryModel.fromJson(json)).toList();
        setState(() {
          stakingHistory = history;
          filteredHistory = history;
          _isLoadingHistory = false;

        });
      }
    } catch (e) {
      print('Error fetching staking history: \$e');
      setState(() => _isLoadingHistory = false);

    }
  }

  Future<void> _loadStakingPlans() async {

    setState(() {
      isLoading = true;
    });
    final plans = await fetchStakingPlans();

    Map<int,double> rates = {};
    for (var plan in plans){
      rates[plan.duration] = plan.rewardPercentage / 100.0;

    }


    setState(() {
      stakingPlans = plans;
      filteredPlans = List.from(plans);
      annualReturnRates = rates;
      durationDropdownItems = ['Select Duration'] + stakingPlans.map((plan) => '${plan.duration} Days').toList();

      isLoading = false;
    });

  }

  /// Search Filtering
  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredHistory = stakingHistory;
      } else {
        filteredHistory = stakingHistory.where((item) {
          return item.status.toLowerCase().contains(query) ||
              item.createdAtFormatted.toLowerCase().contains(query) ||
              item.amount.toLowerCase().contains(query);
        }).toList();
      }
    });
  }


  void _sortData(SortOption option) {
    setState(() {
      _currentSort = option;
      filteredHistory = _sortDataUseCase(filteredHistory, option);
    });
  }

  @override
  void dispose() {
    ecmAmountController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  ///Calculates the Estimated Profits , Rewards ,  Rates ...etc
  void calculateRewards() {
    double ecmAmount = double.tryParse(ecmAmountController.text) ?? 0.0;

    int? numberOfDays = _selectedDuration != null ? int.tryParse(_selectedDuration!.replaceAll(RegExp(r'\D'), '')) : null;

    double annualRate = numberOfDays != null ? annualReturnRates[numberOfDays] ?? 0.0 : 0.0;
    double dailyRate = annualRate / 365;

    estimatedProfit = (ecmAmount > 0 && numberOfDays != null) ? ecmAmount * dailyRate * numberOfDays : 0.0;
    totalWithReward = ecmAmount + estimatedProfit;
    unlockDate = (numberOfDays != null) ? DateTime.now().add(Duration(days: numberOfDays)) : null;
    lockOverviewText = (ecmAmount > 0 && numberOfDays != null) ? "My ${ecmAmount.toStringAsFixed(2)} ECM Staked for $numberOfDays Days" : "";
    setState(() {});
  }

  String formatDateWithSuffix(DateTime date) {
    int day = date.day;
    String suffix = 'th';
    if (day == 1 || day == 21 || day == 31)
      suffix = 'st';
    else if (day == 2 || day == 22)
      suffix = 'nd';
    else if (day == 3 || day == 23) suffix = 'rd';
    return "$day$suffix, ${DateFormat('MMMM yyyy hh:mm a').format(date)}";
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final bool isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;
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
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Logout Pressed")));
          },
        ),
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
                    image: AssetImage('assets/images/starGradientBg.png'),
                    fit: BoxFit.cover,
                    alignment: Alignment.topRight,
                    filterQuality : FilterQuality.low
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
                        horizontal: screenWidth * 0.01,
                        vertical: screenHeight * 0.02,
                      ),
                      child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(overscroll: false),

                        child: RefreshIndicator(
                          onRefresh: () async {
                            await fetchStakingHistory();
                            await Provider.of<WalletViewModel>(context, listen: false).fetchConnectedWalletData();

                            setState(() {});
                          },
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),


                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // SizedBox(height: screenHeight * 0.01),

                                _header(),

                                SizedBox(height: screenHeight * 0.02),

                                _stakingDetails(),
                                SizedBox(height: screenHeight * 0.04),

                                // Consumer<WalletViewModel>(
                                //   builder: (context, walletVM, child) {
                                //     return  Center(
                                //       child: BlockButton(
                                //         height: baseSize * 0.12,
                                //         width: screenWidth * 0.7,
                                //         label: walletVM.isLoading ? "Processing..." : "Stake Now",
                                //         textStyle: TextStyle(
                                //           fontWeight: FontWeight.w700,
                                //           color: Colors.white,
                                //           fontSize: baseSize * 0.048,
                                //         ),
                                //         gradientColors: const [
                                //           Color(0xFF2680EF),
                                //           Color(0xFF1CD494),
                                //         ],
                                //         leadingIconPath: 'assets/icons/arrowIcon.svg',
                                //         iconSize: screenHeight * 0.013,
                                //         onTap: walletVM.isLoading
                                //             ? null
                                //             : () async {
                                //
                                //
                                //           // Validation and Selected Plan
                                //           double amount = double.tryParse(ecmAmountController.text) ?? 0.0;
                                //           int? durationDays = _selectedDuration != null
                                //               ? int.tryParse(_selectedDuration!.replaceAll(RegExp(r'\D'), ''))
                                //               : null;
                                //
                                //           if (amount <= 0 || durationDays == null) {
                                //             ToastMessage.show(
                                //               message: "Invalid Input",
                                //               subtitle: "Please enter a valid amount and select a duration.",
                                //               type: MessageType.info,
                                //             );
                                //             return;
                                //           }
                                //
                                //           final selectedPlan = stakingPlans.firstWhere(
                                //                 (plan) => plan.duration == durationDays,
                                //             orElse: () => StakingPlanModel(
                                //               id: -1,
                                //               duration: -1,
                                //               rewardPercentage: 0,
                                //               name: '',
                                //               isActive: 0,
                                //               currentPoll: 0.0,
                                //               maxPoll: 0.0,
                                //               createdAt: DateTime.now(),
                                //               updatedAt: DateTime.now(),
                                //             ),
                                //           );
                                //           print("🔍 Selected Plan: ${selectedPlan.name}, ID: ${selectedPlan.id}");
                                //
                                //           if (selectedPlan.id == -1) {
                                //             ToastMessage.show(
                                //               message: "Staking Plan Error",
                                //               subtitle: "Selected duration does not match any available staking plan.",
                                //               type: MessageType.error,
                                //             );
                                //             return;
                                //           }
                                //           showDialog(
                                //             context: context,
                                //             barrierDismissible: false,
                                //             builder: (BuildContext context) {
                                //               return const Center(
                                //                 child: CircularProgressIndicator(color: Colors.white),
                                //               );
                                //             },
                                //           );
                                //
                                //           try {
                                //             final planIndex = stakingPlans.indexWhere((plan) => plan.id == selectedPlan.id);
                                //             if (planIndex == -1) {
                                //               print("==== Plan ID not found in list.");
                                //               return;
                                //             }
                                //
                                //             final txHash = await walletVM.stakeNow(
                                //                 context,
                                //                 amount,
                                //                 planIndex
                                //
                                //             );
                                //             Navigator.of(context).pop();
                                //
                                //
                                //             if (txHash != null) {
                                //
                                //               ToastMessage.show(
                                //                 message: "Staking Successful!",
                                //                 subtitle: "Transaction: ${txHash.substring(0, 10)}...",
                                //                 type: MessageType.success,
                                //               );
                                //
                                //               // Refresh staking history after successful stake
                                //               await fetchStakingHistory();
                                //               await walletVM.getBalance();
                                //
                                //               // Clear inputs after successful stake
                                //               ecmAmountController.clear();
                                //               setState(() {
                                //                 _selectedDuration = 'Select Duration';
                                //                 _currentSelectedPercentage = '';
                                //                 calculateRewards(); // Reset any UI rewards display
                                //               });
                                //             }
                                //           } catch (e) {
                                //             Navigator.of(context).pop();
                                //             ToastMessage.show(
                                //               message: "Staking Failed",
                                //               subtitle: e.toString(),
                                //               type: MessageType.error,
                                //             );
                                //           }
                                //         },
                                //       ),
                                //     );
                                //   },
                                // ),

                                // SizedBox(height: screenHeight * 0.02),

                                Center(
                                  child: BlockButtonV2(
                                    text: 'Buy ECM',
                                    leadingImagePath: 'assets/icons/buyEcmLeadingImg.svg',
                                    onPressed: () {
                                      Provider.of<DashboardNavProvider>(context, listen: false).setIndex(1);

                                    },
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: baseSize * 0.048,
                                    ),
                                    height: baseSize * 0.12,
                                    width: screenWidth * 0.7,
                                  ),
                                ),


                                SizedBox(height: screenHeight * 0.030),
                                Text(
                                  'Staking History',
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

                                              ],
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.016),
                                Consumer<WalletViewModel>(
                                  builder: (context, walletVM, _) {

                                    if (isLoading) {
                                      return const Center(child: CircularProgressIndicator());
                                    }

                                    return filteredHistory.isNotEmpty
                                    // ? buildStakingTable(filteredHistory, screenWidth, context)
                                        ? buildStakingTable(filteredHistory, screenWidth, context,stakingPlans,walletVM ,fetchStakingHistory)
                                        : Center(
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
                                    );
                                  },
                                ),

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


  Widget _header(){
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final containerWidth = screenWidth * 0.9;
    final containerHeight = screenHeight * 0.05;
    final imageSize = screenWidth * 0.04;
    return Column(
      children: [
        Container(
          width: screenWidth,
          height: containerHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/headerbg.png'),
                fit: BoxFit.fill,
                filterQuality : FilterQuality.low
            ),
          ),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/ecmSmall.png'),
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.low
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  // 'My 0 ECM Stack for 180 Days',
                  lockOverviewText.isNotEmpty ? lockOverviewText : "Enter ECM to Stake",
                  style: TextStyle(
                    color: const Color(0xffFFFFFF),
                    fontSize: getResponsiveFontSize(context, 12),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _stakingDetails() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final listingFieldHeight = screenHeight * 0.048;

    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/stakingFrame.png'),
                fit: BoxFit.fill,
                filterQuality : FilterQuality.low
            ),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02,
              vertical:  screenHeight * 0.01
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: screenHeight * 0.005),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // Left side: Max + Input Amount
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [

                        Consumer<WalletViewModel>(builder: (context, model, child){
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Min: ${model.minimumStake ?? '...'}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                'Max: ${model.maximumStake ?? '...'}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),

                            ],
                          );
                        }
                        ),


                        const SizedBox(height: 6),
                        ListingField(
                          labelText: 'Input Amounts',
                          controller: ecmAmountController,
                          keyboard: TextInputType.number,
                          height: listingFieldHeight,
                          onChanged: (value) {
                            setState(() {
                              selectedPercentage = '';
                            });
                          },
                          width: double.infinity,
                          prefixPngPath: 'assets/images/ecm.png',
                          inputFormatters: [DecimalTextInputFormatter(),],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Right side: Dropdown
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(height: 26),
                        ListingField(
                          isDropdown: true,
                          labelText: '',
                          prefixSvgPath: 'assets/icons/timerImg.svg',
                          dropdownItems: durationDropdownItems,

                          selectedDropdownItem: _selectedDuration,
                          height: listingFieldHeight,
                          width: double.infinity,
                          onDropdownChanged: (newValue) {

                            if (newValue == null || newValue.isEmpty || newValue == 'Select Duration') return;
                            setState(() {
                              _selectedDuration = newValue;
                              selectedDay = newValue;
                            });
                            calculateRewards();
                          },

                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.02),

              /// Percentage Section
              Consumer<WalletViewModel>(builder: (context, walletVM, child){
                final balanceStr = walletVM.balance;
                final balance = double.tryParse(balanceStr ?? '0') ?? 0.0;
                return PercentageSelectorComponent(
                  options: ecmPercentageOptions,
                  initialSelection: _currentSelectedPercentage,
                  onSelected: (selected) {

                    double percentageValue;
                    switch (selected) {
                      case '25%':
                        percentageValue = balance * 0.25;
                        break;
                      case '50%':
                        percentageValue = balance * 0.50;
                        break;
                      case '75%':
                        percentageValue = balance * 0.75;
                        break;
                      case 'Max':
                        percentageValue = balance;
                        break;
                      default:
                        percentageValue = 0.0;
                    }
                    ecmAmountController.text = percentageValue.toStringAsFixed(2);
                    calculateRewards();
                    setState(() {
                      _currentSelectedPercentage = selected;
                    });


                  },
                );
              }),
              SizedBox(height: screenHeight * 0.02),

              Center(
                child: SizedBox(
                  width: screenWidth * 0.4,
                  child: const Divider(
                    color: Color(0xff2C2E41),
                    thickness: 1,
                    height: 1,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              /// Detail Table Section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _detailsFrame(),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _detailsFrame(){
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01, vertical: screenHeight * 0.008),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildInfoRow("Stack amount", "${ecmAmountController.text} ECM"),
                  SizedBox(height: screenHeight * 0.01),
                  _buildInfoRow("Estimated Profit","${estimatedProfit.toStringAsFixed(3)} ECM", valueColor: const Color(0xFF1CD494)),
                  SizedBox(height: screenHeight * 0.01),
                  _buildInfoRow("Total with Reward","${totalWithReward.toStringAsFixed(3)} ECM"),
                ],
              ),
            ),

            SizedBox(width: screenWidth * 0.03),

            // Vertical Divider
            Container(
              width: 1,
              color: const Color(0xCC2C2E41),
              height: null,
            ),

            SizedBox(width: screenWidth * 0.03),

            // Right Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Builder(
                    builder: (context) {
                      int? durationKey = int.tryParse(selectedDay.replaceAll(' Days', '').trim());

                      String rateText = durationKey != null
                          ? "${(annualReturnRates[durationKey] ?? 0.0) * 100}%"
                          : "0%";
                      return _buildInfoRow("Annual Return Rate", rateText);
                    },
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  _buildInfoRow("Duration", "${selectedDay.replaceAll('Days', '')} Days", valueColor: const Color(0xFF1CD494)),
                  SizedBox(height: screenHeight * 0.01),
                  _buildInfoRow("Unlocked on", unlockDate != null ? formatDateWithSuffix(unlockDate!) : "Not Available"),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }

  Widget _buildInfoRow(String label, String value, {Color valueColor = Colors.white}) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: getResponsiveFontSize(context, 12),
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.01),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: valueColor,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: getResponsiveFontSize(context, 12),
            ),
          ),
        ),
      ],
    );
  }



}







