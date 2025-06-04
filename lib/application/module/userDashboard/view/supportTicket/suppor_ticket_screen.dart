import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/components/searchControllerComponent.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/sort_option.dart';
import '../../../../data/faq_item_data.dart';
import '../../../../domain/model/TicketListModel.dart';
import '../../../../domain/model/ticket_list_dummy_data.dart';
import '../../../../domain/usecases/sort_data.dart';
import '../../../dashboard_bottom_nav.dart';
import '../../../side_nav_bar.dart';
 import '../../viewmodel/side_navigation_provider.dart';
import 'create_new_ticket_screen.dart';
import 'widget/ticket_table.dart';

class SupportTicketScreen extends StatefulWidget {
  const SupportTicketScreen({super.key});

  @override
  State<SupportTicketScreen> createState() => _SupportTicketScreenState();
}

class _SupportTicketScreenState extends State<SupportTicketScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SortTicketListOption? _currentSort;
  final SortTableListUseCase _sortDataUseCase = SortTableListUseCase();
  TextEditingController inputController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<TicketListModel> _displayData = [];


  int _currentlyExpandedIndex = -1;

  @override
  void initState() {
    super.initState();
    _displayData = List.from(ticketListData);
    _searchController.addListener(_applyFiltersAndSort);

  }

  void _applyFiltersAndSort() {
    List<TicketListModel> currentFilteredData = List.from(ticketListData); // Start with the original full data
    String query = _searchController.text.toLowerCase().trim(); // Trim whitespace

    // Search filter based on UserLogModel fields
    if (query.isNotEmpty) {
      currentFilteredData = currentFilteredData.where((userLog) {
        // Check each relevant field for the query
        return userLog.date.toLowerCase().contains(query) ||
            userLog.subject.toLowerCase().contains(query) ||
            userLog.ticketID.toLowerCase().contains(query) ||
            userLog.status.toLowerCase().contains(query);
      }).toList();
    }

    // Sorting if a sort option is selected
    if (_currentSort != null) {
      currentFilteredData = _sortDataUseCase(currentFilteredData, _currentSort!);
    }

    setState(() {
      _displayData = currentFilteredData;
    });
  }



  void _sortData(SortTicketListOption option) {
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
    final itemSpacing = screenWidth * 0.02;


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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// App bar row
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
                      onPressed: () =>Navigator.push(context, MaterialPageRoute(builder: (context) =>  DashboardBottomNavBar()))
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Support Ticket",
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

              /// Main content area
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.02,
                  ),
                  child: ListView(
                    children: [

                      /// Create New Ticket Button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                        child: Container(
                           height: screenHeight * 0.14,
                          decoration: ShapeDecoration(
                            color: const Color(0x66040C16),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 0.50, color: Color(0xFFB2B0B6)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: BlockButton(
                                  height: screenHeight * 0.05,
                                  width: screenWidth * 0.6,
                                  label: 'Create New Ticket',
                                  textStyle:  TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                     fontSize: getResponsiveFontSize(context, 15),
                                    height: 1.6,
                                  ),
                                  gradientColors: const [
                                    Color(0xFF2680EF),
                                    Color(0xFF1CD494),
                                    // 1CD494
                                  ],
                                  onTap: () {
                                   Navigator.push(context, MaterialPageRoute(builder: (context) =>  CreateNewTicketScreen()));

                                  },
                                  leadingIconPath: 'assets/icons/addIcon.svg',
                                  iconSize : screenHeight * 0.019,
                                ),
                              ),
                            ],
                          ),

                        ),
                      ),


                      /// Ticket Table
                      SizedBox(height: screenHeight * 0.030),
                      Text(
                        'Ticket List',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: getResponsiveFontSize(context, 17),
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
                                 onChanged:  (value) => _applyFiltersAndSort(),
                                svgAssetPath: 'assets/icons/search.svg',

                              ),
                            ),


                            /// Data Sorting  Button
                            Expanded(
                              flex: 1,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: PopupMenuButton<SortTicketListOption>(
                                    icon: SvgPicture.asset(
                                      'assets/icons/sortingList.svg',
                                      fit: BoxFit.contain,
                                    ),
                                    onSelected: ( option) {
                                      _sortData(option);
                                    },
                                    itemBuilder: (BuildContext context) => <PopupMenuEntry<SortTicketListOption>>[
                                      const PopupMenuItem<SortTicketListOption>(
                                        value: SortTicketListOption.dateLatest,
                                        child: Text('Date: Latest First'),
                                      ),
                                      const PopupMenuItem<SortTicketListOption>(
                                        value: SortTicketListOption.dateOldest,
                                        child: Text('Date: Oldest First'),
                                      ),

                                      const PopupMenuItem<SortTicketListOption>(
                                        value: SortTicketListOption.statusAsc,
                                        child: Text('Status: Active First'),
                                      ),
                                      const PopupMenuItem<SortTicketListOption>(
                                        value: SortTicketListOption.statusDesc,
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
                        _displayData.isNotEmpty
                            ? buildTicketTable(_displayData, screenWidth, context)
                            : Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(20),
                          child: const Text(
                            'No data found',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],


                      SizedBox(height: screenHeight * 0.05),

                      Text(
                        "Frequently Asked Questions",
                        style: TextStyle(
                          fontSize: getResponsiveFontSize(context, 16),
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.1,
                          fontFamily: 'Poppins',
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.05),


                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: faqList.length,
                        itemBuilder: (context, index) {
                          final faq = faqList[index];
                          final isExpanded = _currentlyExpandedIndex == index;

                          return Container(
                            margin: EdgeInsets.only(bottom: screenHeight * 0.018),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0x33FFFFFF),
                                width: 1,
                              ),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0x22FFFFFF),
                                  Colors.transparent,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                stops: [0.0, 0.09],
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x33000000),
                                  blurRadius: 2,
                                  offset: Offset(0, 4),
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent,
                              ),
                              child: ExpansionTile(
                                key: Key(index.toString()),
                                tilePadding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.04,
                                ),

                                collapsedBackgroundColor: Colors.transparent,
                                backgroundColor: Colors.transparent,
                                collapsedIconColor: Colors.white,
                                iconColor: Colors.white,
                                initiallyExpanded: isExpanded,
                                onExpansionChanged: (expanded) {
                                  setState(() {
                                    _currentlyExpandedIndex = expanded ? index : -1;
                                  });
                                },
                                trailing: Icon(
                                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                  size: screenHeight * 0.03,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  faq.question,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: getResponsiveFontSize(context, 14),
                                    fontWeight: FontWeight.w500,
                                    height: 1.6,
                                  ),
                                ),
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                    child: Text(
                                      faq.answer,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                        fontSize: getResponsiveFontSize(context, 12),
                                        fontWeight: FontWeight.w400,
                                        height: 1.6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
}

