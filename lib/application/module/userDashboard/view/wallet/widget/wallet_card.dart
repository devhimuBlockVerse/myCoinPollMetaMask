import 'package:flutter/material.dart';
 import 'package:flutter_svg/svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/wallet/widget/add_funs.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/wallet/widget/with_draw.dart';
import 'package:mycoinpoll_metamask/application/presentation/viewmodel/wallet_view_model.dart';
import 'package:provider/provider.dart';

import '../../../../../../framework/utils/dynamicFontSize.dart';
 import '../../../../../../framework/utils/general_utls.dart';
import '../../../../../presentation/viewmodel/bottom_nav_provider.dart';
 import 'transfer.dart';


class WalletCard extends StatelessWidget {

  // final List<String> _labels = ['With Draw', 'Transfer', 'Scan', 'Gift'];
  final List<String> _labels = ['With Draw', 'Transfer', 'Scan'];
  final List<String> _imgPaths = [
    'assets/icons/withDraw.svg',
    'assets/icons/transfer.svg',
    'assets/icons/scan.svg',
    'assets/icons/gift.svg',
  ];

  final List<Widget> _pages = [
    const WithDraw(),
    const Transfer(),
     // const TransactionDetailsDialog(),
    // const TransactionDetailsDialog(),
   ];
  
  

  @override
  Widget build(BuildContext context) {
    final currentIndex = Provider.of<BottomNavProvider>(context).currentIndex;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<WalletViewModel>(
            builder: (context, model, _) {

              return Container(
            width: screenWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/icons/walletCardBg.png'),
                fit: BoxFit.fill,
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.03, // Original was 24
              horizontal: screenWidth * 0.05,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /// Wallet Info and Growth
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /// Wallet Info
                          Expanded(
                            // flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  textAlign: TextAlign.start,
                                  'Total Wallet Balance:',
                                  style: TextStyle(
                                    color: Color(0xCCFFF5ED),
                                    fontFamily: 'Poppins',
                                    fontSize: getResponsiveFontSize(context, 12),
                                    fontWeight: FontWeight.w400,
                                    height: 1.3,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.006), // Original was 5

                                   Text(
                                    // '\$ 10,1542.0000000000000000',
                                     '\$${model.balance}',
                                    style: TextStyle(
                                        color: Color(0xffFFF5ED),
                                        fontFamily: 'Poppins',
                                        fontSize: getResponsiveFontSize(context, 18),
                                        fontWeight: FontWeight.w500,
                                        height: 1.3,
                                        overflow: TextOverflow.ellipsis
                                    ),
                                  ),

                              ],
                            ),
                          ),

                          /// Growth %
                          Flexible(
                            // flex: 1,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.01,
                                vertical: screenHeight * 0.003,
                              ),
                              margin: EdgeInsets.only(left: screenWidth * 0.001), // Add margin to separate from wallet info
                              decoration: BoxDecoration(
                                color: const Color(0x1915FF10),
                                borderRadius: BorderRadius.circular(screenWidth * 0.06),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_drop_up_sharp, color: Color(0xFF37CAB0), size: screenWidth * 0.05), // Original was 24
                                  Text(
                                    '+0.8%',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Color(0xff37CBB0),
                                      fontFamily: 'Poppins',
                                      fontSize: getResponsiveFontSize(context, 12),
                                      fontWeight: FontWeight.w500,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Add Funds
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) =>const AddFunds(),

                        );
                        debugPrint("Add Funds");
                      },
                      child: Column(
                        children: [
                          Container(
                            width: screenWidth * 0.08,
                            height: screenWidth * 0.08,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/icons/addFundsBg.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/icons/addIcon.svg",
                                width: screenWidth * 0.048,
                                height: screenWidth * 0.048,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.0075),
                          Text(
                            'Add Funds',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: getResponsiveFontSize(context, 12),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.010),

                /// Balance Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    /// Available Funds
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available Funds :',
                          style: TextStyle(
                            color: Color(0xffFFF5ED).withOpacity(0.80),
                            fontFamily: 'Poppins',
                            fontSize: getResponsiveFontSize(context, 12),
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.0075),
                        Text(
                          '\$ 1541.00',
                          style: TextStyle(
                            color: Color(0xffFFF5ED),
                            fontFamily: 'Poppins',
                            fontSize: getResponsiveFontSize(context, 18),
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),

                    /// Coins
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/BTC.png',
                              width: screenWidth * 0.053,
                              height: screenWidth * 0.053,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: screenWidth * 0.013) ,
                            Text(
                              '1.25 BTC',
                              style: TextStyle(
                                color: Color(0xffFFF5ED),
                                fontFamily: 'Poppins',
                                fontSize: getResponsiveFontSize(context, 14),
                                fontWeight: FontWeight.w500,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(width: screenWidth * 0.042), // Original was 16

                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/EthCoin.png',
                              width: screenWidth * 0.053,
                              height: screenWidth * 0.053,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: screenWidth * 0.013),
                            Text(
                              '265.0 ETH',
                              style: TextStyle(
                                color: Color(0xffFFF5ED),
                                fontFamily: 'Poppins',
                                fontSize: getResponsiveFontSize(context, 14),
                                fontWeight: FontWeight.w500,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                /// Divider
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.9,
                    child: Divider(
                      color: Colors.white12,
                      thickness: screenHeight * 0.0025,
                      height: screenHeight * 0.025,
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.008),
                /// Action Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_labels.length, (index) {
                    return InkWell(
                      onTap: () {
                        if(_labels[index] == 'Scan'){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const QRScanScreen()),
                          );
                        }else{
                          showDialog(
                            context: context,
                            builder: (context) => _pages[index],
                          );
                        }
                        print('Tapped ${_labels[index]}');
                        // Provider.of<BottomNavProvider>(context, listen: false).setIndex(index);
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            _imgPaths[index],
                            color: Colors.white,
                            width: screenWidth * 0.059,
                            height: screenWidth * 0.059,
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Text(
                            _labels[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: getResponsiveFontSize(context, 12),
                              fontWeight: FontWeight.w400,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
    }
        ),
      ],
    );
  }




}



class QRScanScreen extends StatelessWidget {
  const QRScanScreen({super.key});

  void _handleScannedValue(BuildContext context, String value) {
    // Example: Check if it's a wallet address
    debugPrint('Scanned: $value');

    // Ask user what to do
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Action Required"),
        content: Text("QR Scanned: $value\n\nChoose what to do:"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              showDialog(context: context, builder: (_) => const WithDraw());
            },
            child: const Text("Withdraw"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showDialog(context: context, builder: (_) => const Transfer());
            },
            child: const Text("Transfer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Web3QrScanner(
      onScanned: (value) => _handleScannedValue(context, value),
    );
  }
}


class Web3QrScanner extends StatelessWidget {
  final void Function(String scannedValue) onScanned;

  const Web3QrScanner({super.key, required this.onScanned});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.black,
      ),
      body: MobileScanner(
        fit: BoxFit.cover,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final String? value = barcode.rawValue;
            if (value != null) {
              onScanned(value);
              Navigator.pop(context); // Close scanner
              break;
            }
          }
        },
      ),
    );
  }
}
