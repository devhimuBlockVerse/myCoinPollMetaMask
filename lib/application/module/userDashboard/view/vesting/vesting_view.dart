import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/vesting/start_vesting_view.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/vesting/vesting_Item.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/components/VestingContainer.dart';
import '../../../../data/services/api_service.dart';
import '../../../../presentation/viewmodel/user_auth_provider.dart';
import '../../../../presentation/viewmodel/wallet_view_model.dart';
import '../../../side_nav_bar.dart';
import '../../viewmodel/dashboard_nav_provider.dart';
import '../../viewmodel/side_navigation_provider.dart';



// class VestingWrapper extends StatelessWidget {
//   const VestingWrapper({super.key});
//
//   Future<bool> _checkWalletConnected(BuildContext context) async {
//     final walletVM = Provider.of<WalletViewModel>(context, listen: false);
//
//     try {
//       // Ensure wallet is hydrated
//       await walletVM.rehydrate();
//
//       // If no wallet address, show modal
//       if (walletVM.walletAddress == null || walletVM.walletAddress!.isEmpty) {
//         await walletVM.ensureModalWithValidContext(context);
//         await walletVM.appKitModal?.openModalView();
//         return false; // not connected yet
//       }
//
//       return true; // wallet connected
//     } catch (e) {
//       debugPrint("Wallet check failed: $e");
//       await walletVM.ensureModalWithValidContext(context);
//       return false;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<bool>(
//       future: _checkWalletConnected(context),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//
//         if (snapshot.data == false) {
//           final walletVM = Provider.of<WalletViewModel>(context, listen: false);
//           walletVM.ensureModalWithValidContext(context);
//         }
//
//         // If wallet connected → check balance normally
//         return FutureBuilder<String>(
//           future: BalanceService.resolveBalance(context),
//           builder: (context, balanceSnapshot) {
//             if (balanceSnapshot.connectionState == ConnectionState.waiting) {
//               return const Scaffold(
//                 body: Center(child: CircularProgressIndicator()),
//               );
//             }
//
//             final balance = balanceSnapshot.data ?? '0';
//             final hasBalance = double.tryParse(balance) != null && double.parse(balance) > 0;
//
//             return hasBalance ? const StartVestingView() : const VestingView();
//           },
//         );
//       },
//     );
//   }
// }

// class VestingWrapper extends StatelessWidget {
//   const VestingWrapper({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<WalletViewModel>(
//       builder: (context, walletVM, child) {
//
//         debugPrint('--- VestingWrapper Debugging Info ---');
//         debugPrint('isLoading: ${walletVM.isLoading}');
//         debugPrint('walletAddress: ${walletVM.walletAddress}');
//         debugPrint('vestingAddress: ${walletVM.vestingAddress}');
//         debugPrint('vestinginfo: ${walletVM.vestInfo}');
//         debugPrint('--- End of Debugging Info ---');
//
//          if (walletVM.isLoading) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//
//          if (walletVM.walletAddress == null || walletVM.walletAddress!.isEmpty) {
//           return const Scaffold(
//             body: Center(
//               child: Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Text(
//                   "Please connect your wallet to view vesting details.",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.white70),
//                 ),
//               ),
//             ),
//           );
//         }
//          if (walletVM.vestingAddress != null && walletVM.vestingAddress!.isNotEmpty) {
//           return const StartVestingView();
//          } else {
//            return const VestingView();
//          }
//       },
//     );
//   }
// }



class VestingWrapper extends StatelessWidget {
  const VestingWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletViewModel>(
      builder: (context, walletVM, child) {

        // --- Only print the debug information and return an empty container ---
        debugPrint('--- VestingWrapper Debugging Info ---');
        debugPrint('isLoading: ${walletVM.isLoading}');
        debugPrint('walletAddress: ${walletVM.walletAddress}');
        debugPrint('vestingAddress: ${walletVM.vestingAddress}');
         debugPrint('--- End of Debugging Info ---');

        if (walletVM.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (walletVM.walletAddress == null || walletVM.walletAddress!.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Please connect your wallet to view vesting details.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: Text(
              "Debugging... check console for logs.",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );




 /*
        if (walletVM.vestingAddress != null && walletVM.vestingAddress!.isNotEmpty) {
          return const StartVestingView();
        } else {
          return const VestingView();
        }
        */
      },
    );
  }
}

class VestingView extends StatefulWidget {
  const VestingView({super.key});

  @override
  State<VestingView> createState() => _VestingViewState();
}


class _VestingViewState extends State<VestingView> {



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final navProvider = Provider.of<NavigationProvider>(context);
    final currentScreenId = navProvider.currentScreenId;
    final navItems = navProvider.drawerNavItems;

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final walletVM = Provider.of<WalletViewModel>(context, listen: false);



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
                      'ECM Vesting',
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
                          onRefresh: () async {},
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),


                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                buyECMHeader(screenHeight, screenWidth, context ,walletVM),

                                SizedBox(height: screenHeight * 0.02),

                                whyVesting(screenHeight, screenWidth, context)

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

  Widget buyECMHeader(screenHeight, screenWidth, context , WalletViewModel walletVm){
    return VestingContainer(
      width: screenWidth * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          SizedBox(height: screenHeight * 0.02),

          Text(
            'You haven’t purchased \n ECM yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0XFFFFF5ED),
              fontSize: getResponsiveFontSize(context, 22),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),


          SizedBox(height: screenHeight * 0.02),

          BlockButton(
            height: screenHeight * 0.05,
            width: screenWidth * 0.8,
            label: 'BUY ECM NOW',
            textStyle:  TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: getResponsiveFontSize(context, 14),
              height: 1.6,
            ),
            gradientColors: const [
              Color(0xFF2680EF),
              Color(0xFF1CD494)
            ],
            onTap: () {
              Provider.of<DashboardNavProvider>(context, listen: false).setIndex(1);
            },
            iconPath: 'assets/icons/arrowIcon.svg',
            iconSize : screenHeight * 0.013,
          ),
          SizedBox(height: screenHeight * 0.02),

        ],
      ),
    );

  }

  Widget whyVesting(screenHeight, screenWidth, context){
    final vestingData = [
      {
        "image": "assets/images/vestingImg1.png",
        "text": "Ensures a healthy token economy and reduces market dumps."
      },
      {
        "image": "assets/images/moneyVesting.png",
        "text": "Builds investor trust and shows project commitment"
      },
      {
        "image": "assets/images/vestingImg2.png",
        "text": "Offers bonus rewards or reduced transaction fees."
      },
      {
        "image": "assets/images/vestingImg3.png",
        "text": "Prevents oversupply and maintains token value."
      },
      {
        "image": "assets/images/vestingImg5.png",
        "text": "Encourages long-term investors and ecosystem strength."
      },
      {
        "image": "assets/images/moneyVesting.png",
        "text": "Provides priority in launches, airdrops, or governance."
      },
    ];

    return VestingContainer(
      width: screenWidth * 0.9,
      borderColor: const Color(0XFF2C2E41),
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why vesting?',
            style: TextStyle(
              color: Color(0XFFFFF5ED),
              fontSize: getResponsiveFontSize(context, 16),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: screenHeight * 0.02),
          
          ...vestingData.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: VestingItem(
              imagePath: item['image']!,
              text: item['text']!,
              height: screenHeight,
            ),
          )),

        ],
      ),
    );
  }

}


