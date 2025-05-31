import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../../../framework/res/colors.dart';
import '../../../../../domain/model/PurchaseLogModel.dart';


class PurchaseCard extends StatelessWidget {
  final PurchaseLogModel transaction;

  const PurchaseCard({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final DateFormat formatter = DateFormat('d MMMM yyyy');
    String formattedDate = formatter.format(transaction.date);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: ECM Coins | Ref: Jane Cooper
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: AppColors.accentOrange.withOpacity(0.2), // Lighter orange background
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: AppColors.accentOrange, width: 1.0),
                    ),
                    child: Icon(Icons.currency_bitcoin, color: AppColors.accentOrange, size: 24),
                    // Or an Image.asset for a custom logo
                    // child: Image.asset('assets/ecm_logo.png', width: 24, height: 24),
                  ),
                  const SizedBox(width: 12.0),
                  Text(
                    transaction.coinName,
                    style: const TextStyle(
                      color: AppColors.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.link, color: AppColors.lightTextColor, size: 18),
                  const SizedBox(width: 4.0),
                  Text(
                    'Ref: ${transaction.refName}',
                    style: const TextStyle(
                      color: AppColors.lightTextColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Date Row
              Row(
                children: [
                  Icon(Icons.calendar_today, color: AppColors.lightTextColor, size: 16),
                  const SizedBox(width: 8.0),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      color: AppColors.lightTextColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0), // More space before contract details

              // Contract Details
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3, // Give more space to the left column
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Contract Name',
                          style: TextStyle(
                            color: AppColors.lightTextColor,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          transaction.contractName,
                          style: const TextStyle(
                            color: AppColors.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          'Name of Sender',
                          style: TextStyle(
                            color: AppColors.lightTextColor,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          transaction.senderName,
                          style: const TextStyle(
                            color: AppColors.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2, // Give less space to the right column
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end, // Align right
                      children: [
                        const Text(
                          'ECM Amount',
                          style: TextStyle(
                            color: AppColors.lightTextColor,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          '${transaction.ecmAmount.toStringAsFixed(2)} ECM',
                          style: const TextStyle(
                            color: AppColors.accentGreen,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0), // Space before hash

              // Hash Section
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Hash: ${transaction.hash}',
                      style: const TextStyle(
                        color: AppColors.lightTextColor,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis, // Prevent text from overflowing
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: transaction.hash));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Hash copied to clipboard!')),
                      );
                    },
                    child: Icon(Icons.copy_all, color: AppColors.lightTextColor, size: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
