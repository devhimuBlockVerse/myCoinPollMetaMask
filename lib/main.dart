import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/viewmodel/dashboard_nav_provider.dart';
import 'package:mycoinpoll_metamask/connectivity/dependency_injection.dart';
import 'package:mycoinpoll_metamask/framework/utils/customToastMessage.dart';
import 'package:mycoinpoll_metamask/permission_handler_widget.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
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
  Get.put(NetworkController());
  DependencyInjection.init();

  await SentryFlutter.init((options){
    // options.dsn = 'https://af8713a9a33c2a23bc1f568ccc3351d7@o4509954481651712.ingest.us.sentry.io/4509954548170752';
    options.dsn = 'https://994937321cb0bcd4dc6db716db3246de@o4509961187360768.ingest.us.sentry.io/4509961188540416';

    options.sendDefaultPii = true;
    options.enableLogs = true;


    options.replay.sessionSampleRate = 0.0;
    options.replay.onErrorSampleRate = 0.0;

    options.tracesSampleRate = 0.0;
    options.profilesSampleRate = 0.0;

    options.autoInitializeNativeSdk  = false;
    options.captureFailedRequests = true;


    options.beforeSend = (SentryEvent event, Hint hint) async {
      final message = event.message?.formatted?.toLowerCase() ?? '';
      if (message.contains("api") || message.contains("http") || message.contains('source') ||  message.contains("wallet")) {
        return event;
      }
      return null;
    };

  },

  );

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


