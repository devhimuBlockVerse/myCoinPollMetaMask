import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/wallet_login_screen.dart';
import 'package:mycoinpoll_metamask/framework/utils/routes/route_names.dart';

import '../../../application/presentation/screens/dashboard.dart';
import '../../../application/presentation/screens/digital_model_screen.dart';
import '../../../application/presentation/screens/ecm_staking_screen.dart';


class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.walletLogin:
        return MaterialPageRoute(
          builder: (BuildContext context) => const WalletLoginScreen(),);


      case RoutesName.dashboard:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DashboardView(),);


      case RoutesName.digitalModel:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DigitalModelScreen());

      case RoutesName.ecmStaking:
        return MaterialPageRoute(
            builder: (BuildContext context) => const EcmStakingScreen());


      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No Route Defined'),
            ),
          );
        });
    }
  }
}