import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/framework/utils/general_utls.dart';
import 'package:provider/provider.dart';
import '../../../framework/utils/routes/route_names.dart';
import '../viewmodel/wallet_view_model.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() =>
      _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {



  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  bool _isloading = false;

  @override
  void dispose() {
     super.dispose();
      _recipientController.dispose();
    _amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {

     return WillPopScope(
      onWillPop: () async => false,
      child:   Scaffold(
          backgroundColor: Color(0xFF0A1C2F),
              appBar: AppBar(
                backgroundColor: Colors.black,
                elevation: 0,
                title: const Text(
                  'Wallet Dashboard',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                centerTitle: true,
              ),
              body:  Consumer<WalletViewModel>(builder: (context, model, _){
                if(model.isLoading){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
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
                    child:   SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 80,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Wallet Connected',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _formatAddress(model.walletAddress),
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'monospace',
                                    color: Colors.black
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),
                          SizedBox(
                            width: 240,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  final balance = await model.getBalance();
                                  final totalSupply = await model.getTotalSupply();

                                  if (context.mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        // title: const Text('Your Balance'),
                                        title: const Text('Wallet Information'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Your Balance:',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              balance,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            const Text(
                                              'Total Supply:',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              totalSupply,
                                              style: const TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Close'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error getting balance: ${e.toString()}'),
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
                              child: const Text(
                                'Show Balance',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),

                          ),

                          /// Transfer Token Section
                          const SizedBox(height: 16),
                          TextField(
                            controller: _recipientController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Recipient Address',
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(

                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,

                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Amount to Transfer',
                            ),
                          ),
                          const SizedBox(height: 16),

                          SizedBox(
                              width: 240,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isloading? null : ()async{
                                  final recipient = _recipientController.text;
                                  final amountText = _amountController.text;
                                  final amount = double.tryParse(amountText);

                                  if(recipient.isEmpty || amountText.isEmpty){
                                    Utils.showToast('Please fill out all fields', isError: true);

                                    return;
                                  }

                                  if (amount == null) {
                                    Utils.showToast('Please enter a valid amount', isError: true);

                                    return;
                                  }
                                  setState(() => _isloading = true);
                                  try{
                                    await model.transferToken(recipient, amount);
                                    Utils.showToast('Token transferred successfully!');
                                    _recipientController.clear();
                                    _amountController.clear();

                                  }catch(e){

                                    Utils.showToast('Error sending token: ${e.toString()}', isError: true);

                                    debugPrint("Error sending token: $e");

                                  }finally{
                                    if (mounted) setState(() => _isloading = false);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black12,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Transfer Token',
                                  style: TextStyle(fontSize: 18),
                                ),

                              )
                          ),



                          const SizedBox(height: 16),
                          SizedBox(
                            width: 240,
                            height: 56,
                            child: OutlinedButton(
                              onPressed: () async {
                                Navigator.pushNamed(context, RoutesName.digitalModel);
                                // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> DigitalModelScreen()));
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Go to Digital Wallet',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          SizedBox(
                            width: 240,
                            height: 56,
                            child: OutlinedButton(
                              onPressed: () async {
                                Navigator.pushNamed(context, RoutesName.ecmStaking);
                               },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.lightGreenAccent,
                                side: const BorderSide(color: Colors.lightGreenAccent),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'ECM Staking',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                );
          })
          ),
      );
  }


  String _formatAddress(String address) {
    if (address.length > 10) {
      return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
    }
    return address;
  }

}

