import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/application/presentation/models/eCommerce_model.dart';

import '../../application/domain/model/DialogModel.dart';
import '../components/CustomDialog.dart';
import 'dynamicFontSize.dart';

class DialogUtils {

  static void showroadmapDialog(BuildContext context, RoadmapDatum roadmapDatum){
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "Dismiss",
        barrierColor: Colors.black.withOpacity(0.2),
        pageBuilder: (_, __, ___){
          return CustomDialog(
              title: roadmapDatum.heading,
              subtitle: roadmapDatum.name,
            image: 'assets/images/dialogBgvv.png',
              items: roadmapDatum.tasks.map((task){
                return DialogItem(
                    text: task.name,
                    // icon: task.status ? Icons.check_box : Icons.timer,
                    icon: task.status ?
                    Image.asset(
                      'assets/images/checked.png',
                      width: getResponsiveFontSize(context, 18),
                      height: getResponsiveFontSize(context, 18),
                    ):
                    Icon(
                      Icons.access_time_filled,
                      size: getResponsiveFontSize(context, 18),
                      color: Colors.yellow.shade500,
                    ),
                );
              }).toList(),
          );
        }
    );
  }





}


