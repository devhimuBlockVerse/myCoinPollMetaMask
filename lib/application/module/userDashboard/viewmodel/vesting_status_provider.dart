// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../../framework/utils/customToastMessage.dart';
// import '../../../../framework/utils/enums/toast_type.dart';
// import '../../../data/services/api_service.dart';
//
// class VestingStatusProvider with ChangeNotifier {
//
//
//
//   bool _hasUserStartedVestingSleepPeriod = false;
//   bool get hasUserStartedVestingSleepPeriod => _hasUserStartedVestingSleepPeriod;
//
//
//
//
//   bool _isLoading = true;
//   bool get isLoading => _isLoading;
//
//
//
//   // Load state when provider is created
//   VestingStatusProvider() {
//     _loadInitialState();
//   }
//
//   Future<void> _loadInitialState() async {
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//
//       final prefs = await SharedPreferences.getInstance();
//       _hasUserStartedVestingSleepPeriod = prefs.getBool('hasStartedVestingSleepPeriod') ?? false;
//        notifyListeners();
//
//       await loadFromBackend();
//
//     } catch (e) {
//       print("Error loading vesting status from backend: $e");
//      } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<void> loadFromBackend() async {
//     try {
//       final apiService = ApiService();
//       final prefs = await SharedPreferences.getInstance();
//       final userId = prefs.getString('unique_id');
//       if (userId == null || userId.isEmpty) return;
//
//       final status = await apiService.fetchUserVestingStatus(userId);
//       _hasUserStartedVestingSleepPeriod = status['hasStartedSleepPeriod'] ?? false;
//
//       // Update local prefs
//       await prefs.setBool('hasStartedVestingSleepPeriod', _hasUserStartedVestingSleepPeriod);
//
//       print("Loaded vesting status from backend: started=$_hasUserStartedVestingSleepPeriod, "
//
//       );
//       notifyListeners();
//     } catch (e) {
//       print("Error loading from backend: $e");
//      }
//   }
//
//   Future<bool> startVestingSleepPeriod() async {
//     if (_hasUserStartedVestingSleepPeriod) return true;
//
//     // Set local state first
//     _hasUserStartedVestingSleepPeriod = true;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('hasStartedVestingSleepPeriod', true);
//     notifyListeners(); // Show SleepPeriodScreen immediately
//
//     try {
//       final apiService = ApiService();
//       final userId = prefs.getString('unique_id');
//       if (userId != null) {
//         await apiService.updateUserVestingStatus(userId, {
//           'hasStartedSleepPeriod': true,
//           'hasSleepPeriodEnded': false,
//         });
//         print("Saved vesting status to backend: started=true");
//         return true;
//       } else {
//         throw Exception("User ID not found");
//       }
//     } catch (e) {
//       print("Error saving to backend: $e");
//       // Show error but don't revert state (keep local state)
//       ToastMessage.show(
//         message: "Failed to save vesting status",
//         subtitle: "Please try again later",
//         type: MessageType.error,
//         duration: CustomToastLength.LONG,
//         gravity: CustomToastGravity.BOTTOM,
//       );
//       return false;
//     }
//   }
//
//   Future<void> endSleepPeriod() async {
//     if (!_hasUserStartedVestingSleepPeriod) return;
//
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('hasSleepPeriodEnded', true);
//     notifyListeners();
//
//     try {
//       final apiService = ApiService();
//       final userId = prefs.getString('unique_id');
//       if (userId != null) {
//         await apiService.updateUserVestingStatus(userId, {
//           'hasStartedSleepPeriod': true,
//           'hasSleepPeriodEnded': true,
//         });
//       }
//     } catch (e) {
//       print("Error ending sleep period: $e");
//       await prefs.setBool('hasSleepPeriodEnded', false);
//       notifyListeners();
//     }
//   }
//
//   // Optional: if you need to reset it (e.g., on logout)
//   void resetVestingStatus() {
//     _hasUserStartedVestingSleepPeriod = false;
//     notifyListeners();
//     SharedPreferences.getInstance().then((prefs) {
//       prefs.setBool('hasStartedVestingSleepPeriod', false);
//       prefs.setBool('hasSleepPeriodEnded', false);
//     });
//   }
// }
