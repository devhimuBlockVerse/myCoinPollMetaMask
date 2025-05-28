import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../../framework/components/searchControllerComponent.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/sort_option.dart';
import '../../../../data/milestone_llist_dummy_data.dart';
 import '../../../../domain/model/milestone_list_models.dart';
import '../../../../domain/usecases/sort_data.dart';
import '../../viewmodel/side_navigation_provider.dart';
import '../../../side_nav_bar.dart';
import 'widget/milestone_lists.dart';

class MilestonScreen extends StatefulWidget {

  const MilestonScreen({super.key });

  @override
  State<MilestonScreen> createState() => _MilestonScreenState();
}

class _MilestonScreenState extends State<MilestonScreen> {



  SortMilestoneLists? _currentSort;
  final SortEcmTaskUseCase _sortEcmTaskUseCase = SortEcmTaskUseCase();

  TextEditingController inputController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<EcmTaskModel> _masterData = []; // Holds the original, unfiltered list
  List<EcmTaskModel> _displayData = []; // Holds the filtered and sorted list for display

  @override
  void initState() {
    super.initState();
    _masterData = List.from(milestoneListsData);
    _displayData = List.from(_masterData);

     _searchController.addListener(_applyFiltersAndSort);
    _applyFiltersAndSort();

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
                    vertical: screenHeight * 0.01,
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
                                ),
                              ),
                            ],
                          ),
                        ),

                      ),

                      SizedBox(height: screenHeight * 0.030),

                      Text(
                        'Milestone List',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: getResponsiveFontSize(context, 18),
                          height: 1.6,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.010),
                      /// Search And Sorting

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
                                    tooltip: "Sort Milestones",
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

                      // Milestone list
                      _displayData.isEmpty
                          ? Center(
                        child: Text(
                          _searchController.text.isNotEmpty
                              ? 'No milestones match your search.'
                              : 'No milestones available.',
                          style:TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      )
                          : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _displayData.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              MilestoneLists(task: _displayData[index]),
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
          image: DecorationImage(
            image: AssetImage('assets/icons/milestoneStatFrameBg.png'),
            fit: BoxFit.fill,
          )
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
                  fontFamily: 'Poppins',

                  fontSize: getResponsiveFontSize(context, 12),
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
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
                  fontFamily: 'Poppins',

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

