 import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
 import 'package:mycoinpoll_metamask/application/presentation/viewmodel/wallet_view_model.dart';
import 'package:mycoinpoll_metamask/framework/components/trasnactionStatusCompoent.dart';
import 'package:provider/provider.dart';
 import '../../../../../framework/components/AddressFieldComponent.dart';
import '../../../../../framework/components/userBadgeLevelCompoenet.dart';
import '../../../../../framework/components/walletAddressComponent.dart';
import '../../../../../framework/utils/customToastMessage.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/toast_type.dart';
 import '../../../../data/services/api_service.dart';
import '../../../../presentation/models/get_purchase_stats.dart';
 import '../../../../presentation/viewmodel/user_auth_provider.dart';
import '../../viewmodel/side_navigation_provider.dart';
import '../../../side_nav_bar.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // UserModel? currentUser;
  PurchaseStatsModel? _purchaseStats;
  bool _isNavigating = false;


  @override
  void initState() {
    super.initState();
    _setGreeting();
    // _loadUserFromPrefs();
    _loadPurchaseStats();
   }


  // Future<void> _loadUserFromPrefs() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');
  //   final userJson = prefs.getString('user');
  //
  //   if (token != null && userJson != null) {
  //     final userMap = jsonDecode(userJson);
  //     final loadedUser = UserModel.fromJson(userMap);
  //
  //     if (currentUser == null || currentUser?.id != loadedUser.id) {
  //       setState(() {
  //         currentUser = loadedUser;
  //       });
  //     }
  //   }
  // }
  String greeting = "";

  void _setGreeting() {
    final hour = DateTime.now().hour;
    greeting = hour >= 5 && hour < 12
        ? "Good Morning"
        : hour >= 12 && hour < 17
        ? "Good Afternoon"
        : hour >= 17 && hour < 21
        ? "Good Evening"
        : "Good Night";
  }


  Future<void> _loadPurchaseStats() async {
    try {
      final stats = await ApiService().fetchPurchaseStats();
      setState(() {
        _purchaseStats = stats;
      });
    } catch (e) {
      debugPrint('Error fetching stats: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;

    final navProvider = Provider.of<NavigationProvider>(context);
    final currentScreenId = navProvider.currentScreenId;
    final navItems = navProvider.drawerNavItems;

    final baseSize = isPortrait ? screenWidth : screenHeight;


    return WillPopScope(
      onWillPop: () async {
         return false;
      },
      child: Scaffold(
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
            // height: screenHeight * 0.9,
            decoration: const BoxDecoration(
               image: DecorationImage(
                 image: AssetImage('assets/images/starGradientBg.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topRight,
                   filterQuality : FilterQuality.low
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.01,
                vertical: screenHeight * 0.02,
              ),
              child: RefreshIndicator(
                onRefresh: () async {
                  // Reload prefs data
                  // await _loadUserFromPrefs();

                  final userAuth = Provider.of<UserAuthProvider>(context, listen: false);
                  await userAuth.loadUserFromPrefs();

                   final walletModel = Provider.of<WalletViewModel>(context, listen: false);
                  if (walletModel.isConnected) {
                    await walletModel.fetchConnectedWalletData();
                  } else {
                     await walletModel.reset();
                  }
                },

                child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: Consumer<WalletViewModel>(
                    builder: (context, walletModel, _) {

                      return  SingleChildScrollView(
                         physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [


                            /// User Name Data & Wallet Address
                            Consumer<UserAuthProvider>(
                              builder: (context, userAuth, child) {
                                return _headerSection(_scaffoldKey, walletModel, userAuth);
                              },
                            ),
                            SizedBox(height: screenHeight * 0.02),

                            /// User Graph Chart and Level
                            _EcmWithGraphChart(),
                            SizedBox(height: screenHeight * 0.03),


                            /// Referral Link
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: const Color(0xff040C16),
                                  borderRadius: BorderRadius.circular(12)
                              ),

                              child: ClipRRect(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: CustomLabeledInputField(
                                    labelText: 'Referral Link:',
                                    hintText: 'https://mycoinpoll.com?ref=125482458661',
                                    isReadOnly: true,
                                    trailingIconAsset: 'assets/icons/copyImg.svg',
                                    onTrailingIconTap: () {

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


                            _transactionsReferral(),

                            SizedBox(height: screenHeight * 0.1),


                          ],
                        ),
                      );
                    },

                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _headerSection(GlobalKey<ScaffoldState> scaffoldKey,WalletViewModel model,UserAuthProvider userAuthModel){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
     final baseSize = isPortrait ? screenWidth : screenHeight;
    bool canOpenModal = false;
    final currentUser = userAuthModel.user;

   return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent.withOpacity(0.1),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
              vertical: screenHeight * 0.015,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        scaffoldKey.currentState?.openDrawer();
                      },
                      child: SvgPicture.asset(
                        'assets/icons/drawerIcon.svg',
                        fit: BoxFit.contain,
                        height: getResponsiveFontSize(context, 16),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    /// User Info & Ro Text + Notification
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: getResponsiveFontSize(context, 14),
                            height: 1.6,
                            color: const Color(0xffFFF5ED),
                          ),
                        ),
                        Text(
                          model.walletConnectedManually || currentUser == null ? 'Hi, Ethereum User!': '${currentUser.name}',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: getResponsiveFontSize(context, 18),
                            height: 1.3,
                            color: const Color(0xffFFF5ED),
                          ),
                        ),
                        const SizedBox(width: 8),

                      ],
                    ),
                  ],
                ),



                /// Wallet Address
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Transform.translate(
                      offset: Offset(screenWidth * 0.025, 0),

                      child: WalletAddressComponent(
                        address:  model.walletConnectedManually || currentUser == null
                            ? formatAddress(model.walletAddress)
                            : formatAddress(currentUser!.ethAddress),
                          onTap: () async {
                            try {
                              /// ✅ Ensure modal is rebuilt with context
                              if (!model.walletConnectedManually) {
                                await model.ensureModalWithValidContext(context);
                                await model.appKitModal?.openModalView();
                              }

                            } catch (e) {
                              print("Error opening wallet modal: $e");
                             }
                          }


                      ),

                    ),


                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _EcmWithGraphChart(){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final walletVM = Provider.of<WalletViewModel>(context, listen: false);

    return FutureBuilder<String>(
      future: walletVM.getBalance(),
      builder: (context,snapshot){
        String balanceText = '...';
        if(snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active){
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          );

        }else if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasData){
            balanceText = snapshot.data!.toString();
          }else if(snapshot.hasError){
            balanceText = "Session expired";
          }
        }

        return Container(
            width: screenWidth,
            height: screenHeight * 0.16,
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.transparent
              ),
              image: const DecorationImage(
                image: AssetImage('assets/images/applyForListingBG.png'),
                filterQuality : FilterQuality.low,
                fit: BoxFit.fill,
              ),
            ),
            child: Stack(
              children: [

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.025,
                    vertical: screenHeight * 0.015,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/ecm.png',
                                  height: screenWidth * 0.04,
                                  fit: BoxFit.contain,
                                    filterQuality : FilterQuality.low
                                ),
                                SizedBox(width: screenWidth * 0.01),
                                Text(
                                  'ECM Coin',
                                  textAlign:TextAlign.start,
                                  style: TextStyle(
                                    color: const Color(0xffFFF5ED),
                                    fontFamily: 'Poppins',
                                    fontSize: getResponsiveFontSize(context, 16),
                                    fontWeight: FontWeight.normal,
                                    height: 1.6,
                                  ),
                                ),


                              ],
                            ),
                            Text(
                              formatBalance(balanceText),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: getResponsiveFontSize(context, 24),
                                  fontWeight: FontWeight.w600,
                                  height: 1.3
                              ),

                            ),
                            SizedBox(height: screenHeight * 0.01),
                          ],
                        ),
                      ),

                      SingleChildScrollView(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [

                            // Badge
                            const UserBadgeLevel(
                              label: 'Level-1',
                              iconPath: 'assets/icons/check.svg',
                            ),

                            SizedBox(height: screenHeight * 0.01),
                            Image.asset(
                              'assets/images/staticChart.png',
                              width: screenWidth * 0.38 ,
                              height: screenHeight * 0.08,
                              fit: BoxFit.contain,
                                filterQuality : FilterQuality.low
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
        );
      },


    );
  }


  Widget _transactionsReferral() {
    final Size screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final bool isPortrait = screenHeight > screenWidth;

    final baseSize = isPortrait ? screenWidth : screenHeight;

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Title Row
          Text(
            'Transactions',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: baseSize * 0.045,
              height: 1.2,
              color: Colors.white,
            ),
          ),
          SizedBox(height: screenWidth * 0.05),

          // Main Milestone Container
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.018,
              horizontal: screenWidth * 0.05,
            ),
            decoration:const BoxDecoration(
              image:  DecorationImage(
                image: AssetImage('assets/images/transactionBgContainer.png'),
                fit: BoxFit.fill,
                  filterQuality : FilterQuality.low
              ),
            ),
            child:  Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    TransactionStatCard(
                      bgImagePath: 'assets/images/colorYellow.png',
                      title: 'Transactions',
                       value: _purchaseStats != null ? _purchaseStats!.totalPurchases.toString() : '0',

                    ),
                    SizedBox(height: screenHeight * 0.01),

                     TransactionStatCard(
                      bgImagePath: 'assets/images/colorPurple.png',
                      title: 'Purchased Amount ',
                      value: _purchaseStats != null ? _purchaseStats!.totalPurchases.toString() : '0',

                     ),


                     SizedBox(height: screenHeight * 0.01),
                      TransactionStatCard(
                      bgImagePath: 'assets/images/colorYellow.png',
                       title: 'Attendant',
                         value: _purchaseStats != null ? _purchaseStats!.uniqueStages.toString() : '0',

                      ),

                    SizedBox(height: screenHeight * 0.001),

                  ],
                ),

                SizedBox(width: screenWidth * 0.1),

                Flexible(
                  flex: 1,
                  child: Image.asset('assets/images/transactionLoading.png',fit: BoxFit.contain,filterQuality : FilterQuality.low),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
String formatBalance(String balance) {
  if (balance.length <= 6) return balance;
  return '${balance.substring(0, 8)}...';
}
