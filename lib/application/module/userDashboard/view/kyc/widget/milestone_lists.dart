import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/framework/components/BlockButton.dart';

import '../../../../../../framework/components/buy_Ecm.dart';
import '../../../../../../framework/res/colors.dart';
import '../kyc_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';


class MilestoneLists extends StatelessWidget {
  final EcmTaskModel task;

  const MilestoneLists({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth < 380;
    final scaleFactor = isSmallScreen ? 0.9 : 1.0;

    return Card(
      // elevation: 9,
      margin: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icons/milestoneBG.png'),
            fit: BoxFit.fill,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical:screenHeight * 0.020,horizontal: screenWidth * 0.03),

        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageSection(context, scaleFactor),
                SizedBox(width: screenWidth * 0.02),
                Expanded(child: _buildDetailsSection(context, scaleFactor)),
              ],
            ),
            SizedBox(height: screenHeight * 0.015),
            _buildActionButton(context, scaleFactor),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, double scaleFactor) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = screenWidth * 0.32 * scaleFactor;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: task.imageUrl,
            width: imageSize,
            height: imageSize * 1.18,
            fit: BoxFit.fill,
            placeholder: (context, url) => Container(
              width: imageSize,
              // height: imageSize * 1.1,
              color: AppColors.disabledButton,
              child: const Center(
                  child: CircularProgressIndicator(color: AppColors.accentGreen)),
            ),
            errorWidget: (context, url, error) => Container(
              width: imageSize,
              height: imageSize * 1.1,
              color: AppColors.disabledButton,
              child: const Icon(Icons.error, color: AppColors.textSecondary),
            ),
          ),
        ),
        if (task.status != EcmTaskStatus.completed)
          Positioned(
            top: 6,
            left: 72,
            child: _buildStatusBadge(context),
          ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    String text;
    Color backgroundColor;

    switch (task.status) {
      case EcmTaskStatus.active:
        text = "Active";
        backgroundColor = AppColors.accentGreen;
        break;
      case EcmTaskStatus.ongoing:
        text = "On Going";
        backgroundColor = AppColors.accentOrange;
        break;
      case EcmTaskStatus.completed:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: AppTextStyles.statusBadgeText.copyWith(fontSize: 12),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context, double scaleFactor) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title with scaled font size & no overflow
        Text(
          task.title,
          style: AppTextStyles.cardTitle(context).copyWith(
            fontSize: 18 * scaleFactor,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/detailsBg.png'),
              fit: BoxFit.fill,
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 12 * scaleFactor,
            horizontal: 12 * scaleFactor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildInfoRow("Target Sales", task.targetSales, scaleFactor, context),
              SizedBox(
                width: screenWidth * 0.9,
                child: const Divider(
                  color: Colors.white12,
                  thickness: 1,
                  height: 15,
                ),
              ),
              _buildInfoRow("Deadline", task.deadline, scaleFactor, context),
              SizedBox(
                width: screenWidth * 0.9,
                child: const Divider(
                  color: Colors.white12,
                  thickness: 1,
                  height: 15,
                ),
              ),
              _buildInfoRow(
                "Reward",
                task.reward.primaryReward ?? " ",
                scaleFactor,
                context,
                valueStyle: (task.reward.primaryReward!.startsWith("\$") ||
                    task.reward.secondaryReward == null)
                    ? AppTextStyles.rewardText(context).copyWith(fontSize: 16 * scaleFactor)
                    : AppTextStyles.rewardText(context).copyWith(fontSize: 16 * scaleFactor),
              ),
            ],
          ),
        ),
        // const SizedBox(height: 8),
        Text(
          task.milestoneMessage,
          style: AppTextStyles.milestoneText(context).copyWith(
            fontSize: 14 * scaleFactor,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 12 * scaleFactor),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, double scaleFactor, BuildContext context,
      {TextStyle? valueStyle}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0 * scaleFactor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 5,
            child: Text(
              "$label ",
              style: AppTextStyles.cardSubtitle(context).copyWith(fontSize: 14 * scaleFactor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Flexible(
            flex: 5,
            child: Text(
              value,
              style: valueStyle ??
                  AppTextStyles.cardSubtitle(context).copyWith(fontSize: 14 * scaleFactor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, double scaleFactor) {
    final Size screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final bool isPortrait = screenHeight > screenWidth;

    final baseSize = isPortrait ? screenWidth : screenHeight;

    switch (task.status) {
      case EcmTaskStatus.active:
        return BlockButton(
          height: baseSize * 0.09 * scaleFactor,
          width: screenWidth * 0.7,
          label: "Start Now",
          textStyle: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: baseSize * 0.045 * scaleFactor,
          ),
          gradientColors: const [
            Color(0xFF2680EF),
            Color(0xFF1CD494),
          ],
          onTap: () {
            debugPrint('Button tapped');
          },
        );

      case EcmTaskStatus.ongoing:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 14),
            Expanded(
              child: Opacity(
                opacity: 0.75,
                child: BlockButton(
                  height: baseSize * 0.09 * scaleFactor,
                  label: "Started",
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: baseSize * 0.036 * scaleFactor,
                  ),
                  gradientColors: const [
                    Color(0xFF2680EF),
                    Color(0xFF1CD494),
                  ],
                  onTap: () {
                    debugPrint('Button tapped');
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: BuyEcm(
                text: 'See Details',
                onPressed: () {
                  debugPrint('Button tapped!');
                },
                height: baseSize * 0.10 * scaleFactor,
              ),
            ),
            const SizedBox(width: 14),
          ],
        );

      case EcmTaskStatus.completed:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 14),
            Expanded(
              child: BuyEcm(
                text: 'Completed',
                onPressed: () {
                  debugPrint('Button tapped!');
                },
                height: baseSize * 0.10 * scaleFactor,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: BuyEcm(
                text: 'See Details',
                onPressed: () {
                  debugPrint('Button tapped!');
                },
                height: baseSize * 0.10 * scaleFactor,
              ),
            ),
            const SizedBox(width: 14),
          ],
        );
    }
  }
}



