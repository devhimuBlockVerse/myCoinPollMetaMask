import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 import '../../../../../../framework/utils/dynamicFontSize.dart';

 Widget buildUserActivity(List<Map<String, dynamic>> activityData, double screenWidth, BuildContext context) {
  double baseSize = screenWidth * 0.8;
  double screenHeight = MediaQuery.of(context).size.height;


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
            height: screenHeight * 0.4,
            width: constraints.maxWidth * 1.8,
            child: DataTable2(
              columnSpacing: baseSize * 0.12,
              horizontalMargin: baseSize * 0.0,
              dataRowHeight: baseSize * 0.12,
              headingRowHeight: baseSize * 0.08,
              dividerThickness: 0,
              headingRowDecoration: const BoxDecoration(
                color: Color(0xff051121),
              ),

              columns: [
                DataColumn2(label: buildCenteredText('SL', headingStyle), size: ColumnSize.S),
                DataColumn2(label: buildCenteredText('Date', headingStyle), size: ColumnSize.S),
                 DataColumn2(label: buildCenteredText('Action', headingStyle), size: ColumnSize.L),
                DataColumn2(label: buildCenteredText('Achieved Sales', headingStyle), size: ColumnSize.S),
                DataColumn2(label: buildCenteredText('Target Sales', headingStyle), size: ColumnSize.S),
              ],
              rows: activityData.asMap().entries.map((entry) {
                int idx = entry.key;
                Map<String, dynamic> data = entry.value;

                return DataRow2(

                  cells: [
                    DataCell(buildCenteredText(data['SL'] ?? '', cellTextStyle)),
                    DataCell(buildCenteredText(data['Date'] ?? '', cellTextStyle)),
                    DataCell(buildCenteredText(data['Action'] ?? '', cellTextStyle)),


                    DataCell(buildCenteredText(data['Achieved Sales'] ?? '', cellTextStyle)),
                    DataCell(buildCenteredText(data['Target Sales'] ?? '', cellTextStyle)),




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
