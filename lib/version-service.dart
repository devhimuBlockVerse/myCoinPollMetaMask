import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mycoinpoll_metamask/application/domain/constants/api_constants.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// class VersionService {
//   static Future<void> checkVersion(BuildContext context) async {
//     try {
//       final packageInfo = await PackageInfo.fromPlatform();
//       String currentVersion = packageInfo.version.trim();
//
//       final response = await http.get(
//         Uri.parse("${ApiConstants.baseUrl}/app-version-checker"),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         String latestVersion =
//             data["latest_version"].toString().split("+").first.trim();
//
//         String updateUrl = data["update_url"];
//
//         if (currentVersion != latestVersion) {
//           showUpdateDialog(context, updateUrl);
//         }
//       } else {
//         debugPrint("API error: ${response.statusCode}");
//       }
//     } catch (e) {
//       debugPrint("Version check failed: $e");
//     }
//   }
//
//   static Timer? _updateTimer;
//
//   static void showUpdateDialog(BuildContext context, String updateUrl) {
//     _updateTimer?.cancel();
//
//     _showDialog(context, updateUrl);
//
//     _updateTimer = Timer.periodic(const Duration(minutes: 5), (_) {
//       if (context.mounted) {
//         _showDialog(context, updateUrl);
//       }
//     });
//   }
//
//   static void _showDialog(BuildContext context, String updateUrl) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext dialogContext) {
//         return Dialog(
//           backgroundColor: Colors.grey[900],
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Stack(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const SizedBox(height: 20),
//                     Icon(Icons.system_update,
//                         color: const Color(0XFF1CD691), size: 64),
//                     const SizedBox(height: 16),
//                     const Text(
//                       "Update Required 🚀",
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     const Text(
//                       "A new version of the app is available.\n\n"
//                       "⚠️ Please update to continue.\n"
//                       "Your old version will no longer work.",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.white70,
//                         height: 1.5,
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton.icon(
//                         onPressed: () {
//                           _launchUrl(updateUrl);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0XFF1CD691),
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         icon: const Icon(Icons.download, color: Colors.black),
//                         label: const Text(
//                           "Update Now",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Positioned(
//                 top: 0,
//                 right: 0,
//                 child: IconButton(
//                   icon: const Icon(Icons.close, color: Colors.white70),
//                   onPressed: () {
//                     Navigator.of(dialogContext).pop();
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   static Future<void> _launchUrl(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//       throw 'Could not launch $url';
//     }
//   }
// }
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
        print("Latest Version: ${data}");
        String latestVersion =
            data["latest_version"].toString().split("+").first.trim();

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

  static void showUpdateDialog(BuildContext context, String updateUrl) {
    _showDialog(context, updateUrl);
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
                    Icon(Icons.system_update,
                        color: const Color(0XFF1CD691), size: 64),
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
                    // const Text(
                    //   "A new version of the application is available with Enhanced Features.\n\n"
                    //   "• Added: Existing Vesting User support.\n"
                    //   "• Performance and security improvements.\n\n"
                    //   "⚠️ Important: Please Uninstall the current version and Install latest version to access new features and maintain app compatibility.",
                    //   textAlign: TextAlign.start,
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     color: Colors.white70,
                    //     height: 1.5,
                    //   ),
                    // ),
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(
                            text:
                                "A new version of the application is available with Enhanced Features.\n\n",
                          ),
                          const TextSpan(
                            text: "• Added: Existing Vesting User Panel.\n",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const TextSpan(
                            text: "• Performance & Security Improvements.\n\n",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const TextSpan(
                            text:
                                "⚠️ Important: Please Uninstall the current version and Install latest version to access new features and maintain app compatibility.",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          _launchUrl(updateUrl);
                          // Navigator.of(dialogContext).pop();
                          // await _downloadAndInstallApk(context, updateUrl);
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

  // static Future<void> _downloadAndInstallApk(BuildContext context, String downloadUrl) async {
  //   try {
  //     // Show download progress dialog
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return Dialog(
  //           backgroundColor: Colors.grey[900],
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(16),
  //           ),
  //           child: Padding(
  //             padding: const EdgeInsets.all(20),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 const CircularProgressIndicator(
  //                   valueColor:
  //                       AlwaysStoppedAnimation<Color>(Color(0XFF1CD691)),
  //                 ),
  //                 const SizedBox(height: 16),
  //                 const Text(
  //                   "Downloading Update...",
  //                   style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 const Text(
  //                   "Please wait while we download the latest version",
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     fontSize: 14,
  //                     color: Colors.white70,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //
  //     await _requestPermissions();
  //
  //     final response = await http.get(Uri.parse(downloadUrl));
  //     if (response.statusCode == 200) {
  //       final bytes = response.bodyBytes;
  //
  //       final directory = await getExternalStorageDirectory();
  //       final file = File('${directory!.path}/app_update.apk');
  //
  //       // Write APK file
  //       await file.writeAsBytes(bytes);
  //
  //       // Close download dialog
  //       Navigator.of(context).pop();
  //
  //       // Install APK
  //       await _installApk(file.path);
  //     } else {
  //       Navigator.of(context).pop();
  //       _showErrorDialog(context, "Download failed. Please try again.");
  //     }
  //   } catch (e) {
  //     Navigator.of(context).pop();
  //     _showErrorDialog(context, "Download failed. Please try again.");
  //   }
  // }
  //
  // static Future<void> _requestPermissions() async {
  //   await Permission.storage.request();
  //
  //   if (Platform.isAndroid) {
  //     await Permission.requestInstallPackages.request();
  //   }
  // }
  //
  // static Future<void> _installApk(String apkPath) async {
  //   try {
  //     final Uri uri = Uri.file(apkPath);
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } catch (e) {
  //     debugPrint('Installation failed: $e');
  //     throw 'Could not install APK: $e';
  //   }
  // }
  //
  // static void _showErrorDialog(BuildContext context, String message) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: Colors.grey[900],
  //         title: const Text(
  //           "Update Failed",
  //           style: TextStyle(color: Colors.white),
  //         ),
  //         content: Text(
  //           message,
  //           style: const TextStyle(color: Colors.white70),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text(
  //               "OK",
  //               style: TextStyle(color: Color(0XFF1CD691)),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
