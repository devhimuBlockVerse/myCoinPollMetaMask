import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'application/presentation/screens/bottom_nav_bar.dart';
import 'application/presentation/viewmodel/bottom_nav_provider.dart';
import 'application/presentation/viewmodel/personal_information_viewmodel/personal_view_model.dart';
import 'application/presentation/viewmodel/wallet_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Force portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Force edge-to-edge UI
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Set system bar style globally (transparent + white icons)
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
   runApp(
    const MyApp(),
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
        ChangeNotifierProvider(create: (_) => PersonalViewModel()),

      ],

      child: MaterialApp(
        title: 'Reown AppKit Wallet',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        // home:  FeaturesScreen(),
        home:  BottomNavBar(),
        // onGenerateRoute: Routes.generateRoute,
        // initialRoute: RoutesName.walletLogin,


      ),
    );
  }
}


