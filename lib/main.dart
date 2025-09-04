import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/viewmodel/dashboard_nav_provider.dart';
import 'package:mycoinpoll_metamask/connectivity/dependency_injection.dart';
import 'package:mycoinpoll_metamask/framework/utils/customToastMessage.dart';
import 'package:mycoinpoll_metamask/permission_handler_widget.dart';
import 'package:provider/provider.dart';
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
// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }
Future <void> main() async   {
  WidgetsFlutterBinding.ensureInitialized();

  // HttpOverrides.global = MyHttpOverrides();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);



  //permission for screen recording
  // FlutterUxConfig config = FlutterUxConfig(
  //     userAppKey: "o53qy1b6lzz62c6-us",
  //     enableAutomaticScreenNameTagging: false);
  //
  // FlutterUxcam.startWithConfiguration(config);
  // FlutterUxcam.optIntoSchematicRecordings();
  //
  // FlutterError.onError = (FlutterErrorDetails details){
  //   FlutterError.presentError(details);
  //   // Log to UXCam as a single string event
  //   FlutterUxcam.logEvent(
  //     "FlutterError: ${details.exception}\n"
  //         "Stack: ${details.stack}\n"
  //         "Library: ${details.library}",
  //   );
  //   debugPrint('FlutterError caught: ${details.exception}');
  // };
  // // Catch all Dart errors
  // runZonedGuarded(() {
  //   runApp(const MyApp());
  // }, (error, stackTrace) {
  //   FlutterUxcam.logEvent(
  //     "Uncaught App Exception: $error\nStack: $stackTrace",
  //   );
  //   debugPrint('Uncaught exception: $error');
  // });
   //

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
        // ChangeNotifierProvider(create: (_) => VestingStatusProvider()),

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
         navigatorObservers: [routeObserver,],
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


