import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../../../../../framework/utils/dynamicFontSize.dart';

Widget referralSalesTable(List<Map<String, dynamic>> referralSalesData, double screenWidth, BuildContext context) {

  double screenHeight = MediaQuery.of(context).size.height;
  const double designScreenWidth = 375.0;
  const double designScreenHeight = 812.0;

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
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 4.0),
      // padding: EdgeInsets.symmetric(horizontal: screenWidth * (4.0 / designScreenWidth)),

      child: Center(
        child: FittedBox(
            alignment: Alignment.center,
          child: Text(text, style: style, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }



  return Padding(
    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
    child: LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            height: screenHeight * 0.4,
            width: constraints.maxWidth,
            child: DataTable2(
               columnSpacing: screenWidth * (10.0 / designScreenWidth),

              horizontalMargin: 0.0,
               dataRowHeight: screenHeight * 0.04,

              headingRowHeight: screenHeight * 0.04,
              dividerThickness: 0,

              headingRowDecoration: const BoxDecoration(
                color: Color(0xff051121),
              ),
               columns: [
                DataColumn2(
                  label: buildCenteredText('SL', headingStyle),
                   fixedWidth: screenWidth * (40.0 / designScreenWidth),

                ),
                DataColumn2(
                  label: buildCenteredText('Name', headingStyle),
                     fixedWidth: screenWidth * (120.0 / designScreenWidth),
                    headingRowAlignment: MainAxisAlignment.center
                ),
                DataColumn2(
                  label: buildCenteredText('ECM Purchased', headingStyle),
                  size: ColumnSize.L,
                    headingRowAlignment: MainAxisAlignment.center
                ),
                DataColumn2(
                  label: buildCenteredText('Date', headingStyle),
                  size: ColumnSize.M,
                    headingRowAlignment: MainAxisAlignment.center

                ),
              ],
              rows: referralSalesData.asMap().entries.map((entry) {
                Map<String, dynamic> data = entry.value;

                return DataRow2(
                  cells: [
                    DataCell(buildCenteredText(data['SL']?.toString() ?? '', cellTextStyle)),
                    DataCell(buildCenteredText(
                      /// Show Full Name
                        data['Name']?.toString() ?? '',

                        /// Show the First Name Only
                        // (data['Name']?.toString().trim().split(' ').first ?? ''),

                        cellTextStyle
                    )
                    ),
                    DataCell(buildCenteredText(data['ECMPurchased']?.toString() ?? '', cellTextStyle)),
                    DataCell(buildCenteredText(data['Date']?.toString() ?? '', cellTextStyle)),
                  ],
                );
              }).toList(),
              empty: Center(
                child: Container(
                  // padding: const EdgeInsets.all(20),
                  padding: EdgeInsets.all(screenWidth * (20.0 / designScreenWidth)),
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