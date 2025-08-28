import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../framework/components/transactionDetailsComponent.dart';

class TransactionDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> data;

const TransactionDetailsDialog({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/dialogFrame.png',
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.09),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: screenHeight * 0.85,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Transactions Details',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: screenWidth * 0.06,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            // '\$ 100000.00',
                            'ECM ${data['Amount'] ?? '0.00'}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * 0.08,
                              color: const Color(0xff1CD494),
                              height: 1.6,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),

                          TransactionDetails(
                            label: 'Time/Date',
                            // value: '07/10/2024; 09:30 PM',
                            value: data['DateTime'] ?? '',

                          ),
                            TransactionDetails(
                            label: 'Block',
                            // value: '20969235',
                            value: data['Block'] ?? 'N/A',

                          ),
                           TransactionDetails(
                            label: 'Status',
                            value: '',
                            // status: 'In',
                            status: data['Status'] ?? '',

                          ),

                          SizedBox(height: screenHeight * 0.03),

                           TransactionDetails(
                            label: 'Txn Hash',
                            // value: '0xac6d8ae0a1dcX',
                            value: data['TxnHash'] ?? '',

                            svgIconPath: 'assets/icons/copyImg.svg',
                          ),
                           TransactionDetails(
                            label: 'From',
                            // value: '0xaFODFEC80xaFOFODFEODCaFC8',
                            value: data['From'] ?? '',
                            svgIconPath: 'assets/icons/copyImg.svg',
                          ),
                           TransactionDetails(
                            label: 'To',
                            // value: '0xaFODFEC80xaFOFODFEODCaFC8',
                            value: data['To'] ?? '',

                            svgIconPath: 'assets/icons/copyImg.svg',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


String formatHash(String hash, {int start = 6, int end = 6}) {
  if (hash.length <= start + end) return hash;
  return '${hash.substring(0, start)}...${hash.substring(hash.length - end)}';
}



