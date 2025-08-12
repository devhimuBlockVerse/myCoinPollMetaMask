import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/application/presentation/models/eCommerce_model.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';
import '../components/roadMapContainerComponent.dart';
import '../utils/dialog_utils.dart';

Widget buildRoadmapSection(BuildContext context, double screenHeight, TokenDetails tokenDetails) {

  List<Widget> roadmapWidgets = [];
  final roadmapDataList = tokenDetails.roadmap.roadmapData;
  const String checkedImagePath = 'assets/images/checked.png';

  for (int i = 0; i < roadmapDataList.length; i++) {
    final roadmapItem = roadmapDataList[i];
    final totalTasks = roadmapItem.tasks.length;
    final maxPreviewTasks = 4 ;

    List<Widget> labels = [];
    for (var task in roadmapItem.tasks.take(maxPreviewTasks)) {
      labels.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            task.status ?
            Image.asset(
                checkedImagePath,
              width: getResponsiveFontSize(context, 18),
              height: getResponsiveFontSize(context, 18),
            ):
            Icon(
              Icons.access_time_filled,
              size: getResponsiveFontSize(context, 18),
              color: Colors.yellow.shade500,
            ),
            SizedBox(width: getResponsiveFontSize(context, 5)),
            Expanded(
              child: Text(task.name,
              style: TextStyle(
                color: Colors.white54,
                fontSize: getResponsiveFontSize(context, 12),
                height: 1.6,
                fontWeight: FontWeight.w300,
                fontFamily: 'Poppins',
              ),
              ),
            ),
          ],
        ),

      );
    }
    final bool hasMoreTasks = totalTasks > maxPreviewTasks;

    roadmapWidgets.add(
      RoadmapContainerComponent(
        title: roadmapItem.heading,
        labels: labels,
        onTap: hasMoreTasks ? ()=>  DialogUtils.showroadmapDialog(context, roadmapItem) : null,
        mapYear: roadmapItem.name,
      ),
    );

     if (i < roadmapDataList.length - 1) {
      roadmapWidgets.add(SizedBox(height: screenHeight * 0.03));
      roadmapWidgets.add(
        Center(
          child: Transform.translate(
            offset: const Offset(0, -28),
            child: Image.asset(
              'assets/images/line.png',
              height: screenHeight * 0.07,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );

      roadmapWidgets.add(SizedBox(height: screenHeight * 0.03));
    }
  }

  return SizedBox(
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: roadmapWidgets,
    ),
  );

}
