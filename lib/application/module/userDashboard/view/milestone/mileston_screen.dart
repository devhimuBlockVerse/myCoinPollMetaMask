import 'package:flutter/material.dart';
 import 'package:flutter_svg/svg.dart';
  import 'package:provider/provider.dart';

 import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/sort_option.dart';
import '../../../../data/staking_dummy_data.dart';
import '../../../../domain/usecases/sort_data.dart';
import '../../viewmodel/side_navigation_provider.dart';
import '../../../side_nav_bar.dart';
import '../kyc/kyc_screen.dart';
import 'widget/milestone_lists.dart';

class MilestonScreen extends StatefulWidget {

  const MilestonScreen({super.key });

  @override
  State<MilestonScreen> createState() => _MilestonScreenState();
}

class _MilestonScreenState extends State<MilestonScreen> {



  SortTransactionHistoryOption? _currentSort;
  final SortTransactionDataUseCase _sortDataUseCase = SortTransactionDataUseCase();
  TextEditingController inputController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
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


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // This data would come from an API via a state management solution
  final List<EcmTaskModel> _tasks = [
    EcmTaskModel(
      id: '1',
      title: 'Sell 1000 ECM Coin',
      imageUrl: 'https://picsum.photos/seed/1/200/220', // Placeholder image
      targetSales: '1000 ECM',
      deadline: '10 May 2025',
      reward: RewardModel(primaryReward: '\$200 USD'),
      milestoneMessage: 'You will Get \$200 after completing the milestone.',
      status: EcmTaskStatus.active,
    ),
    EcmTaskModel(
      id: '2',
      title: 'Engage Community for ECM',
      imageUrl: 'https://picsum.photos/seed/2/200/220', // Placeholder image
      targetSales: '500 Interactions',
      deadline: '15 June 2025',
      reward: RewardModel(primaryReward: 'Tour Trip; 200 USD'),
      milestoneMessage: 'You will Get Tour & \$200 after completing the milestone.',
      status: EcmTaskStatus.completed,
    ),
    EcmTaskModel(
      id: '3',
      title: 'Develop New ECM Feature',
      imageUrl: 'https://picsum.photos/seed/3/200/220', // Placeholder image
      targetSales: '1 Feature',
      deadline: '30 July 2025',
      reward: RewardModel(primaryReward: '\$350 USD'),
      milestoneMessage: 'You will Get \$350 after completing the milestone.',
      status: EcmTaskStatus.ongoing,
    ),
  ];

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
                        'Milestone',
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
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.02,
                  ),
                  child: ListView(
                    children: [
                      // Stat Cards
                      Container(
                        width: screenWidth,
                        height: containerHeight < minContainerHeight
                            ? minContainerHeight
                            : containerHeight,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/icons/buildStatCardBG.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  title: 'Total Milestone',
                                  value: '1250',
                                  gradient: const LinearGradient(
                                    begin: Alignment(0.99, 0.14),
                                    end: Alignment(-0.99, -0.14),
                                    colors: [Color(0xFF040C16), Color(0xFF162B4A)],
                                  ),
                                  imageUrl: "assets/icons/milestoneStatFrameBg.png",
                                ),
                              ),
                              SizedBox(width: itemSpacing),
                              Expanded(
                                child: _buildStatCard(
                                  title: 'Active Milestone',
                                  value: '1200',
                                  gradient: const LinearGradient(
                                    begin: Alignment(0.99, 0.14),
                                    end: Alignment(-0.99, -0.14),
                                    colors: [Color(0xFF040C16), Color(0xFF162B4A)],
                                  ),
                                  imageUrl: "assets/icons/milestoneStatFrameBg.png",
                                ),
                              ),
                              SizedBox(width: itemSpacing),
                              Expanded(
                                child: _buildStatCard(
                                  title: 'Complete',
                                  value: '1000',
                                  gradient: const LinearGradient(
                                    begin: Alignment(0.99, 0.14),
                                    end: Alignment(-0.99, -0.14),
                                    colors: [Color(0xFF101A29), Color(0xFF162B4A), Color(0xFF132239)],
                                  ),
                                  imageUrl: "assets/icons/milestoneStatFrameBg.png",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.030),

                      // Milestone list
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _tasks.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              MilestoneLists(task: _tasks[index]),
                              SizedBox(height: screenHeight * 0.020),

                            ],
                          );
                        },
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


  Widget _buildStatCard({
    required String title,
    required String value,
    required LinearGradient gradient,
    String? imageUrl,
    Color? borderColor,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final borderRadius = screenWidth * 0.009;
    final verticalContentPadding = screenWidth * 0.02;

    return Container(
      width: screenWidth,
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
        )
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02,
          vertical: verticalContentPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: getResponsiveFontSize(context, 12),
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ),
            SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: getResponsiveFontSize(context, 16),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }




}

