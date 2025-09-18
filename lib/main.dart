import 'dart:async';
 import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
 import 'package:mycoinpoll_metamask/application/module/userDashboard/viewmodel/dashboard_nav_provider.dart';
import 'package:mycoinpoll_metamask/connectivity/dependency_injection.dart';
import 'package:mycoinpoll_metamask/firebase_service/AnalyticsService.dart';
import 'package:mycoinpoll_metamask/framework/utils/customToastMessage.dart';
import 'package:mycoinpoll_metamask/permission_handler_widget.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
 import 'application/presentation/screens/settings/feedback_screen.dart';
import 'application/presentation/screens/splash/splash_view.dart';
import 'application/presentation/viewmodel/bottom_nav_provider.dart';
import 'application/presentation/viewmodel/countdown_provider.dart';
import 'application/presentation/viewmodel/personal_information_viewmodel/personal_view_model.dart';
import 'application/module/userDashboard/viewmodel/side_navigation_provider.dart';
import 'application/presentation/viewmodel/user_auth_provider.dart';
import 'application/presentation/viewmodel/walletAppInitializer.dart';
import 'application/presentation/viewmodel/wallet_view_model.dart';
import 'package:flutter/foundation.dart';


import 'connectivity/connectivity_controller.dart';
import 'connectivity/no internet.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
final GlobalKey<NavigatorState> contextNavigatorKey = GlobalKey<NavigatorState>();

/// logRocket
Future <void> main() async   {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(AnalyticsService()..initialize());

  FlutterError.onError = (errorDetails){
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    Get.find<AnalyticsService>().logCrash(
      error: errorDetails.exception,
      stackTrace: errorDetails.stack ?? StackTrace.current,
      context: 'FlutterError',
    );
  };

  PlatformDispatcher.instance.onError = (error, stack){
    FirebaseCrashlytics.instance.recordError(error, stack);
    Get.find<AnalyticsService>().logCrash(
      error: error,
      stackTrace: stack,
      context: 'PlatformError',
    );
    return true;
  };

  // HttpOverrides.global = MyHttpOverrides();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

  Get.put(NetworkController());
  DependencyInjection.init();


  runApp(const MyApp());

}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final NetworkController networkController = Get.find<NetworkController>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserAuthProvider()..loadUserFromPrefs()),
        ChangeNotifierProvider(create: (context) => WalletViewModel(),),
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
        ChangeNotifierProvider(create: (_) => DashboardNavProvider()),
        ChangeNotifierProvider(create: (_) => PersonalViewModel()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => FeedbackViewModel()),

        ChangeNotifierProvider( create: (_) => CountdownTimerProvider(
          targetDateTime: DateTime.now(),
        ),),

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
            FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
          ],
          builder: (context, child) {
            final Widget appContent = WalletAppInitializer(child: child!);
            return  Obx((){

              return Stack(
                children: [
                  appContent,
                  if (networkController.isOfflineOverlayVisible.value)
                    const NoInternetOverlay(),
                ],
              );
            });
          }
      ),
    );
  }
}