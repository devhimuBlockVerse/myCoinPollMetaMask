import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mycoinpoll_metamask/application/data/services/api_service.dart';
import 'package:mycoinpoll_metamask/application/domain/constants/api_constants.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';


class VersionService {
  static Future<void> checkVersion(BuildContext context) async {
    try {
      // current app version from pubspec.yaml
      final packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version.trim();

      // API call
      final response = await http.get(
        Uri.parse("${ApiConstants.baseUrl}/app-version-checker"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // String latestVersion = data["latest_version"];
        String latestVersion = data["latest_version"].toString().split("+").first.trim();

        String updateUrl = data["update_url"];

        // check version mismatch
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
    // stop previous timers (if any)
    _updateTimer?.cancel();

    // first show immediately
    _showDialog(context, updateUrl);


    _updateTimer = Timer.periodic(const Duration(minutes: 20), (_) {
      if (context.mounted) {
        _showDialog(context, updateUrl);
      }
    });
  }



  // static Future<void> checkVersion(BuildContext context) async {
  //   final packageInfo = await PackageInfo.fromPlatform();
  //   String currentVersion = packageInfo.version;
  //
  //   // Dummy response (simulate API)
  //   final data = {
  //     "latest_version": "1.2.0",
  //     "update_url": "${ApiConstants.baseUrl}/app-version-checker"
  //   };
  //
  //   String latestVersion = data["latest_version"]!;
  //   String updateUrl = data["update_url"]!;
  //
  //   if (currentVersion != latestVersion) {
  //     _showDialog(context, updateUrl);
  //   }
  // }


  // static void _showUpdateDialog(BuildContext context, String updateUrl) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text("Update Available"),
  //         content: const Text("A new version of the app is available. Please update now."),
  //         actions: [
  //           TextButton(
  //             onPressed: () => _launchUrl(updateUrl),
  //             child: const Text("Update Now"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  static void _showDialog(BuildContext context, String updateUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.system_update, color: Colors.orangeAccent, size: 64),
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
                    onPressed: () => _launchUrl(updateUrl),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
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