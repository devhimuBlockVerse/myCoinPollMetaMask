import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/viewmodel/dashboard_nav_provider.dart';
import 'package:provider/provider.dart';

import 'application/module/dashboard_bottom_nav.dart';
import 'application/module/userDashboard/viewmodel/kyc_navigation_provider.dart';
import 'application/module/userDashboard/viewmodel/upload_image_provider.dart';
import 'application/presentation/screens/bottom_nav_bar.dart';
import 'application/presentation/screens/wallet_login_screen.dart';
import 'application/presentation/under_maintenance.dart';
import 'application/presentation/viewmodel/bottom_nav_provider.dart';
import 'application/presentation/viewmodel/countdown_provider.dart';
import 'application/presentation/viewmodel/personal_information_viewmodel/personal_view_model.dart';
import 'application/module/userDashboard/viewmodel/side_navigation_provider.dart';
import 'application/presentation/viewmodel/walletAppInitializer.dart';
import 'application/presentation/viewmodel/wallet_view_model.dart';
import 'framework/utils/routes/route_names.dart';
import 'framework/utils/routes/routes.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final kycProvider = KycNavigationProvider();
  await kycProvider.loadLastVisitedScreen();

  // Force portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Force edge-to-edge UI
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Set system bar style globally (transparent + white icons)
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

   runApp(
       const MyApp(),
     // DevicePreview(
     //   enabled: !kReleaseMode,
     //   builder: (context) => MyApp(), // Wrap your app
     // ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WalletViewModel(),),
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
        ChangeNotifierProvider(create: (_) => DashboardNavProvider()),
        ChangeNotifierProvider(create: (_) => PersonalViewModel()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => KycNavigationProvider()),
        ChangeNotifierProvider(create: (_) => UploadProvider()),
        ChangeNotifierProvider( create: (_) => CountdownTimerProvider(
          targetDateTime: DateTime.now().add(const Duration(days: 2, hours: 23, minutes: 5, seconds: 56)),
        ),),

      ],


      child: WalletAppInitializer(
        child: MaterialApp(
          // useInheritedMediaQuery: true,
          // locale: DevicePreview.locale(context),
          // builder: DevicePreview.appBuilder,
          title: 'MyCoinPoll',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            useMaterial3: true,
          ),
           home:  const BottomNavBar(),
          navigatorObservers: [routeObserver],
        
          // home: const UnderMaintenance(),
          // onGenerateRoute: Routes.generateRoute,
          // initialRoute: RoutesName.walletLogin,
        
        
        ),
      ),
    );
  }
}


