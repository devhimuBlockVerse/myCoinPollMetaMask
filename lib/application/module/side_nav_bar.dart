import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../framework/res/colors.dart';
import '../domain/model/nav_item.dart';
import '../presentation/models/user_model.dart';
import '../presentation/viewmodel/personal_information_viewmodel/personal_view_model.dart';
import '../presentation/viewmodel/wallet_view_model.dart';

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
  UserModel? currentUser;
  String? uniqueId;



  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadUserId();

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

  void _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uniqueId = prefs.getString('unique_id') ?? '';
    });
  }

   @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final drawerWidth = screenWidth * 0.55;
    final WalletViewModel model = Provider.of<WalletViewModel>(context, listen: true);

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
                image: AssetImage('assets/images/sideNav_BG.png'),
                fit: BoxFit.fill,
               ),
             ),
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.020,vertical: screenHeight * 0.020),
              children: <Widget>[
                _buildHeader(context, drawerWidth ,model),

                ...widget.navItems.map((item) => _buildNavItem(context, item, drawerWidth)).toList(),

               ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildHeader(BuildContext context, double drawerWidth,WalletViewModel model) {
    final double avatarRadius = drawerWidth * 0.30;
    final double verticalPadding = drawerWidth * 0.08;
    final double nameFontSize = drawerWidth * 0.06;
    final double idFontSize = drawerWidth * 0.04;
    final double iconSize = drawerWidth * 0.05;
    final double containerPadding = drawerWidth * 0.025;
    final profileVM = Provider.of<PersonalViewModel>(context);
    final pickedImage = profileVM.pickedImage;


    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height:avatarRadius,
            width:avatarRadius,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: pickedImage != null
                    ? FileImage(pickedImage)
                    : (profileVM.originalImagePath != null && File(profileVM.originalImagePath!).existsSync())
                    ? FileImage(File(profileVM.originalImagePath!))
                    : const NetworkImage("https://mycoinpoll.com/_ipx/q_20&s_50x50/images/dashboard/icon/user.png") as ImageProvider,

                fit: BoxFit.fill,
              ),
              shape: OvalBorder(
                side: BorderSide( color: Colors.transparent),
              ),
            ),
          ),

          SizedBox(height: drawerWidth * 0.03),
          Text(
             model.walletConnectedManually || currentUser == null ? 'Hi, Ethereum User!': currentUser!.name,
            style: TextStyle(
              color: AppColors.profileName,
              fontSize: nameFontSize,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              height: 1.3,
            ),
          ),
          SizedBox(height: drawerWidth * 0.01),

          Container(
            padding: EdgeInsets.symmetric(
              vertical: containerPadding * 0.6,
              horizontal: containerPadding,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(drawerWidth * 0.01),
              border: Border.all(color: AppColors.userIdText.withOpacity(0.40)),
              color: AppColors.userIdText.withOpacity(0.20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: AppColors.whiteColor, size: iconSize),
                SizedBox(width: drawerWidth * 0.015),
                Text(
                   'User ID: ${uniqueId ?? '...'}',
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: idFontSize,
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
    );
  }

  Widget _buildNavItem(BuildContext context, NavItem item, double drawerWidth) {
    final bool isSelected = item.id == widget.currentScreenId;
    final double itemHorizontalPadding = drawerWidth * 0.05;
    final double itemFontSize = drawerWidth * 0.058;
    final double itemIconSize = drawerWidth * 0.09;

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

        if (item.onTap != null) {
          item.onTap!(context);
        } else if (item.screenBuilder != null) {
          widget.onScreenSelected(item.id);
          await Navigator.push(
            context,
            MaterialPageRoute(builder: item.screenBuilder!),
          );
        }

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
                ? 'assets/images/sideNavSelectedOptionsBg.png'
                : 'assets/images/sideNavUnselectedOptionsBg.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: navTile,
    );

    return navTile;
  }

 }
