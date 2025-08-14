import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/application/presentation/viewmodel/wallet_view_model.dart';
import 'package:provider/provider.dart';

class WalletAppInitializer extends StatefulWidget {
  final Widget child;

  const WalletAppInitializer({super.key, required this.child});

  @override
  State<WalletAppInitializer> createState() => _WalletAppInitializerState();
}

class _WalletAppInitializerState extends State<WalletAppInitializer> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_)async {
      final walletVM = Provider.of<WalletViewModel>(context, listen: false);
      walletVM.setupLifecycleObserver();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
