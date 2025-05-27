import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/viewmodel/side_navigation_provider.dart';
import 'package:provider/provider.dart';

import '../../framework/res/colors.dart';
import '../domain/model/nav_item.dart';


class SideNavBar extends StatefulWidget {
  final String? currentScreenId;
  final Function(String screenId) onScreenSelected;
  final List<NavItem> navItems;
  final VoidCallback? onLogoutTapped;

  const SideNavBar({
    Key? key,
    this.currentScreenId,
    required this.onScreenSelected,
    required this.navItems,
    this.onLogoutTapped,
  }) : super(key: key);

  @override
  State<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final drawerWidth = screenWidth * 0.55;

    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        backgroundColor: Colors.transparent,
        child: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              color:   Color(0xff040C16),

              image: DecorationImage(
                image: AssetImage('assets/icons/sideNav_BG.png'),
                fit: BoxFit.fill,
               ),
             ),
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.020,vertical: screenHeight * 0.020),
              children: <Widget>[
                _buildHeader(context, drawerWidth),

                ...widget.navItems.map((item) => _buildNavItem(context, item, drawerWidth)).toList(),

                // if (widget.onLogoutTapped != null) _buildLogoutItem(context, drawerWidth),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildHeader(BuildContext context, double drawerWidth) {
    final double avatarRadius = drawerWidth * 0.15;
    final double verticalPadding = drawerWidth * 0.08;
    final double nameFontSize = drawerWidth * 0.06;
    final double idFontSize = drawerWidth * 0.04;
    final double iconSize = drawerWidth * 0.05;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: avatarRadius,
            backgroundImage: const AssetImage('assets/icons/ecm.png'), // Ensure asset exists
            backgroundColor: Colors.white.withOpacity(0.3),
          ),
          SizedBox(height: drawerWidth * 0.03),
          Text(
            'Abdur Salam',
            style: TextStyle(
              color: AppColors.profileName,
              fontSize: nameFontSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: drawerWidth * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: AppColors.userIdText, size: iconSize),
              SizedBox(width: drawerWidth * 0.015),
              Text(
                'User ID: 5268574132',
                style: TextStyle(
                  color: AppColors.userIdText,
                  fontSize: idFontSize,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, NavItem item, double drawerWidth) {
    final bool isSelected = item.id == widget.currentScreenId;
    final double itemHorizontalPadding = drawerWidth * 0.05;
    final double itemFontSize = drawerWidth * 0.045;
    final double itemIconSize = drawerWidth * 0.07;

    Widget navTile = ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: itemHorizontalPadding, vertical: drawerWidth * 0.001),
      leading: SvgPicture.asset(
        item.iconPath,
        width: itemIconSize,
        height: itemIconSize,
        fit: BoxFit.scaleDown,
      ),
      title: Text(
        item.title,
        style: TextStyle(
          color: isSelected ? AppColors.navItemSelected : AppColors.navItemDefault,
          fontSize: itemFontSize,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          fontFamily: 'Poppins',
        ),
      ),
      onTap: () async {
        Navigator.pop(context);
        widget.onScreenSelected(item.id);

         await Navigator.push(
          context,
          MaterialPageRoute(builder: item.screenBuilder),
        );

      },
    );

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: itemHorizontalPadding / 2,
        vertical: drawerWidth * 0.02,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            isSelected
                ? 'assets/icons/sideNavSelectedOptionsBg.png'
                : 'assets/icons/sideNavUnselectedOptionsBg.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: navTile,
    );

    return navTile;
  }

 }
