import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mycoinpoll_metamask/application/domain/constants/api_constants.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';


class VersionService {

  static Future<void> checkVersion(BuildContext context) async {
    try {

      final packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version.trim();

      final response = await http.get(
        Uri.parse("${ApiConstants.baseUrl}/app-version-checker"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String latestVersion = data["latest_version"].toString().split("+").first.trim();

        String updateUrl = data["update_url"];

        if (currentVersion != latestVersion) {
          showUpdateDialog(context, updateUrl);
        }
      } else {
        debugPrint("API error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Version check failed: $e");
    }
  }

  static Timer? _updateTimer;

  static void showUpdateDialog(BuildContext context, String updateUrl) {
     _updateTimer?.cancel();

    _showDialog(context, updateUrl);


    _updateTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      if (context.mounted) {
        _showDialog(context, updateUrl);
      }
    });
  }

  static void _showDialog(BuildContext context, String updateUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Icon(Icons.system_update, color: const Color(0XFF1CD691), size: 64),
                    const SizedBox(height: 16),
                    const Text(
                      "Update Required 🚀",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "A new version of the app is available.\n\n"
                          "⚠️ Please update to continue.\n"
                          "Your old version will no longer work.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {

                          _launchUrl(updateUrl);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0XFF1CD691),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.download, color: Colors.black),
                        label: const Text(
                          "Update Now",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }


}

