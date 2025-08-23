import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../../framework/utils/status_styling_utils.dart';
import 'transaction_details.dart';

 Widget buildTransactionTable(List<Map<String, dynamic>> transactionData, double screenWidth, BuildContext context) {
  double baseSize = screenWidth * 0.9;
  double screenHeight = MediaQuery.of(context).size.height;
  const double designScreenWidth = 375.0;


  TextStyle headingStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
     fontSize: getResponsiveFontSize(context, 12),
    height: 1.6,
  );

  TextStyle cellTextStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: getResponsiveFontSize(context, 12),
    height: 1.6,
  );

  Widget buildCenteredText(String text, TextStyle style) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(text, style: style, textAlign: TextAlign.center,overflow: TextOverflow.visible,),
      ),
    );
  }

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.001),
    child: LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            height: screenHeight * 0.9,
            width: constraints.maxWidth * 1.8,
            child: DataTable2(

              dataRowHeight: screenHeight * 0.04,

              columnSpacing: screenWidth * 0.001,
              horizontalMargin: screenWidth * 0.002,
              headingRowHeight: screenHeight * 0.06,


              dividerThickness: 0,
              headingRowDecoration: const BoxDecoration(
                color: Color(0xff051121),
              ),

              columns: [
                DataColumn2(label: buildCenteredText('SL', headingStyle),
                    fixedWidth: screenWidth * (40.0 / designScreenWidth)),
                DataColumn2(label: buildCenteredText('Date Time', headingStyle), size: ColumnSize.L),
                DataColumn2(label: buildCenteredText('Txn Hash', headingStyle), size: ColumnSize.L),
                DataColumn2(label: buildCenteredText('Status', headingStyle),
                    size: ColumnSize.M

                ),
                DataColumn2(label: buildCenteredText('Amount', headingStyle),
                    size: ColumnSize.S
                 ),
                DataColumn2(label: buildCenteredText('Details', headingStyle),
                    // size: ColumnSize.L

                    fixedWidth: screenWidth * (40.0 / designScreenWidth)
                ),
              ],
              rows: transactionData.asMap().entries.map((entry) {
                int idx = entry.key;
                Map<String, dynamic> data = entry.value;
                final statusText = data['Status'] ?? '';
                final statusStyle = getTransactionStatusStyling(statusText);

                return DataRow2(

                  cells: [
                    DataCell(buildCenteredText(data['SL'] ?? '', cellTextStyle)),
                    DataCell(buildCenteredText(data['DateTime'] ?? '', cellTextStyle)),
                    DataCell(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: buildCenteredText(data['TxnHash'] ?? '', cellTextStyle),
                          ),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: data['TxnHash']));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('TxnHash copied to clipboard'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 1.0),
                              child: SvgPicture.asset(
                                'assets/icons/copyImg.svg',
                                height: getResponsiveFontSize(context, 10),
                                width: getResponsiveFontSize(context, 10),
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    DataCell(
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: getResponsiveFontSize(context, 8),
                            vertical: getResponsiveFontSize(context, 4),
                          ),
                          decoration: BoxDecoration(
                            color: statusStyle.backgroundColor,
                            border: Border.all(color: statusStyle.borderColor, width: 0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            statusText,
                            style: cellTextStyle.copyWith(color: statusStyle.textColor, fontSize: getResponsiveFontSize(context, 11)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),

                    DataCell(buildCenteredText(data['Amount'] ?? '', cellTextStyle)),

                    DataCell(
                      Center(
                        child: IconButton(
                          icon: Icon(Icons.visibility_outlined, color: const Color(0xFF7EE4C2), size: getResponsiveFontSize(context, 18)),
                          onPressed: () {

                            showDialog(
                              context: context,
                              builder: (_) => TransactionDetailsDialog(data: data,),
                             );
                            // Handle view details action
                            print('View details for ${data['TxnHash']}');
                          },
                          tooltip: 'View Details',
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
              empty: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'No matching transactions found.',
                    style: TextStyle(color: Colors.white70, fontSize: getResponsiveFontSize(context, 14)),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
