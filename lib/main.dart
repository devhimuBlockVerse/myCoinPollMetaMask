import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:mycoinpoll_metamask/view/dashboard.dart';
import 'package:mycoinpoll_metamask/view/digital_model_screen.dart';
 import 'package:reown_walletkit/reown_walletkit.dart';
import 'dart:ui';
import '../viewmodel/wallet_view_model.dart';


import 'components/buttonComponent.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        ChangeNotifierProvider(create: (_) => WalletViewModel(),)
      ],

      child: MaterialApp(
        title: 'Reown AppKit Wallet',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        home: const DashboardView(),
        // home:  DigitalModelScreen(),
       ),
    );
  }
}


