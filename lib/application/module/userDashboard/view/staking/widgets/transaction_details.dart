import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class TransactionDetailsDialog extends StatelessWidget {
  const TransactionDetailsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xff101A29),
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xff040C16),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transactions Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white),
                )
              ],
            ),
            const SizedBox(height: 16),
            // Grid Fields
            Wrap(
              runSpacing: 12,
              spacing: 12,
              children: [
                _infoBox(Icons.confirmation_number, '# Serial Number', '01'),
                _infoBox(Icons.account_balance_wallet_outlined, 'Status', '',
                    child: _statusBox('IN')),
                _infoBox(Icons.access_time, 'Time/ Date', '2 hrs ago'),
                _infoBox(Icons.block, 'Block', '20969235'),
              ],
            ),
            const SizedBox(height: 12),
            // Full-width Fields
            _fullWidthBox(Icons.compare_arrows, 'Txn Hash', '0xac6d8ae0a1dcX'),
            _fullWidthBox(Icons.arrow_outward, 'From',
                '0xaFODFEC80xaFODFEC80xaFODFEODCaFC8'),
            _fullWidthBox(Icons.arrow_downward, 'To',
                '0xaFODFEC80xaFODFEC80xaFODFC80xaFC8'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _infoBox(Icons.swap_horiz, 'Method', 'Transfer'),
                _infoBox(Icons.attach_money, 'Amount', '\$ 10000000.00',
                    isGreen: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBox(IconData icon, String label, String value,
      {Widget? child, bool isGreen = false}) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff040C16),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff7D8FA9), width: 1),
      ),
      child: child ??
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(label,
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  color: isGreen ? Colors.greenAccent : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
    );
  }

  Widget _fullWidthBox(IconData icon, String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff040C16),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff7D8FA9), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(label,
                  style: const TextStyle(
                      color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 16, color: Colors.grey),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: value));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.greenAccent),
        borderRadius: BorderRadius.circular(6),
        color: Colors.green.shade900,
      ),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.greenAccent,
            fontWeight: FontWeight.bold,
            fontSize: 13),
      ),
    );
  }
}
