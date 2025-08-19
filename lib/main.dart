import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/viewmodel/dashboard_nav_provider.dart';
import 'package:mycoinpoll_metamask/framework/utils/customToastMessage.dart';
import 'package:provider/provider.dart';
 import 'application/presentation/screens/bottom_nav_bar.dart';
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

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
final GlobalKey<NavigatorState> contextNavigatorKey = GlobalKey<NavigatorState>();

void main() async   {

  WidgetsFlutterBinding.ensureInitialized();


  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

   runApp(const MyApp(),);
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

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
          targetDateTime: DateTime.now().add(const Duration(days: 2, hours: 23, minutes: 5, seconds: 56)),
        ),),

      ],

      child: MaterialApp(
        navigatorKey: ToastMessage.toastContextNavigatorKey,
        useInheritedMediaQuery: true,
        title: 'MyCoinPoll',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(backgroundColor: Colors.grey[900]),
        ),
        // home:  const BottomNavBar(),

        // home: const BottomNavBar(),
        home: const SplashView(),
        navigatorObservers: [routeObserver],
        builder: (context, child) => WalletAppInitializer(child: child!),


      ),
    );
  }
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }  +
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => UserAuthProvider()..loadUserFromPrefs()),
//         ChangeNotifierProvider(create: (context) => WalletViewModel(),),
//         ChangeNotifierProvider(create: (_) => BottomNavProvider()),
//         ChangeNotifierProvider(create: (_) => DashboardNavProvider()),
//         ChangeNotifierProvider(create: (_) => PersonalViewModel()),
//         ChangeNotifierProvider(create: (_) => NavigationProvider()),
//          ChangeNotifierProvider( create: (_) => CountdownTimerProvider(
//           targetDateTime: DateTime.now().add(const Duration(days: 2, hours: 23, minutes: 5, seconds: 56)),
//         ),),
//
//       ],
//
//
//       child: WalletAppInitializer(
//         child: MaterialApp(
//           navigatorKey: ToastMessage.toastContextNavigatorKey,
//           useInheritedMediaQuery: true,
//
//           title: 'MyCoinPoll',
//           debugShowCheckedModeBanner: false,
//           theme: ThemeData(
//             colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
//             useMaterial3: true,
//           ),
//            home:  const BottomNavBar(),
//           navigatorObservers: [routeObserver],
//
//
//         ),
//       ),
//     );
//   }
// }


