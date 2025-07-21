import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/home/apply_for_listing_screen.dart';
import 'package:mycoinpoll_metamask/framework/utils/routes/route_names.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case RoutesName.applyForListing:
            return MaterialPageRoute(
                builder: (BuildContext context) =>  const ApplyForListingScreen());


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