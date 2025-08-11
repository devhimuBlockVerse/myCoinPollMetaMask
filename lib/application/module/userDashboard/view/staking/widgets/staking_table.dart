import 'dart:async';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/application/presentation/models/get_staking_history.dart';
import 'package:mycoinpoll_metamask/application/presentation/viewmodel/wallet_view_model.dart';

import '../../../../../../framework/components/DialogModalViewComponent.dart';
import '../../../../../../framework/utils/customToastMessage.dart';
import '../../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../../framework/utils/enums/toast_type.dart';
import '../../../../../../framework/utils/status_styling_utils.dart';
import '../../../../../presentation/models/staking_plan.dart';


Widget buildStakingTable(
    List<StakingHistoryModel> stakingData,
    double screenWidth, BuildContext context,
    List<StakingPlanModel> stakingPlans,
    WalletViewModel walletVM,
    Future<void> Function() onRefreshHistory,) {
  double baseSize = screenWidth * 0.9;
  double screenHeight = MediaQuery.of(context).size.height;
  const double designScreenWidth = 375.0;


  TextStyle headingStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    // fontSize: baseSize * 0.035,
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
          scrollDirection: Axis.vertical,
          child: SizedBox(
            height: screenHeight * 0.4,
            width: constraints.maxWidth,


            child: DataTable2(
              // dataRowHeight: baseSize * 0.12,
              dataRowHeight: screenHeight * 0.04,

              columnSpacing: screenWidth * 0.001,
              horizontalMargin: screenWidth * 0.002,
              headingRowHeight: screenHeight * 0.06,
              dividerThickness: 0,
              columns: [
                DataColumn2(label: buildCenteredText('SL', headingStyle),
                  fixedWidth: screenWidth * (25.0 / designScreenWidth),

                ),
                DataColumn2(label: buildCenteredText('Date', headingStyle), size: ColumnSize.L),
                DataColumn2(label: buildCenteredText('Duration', headingStyle), size: ColumnSize.L),
                DataColumn2(label: buildCenteredText('Reward', headingStyle), size: ColumnSize.M),
                DataColumn2(label: buildCenteredText('Amount', headingStyle), size: ColumnSize.M),
                DataColumn2(label: buildCenteredText('Status', headingStyle), size: ColumnSize.L),
                DataColumn2(label: buildCenteredText('Action', headingStyle), size: ColumnSize.L),

              ],
              rows: List<DataRow2>.generate(stakingData.length, (index) {

                final data = stakingData[index];
                final statusText = data.status.trim().toLowerCase();
                final statusStyle = getStatusStyling(statusText);


                return DataRow2(

                  cells: [
                    DataCell(buildCenteredText((index +1).toString(), cellTextStyle)),
                    DataCell(buildCenteredText(data.createdAtFormatted, cellTextStyle)),
                     DataCell(buildCenteredText('${data.duration} Days', cellTextStyle)),

                    DataCell(buildCenteredText(data.reward, cellTextStyle)),
                    DataCell(buildCenteredText(data.amount, cellTextStyle)),
                    DataCell(
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02,
                            vertical: screenWidth * 0.006,
                          ),
                           decoration: BoxDecoration(
                            color: statusStyle.backgroundColor,
                            border: Border.all(
                              color: statusStyle.borderColor,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              statusText,
                              style: cellTextStyle.copyWith(color: statusStyle.textColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),

                    DataCell(
                      Center(
                        child: Builder(
                          builder: (context) {
                            final normalizedStatus = data.status.trim().toLowerCase();

                            final endTime = data.endTime;


                            final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
                            final isStakeMatured = currentTime >= endTime!;
                            final actionLabel = (normalizedStatus == 'ready' && isStakeMatured) ? 'unstake'
                                : (normalizedStatus == 'pending' ? 'force' : normalizedStatus);

                            final statusStyle = getStatusStyling(actionLabel);

                            if (normalizedStatus == 'ready' && !isStakeMatured) {
                              return const SizedBox();
                            }

                            return GestureDetector(
                                onTap:() async {
                                  if (normalizedStatus == 'pending' && !isStakeMatured)  {

                                   final confirmed = await showDialog<bool>(
                                     context: context,
                                     builder: (_) =>
                                         DialogModalView(
                                           title: 'Force Unstake?',
                                           message: 'Unstaking early will result in:\n\n• No rewards earned\n• 10% penalty on your staked amount\n\nDo you want to continue?',
                                           yesLabel: 'Yes',
                                           onYes: () {
                                             Navigator.of(context).pop(true);
                                           },
                                           // onNo: () => Navigator.pop(context, false),
                                         ),
                                   );

                                   if (confirmed != true) return;
                                   showDialog(
                                     context: context,
                                     barrierDismissible: false,
                                     builder: (_) =>
                                     const Center(
                                       child: CircularProgressIndicator(
                                           color: Colors.white),
                                     ),
                                   );

                                   try {
                                     final result = await walletVM.forceUnstake(int.parse(data.stakeId));
                                     Navigator.of(context).pop();

                                     if (result != null) {
                                       await onRefreshHistory();
                                       ToastMessage.show(
                                         message: "Force Unstake Successful",
                                         subtitle: "Your funds have been released.",
                                         type: MessageType.success,
                                       );
                                     } else {
                                       ToastMessage.show(
                                         message: "Unstake Failed",
                                         subtitle: "Something went wrong. Try again.",
                                         type: MessageType.error,
                                       );
                                     }
                                   } catch (e) {
                                     Navigator.of(context).pop();
                                     ToastMessage.show(
                                       message: "Error",
                                       subtitle: e.toString(),
                                       type: MessageType.error,
                                     );
                                   }
                                 } else if(normalizedStatus == 'ready' && isStakeMatured) {

                                   final confirmed = await showDialog<bool>(
                                     context: context,
                                     builder: (_) => DialogModalView(
                                       title: 'Unstake?',
                                       message: 'Do you want to unstake your matured amount?',
                                       yesLabel: 'Yes',
                                       onYes: () => Navigator.of(context).pop(true),

                                     ),
                                   );

                                   if (confirmed != true) return;

                                   showDialog(
                                     context: context,
                                     barrierDismissible: false,
                                     builder: (_) => const Center(child: CircularProgressIndicator(color: Colors.white)),
                                   );

                                   try{
                                     final result = await walletVM.unstake(int.parse(data.stakeId));
                                     Navigator.of(context).pop();

                                     if(result != null){
                                       await onRefreshHistory();
                                       ToastMessage.show(
                                         message: "Unstake Successful",
                                         subtitle: "Your funds have been returned with reward.",
                                         type: MessageType.success,
                                       );
                                     }else{
                                       ToastMessage.show(
                                         message: "Unstake Failed",
                                         subtitle: "Please try again.",
                                         type: MessageType.error,
                                       );
                                     }

                                   }catch(e){
                                     Navigator.of(context).pop();
                                     ToastMessage.show(
                                       message: "Error",
                                       subtitle: e.toString(),
                                       type: MessageType.error,
                                     );
                                   }

                                   // 1330.9799999999998

                                 }
                               },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02,
                                  vertical: screenWidth * 0.006,
                                ),
                                decoration: BoxDecoration(
                                  color: statusStyle.backgroundColor,
                                  border: Border.all(
                                    color: statusStyle.borderColor,
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    actionLabel,
                                    style: cellTextStyle.copyWith(color: statusStyle.textColor,),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    ),
  );
 }

extension StringExtension on String {
  String capitalize() => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
void showLiveCountdownToastDialog(BuildContext context, int remainingSeconds) {
  Timer? timer;
  int remaining = remainingSeconds;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          if (remaining > 0 && (timer?.isActive != true)) {
            timer = Timer.periodic(const Duration(seconds: 1), (_) {
              if (remaining > 0) {
                setState(() {
                  remaining--;
                });
              } else {
                timer?.cancel();
                Navigator.of(context).pop(); // auto close
              }
            });
          }

          final duration = Duration(seconds: remaining);
          final days = duration.inDays;
          final hours = duration.inHours % 24;
          final minutes = duration.inMinutes % 60;
          final seconds = duration.inSeconds % 60;

          return Dialog(
            backgroundColor: Colors.black.withOpacity(0.85),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "⏳ Stake not matured yet",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Remaining: ${days}d ${hours}h ${minutes}m ${seconds}s",
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  ).then((_) {
    timer?.cancel(); // cleanup
  });
}


