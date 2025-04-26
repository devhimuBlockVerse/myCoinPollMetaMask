import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/framework/utils/routes/route_names.dart';
import 'package:provider/provider.dart';

import '../viewmodel/wallet_view_model.dart';
import 'dashboard.dart';

class WalletLoginScreen extends StatefulWidget {
  const WalletLoginScreen({super.key});

  @override
  State<WalletLoginScreen> createState() =>
      _WalletLoginScreenState();
}

class _WalletLoginScreenState
    extends State<WalletLoginScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WalletViewModel>(context, listen: false).init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF0A1C2F),
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: const Text(
            'Wallet Login',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Consumer<WalletViewModel>(
            builder: (context, model, _) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0x4d03080e),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF0A1C2F),
                  Color(0xFF060D13),
                ],
              ),
            ),
            child: SafeArea(

              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 80,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Connect your wallet',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Connect your Reown wallet to screens your balance',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: 240,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: model.isLoading ? null : () async {
                      try {
                        await model.connectWallet(context);
                        if (context.mounted && model.isConnected) {
                          Navigator.pushReplacementNamed(context, RoutesName.dashboard);
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Wallet not connected. Please try again.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }

                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Connection error: ${e.toString()}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: model.isLoading
                        ? const SizedBox(
                      width: 24, height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Text(
                      'Connect Wallet',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),),
          );

        }));
  }
}
