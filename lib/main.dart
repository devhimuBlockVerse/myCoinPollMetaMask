import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logrocket_flutter/logrocket_flutter.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/viewmodel/dashboard_nav_provider.dart';
import 'package:mycoinpoll_metamask/connectivity/dependency_injection.dart';
import 'package:mycoinpoll_metamask/framework/utils/customToastMessage.dart';
import 'package:mycoinpoll_metamask/permission_handler_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'application/module/userDashboard/viewmodel/side_navigation_provider.dart';
import 'application/presentation/screens/settings/feedback_screen.dart';
import 'application/presentation/screens/splash/splash_view.dart';
import 'application/presentation/viewmodel/bottom_nav_provider.dart';
import 'application/presentation/viewmodel/countdown_provider.dart';
import 'application/presentation/viewmodel/personal_information_viewmodel/personal_view_model.dart';
import 'application/presentation/viewmodel/user_auth_provider.dart';
import 'application/presentation/viewmodel/walletAppInitializer.dart';
import 'application/presentation/viewmodel/wallet_view_model.dart';
import 'connectivity/connectivity_controller.dart';
import 'connectivity/no internet.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
final GlobalKey<NavigatorState> contextNavigatorKey =
    GlobalKey<NavigatorState>();

/// logRocket
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // HttpOverrides.global = MyHttpOverrides();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Get.put(NetworkController());
  DependencyInjection.init();

  final prefs = await SharedPreferences.getInstance();
  String? uniqueId = prefs.getString('unique_id');

  //. If not found, generate a temporary one
  if (uniqueId == null) {
    uniqueId = const Uuid().v4();
    await prefs.setString('unique_id', uniqueId);
  }

  // runApp(const MyApp());

  LogRocket.wrapAndInitialize(
      LogRocketWrapConfiguration(
        errorCaptureEnabled: true,
        logCaptureEnabled: true,
        networkCaptureEnabled: true,
        getSessionUrl: (sessionUrl) async {
          print("LogRocket Session URL: $sessionUrl");
          try {
            final prefs = await SharedPreferences.getInstance();
            await FirebaseAnalytics.instance.logEvent(
              name: 'logrocket',
              parameters: {
                'session_url': sessionUrl,
                'user_id': prefs.getString('unique_id') ?? 'unknown',
                'wallet_address': prefs.getString('walletAddress') ?? 'unknown',
                'username': prefs.getString('userName') ?? 'guest',
              },
            );
          } catch (e) {
            print(
                "Error sending LogRocket session URL to Firebase Analytics: $e");
          }
        },
      ),
      LogRocketInitConfiguration(
          // appID: 'blockverse/mycoinpoll',// DevHimu
          appID: 'shzrdl/mycoinpoll-app', // Hostinger
          logLevel: LogRocketInternalLogLevel.verbose,
          viewCaptureEnabled: true,
          screenshotPixelRatio: 1.0),
      () => runApp(LogRocketWidget(child: MyApp())));

  LogRocket.identify(uniqueId, {
    "walletAddress": prefs.getString('walletAddress') ?? 'unknown',
    "userName": prefs.getString('userName') ?? 'guest',
  });
}

Future<void> updateLogRocketUser(
    String userId, String walletAddress, String userName) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('unique_id', userId);
  await prefs.setString('walletAddress', walletAddress);
  await prefs.setString('userName', userName);

  LogRocket.identify(userId, {
    "walletAddress": walletAddress,
    "userName": userName,
  });

  print("🔗 LogRocket user updated: $userName | $walletAddress");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final NetworkController networkController = Get.find<NetworkController>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserAuthProvider()..loadUserFromPrefs()),
        ChangeNotifierProvider(
          create: (context) => WalletViewModel(),
        ),
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
        ChangeNotifierProvider(create: (_) => DashboardNavProvider()),
        ChangeNotifierProvider(create: (_) => PersonalViewModel()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => FeedbackViewModel()),
        ChangeNotifierProvider(
          create: (_) => CountdownTimerProvider(
            targetDateTime: DateTime.now(),
          ),
        ),
      ],
      child: GetMaterialApp(
          navigatorKey: ToastMessage.toastContextNavigatorKey,
          useInheritedMediaQuery: true,
          title: 'MyCoinPoll',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: AppBarTheme(backgroundColor: Colors.grey[900])),
          home: const PermissionHandlerWidget(child: SplashView()),
          navigatorObservers: [
            routeObserver,
          ],
          builder: (context, child) {
            final Widget appContent = WalletAppInitializer(child: child!);
            return Obx(() {
              if (networkController.isOfflineOverlayVisible.value) {
                LogRocket.track(LogRocketCustomEventBuilder('NETWORK_STATUS')
                  ..putString('status', 'offline')
                  ..putBool('isOfflineOverlayVisible', true));
              } else {
                LogRocket.track(LogRocketCustomEventBuilder('NETWORK_STATUS')
                  ..putString('status', 'online')
                  ..putBool('isOfflineOverlayVisible', false));
              }
              return Stack(
                children: [
                  appContent,
                  if (networkController.isOfflineOverlayVisible.value)
                    const NoInternetOverlay(),
                ],
              );
            });
          }),
    );
  }
}
