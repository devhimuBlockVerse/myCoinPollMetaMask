import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mycoinpoll_metamask/framework/utils/routes/route_names.dart';
import 'package:provider/provider.dart';

import 'application/presentation/screens/dashboard.dart';
import 'application/presentation/viewmodel/wallet_view_model.dart';
import 'framework/res/colors.dart';
import 'framework/utils/routes/routes.dart';




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
        ChangeNotifierProvider(create: (context) => WalletViewModel(),)
      ],

      child: MaterialApp(
        title: 'Reown AppKit Wallet',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        // home: const DashboardView(),
        // home:  DigitalModelScreen(),
        onGenerateRoute: Routes.generateRoute,
        initialRoute: RoutesName.walletLogin,

      ),
    );
  }
}


