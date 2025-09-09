import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
 import 'package:mycoinpoll_metamask/application/domain/constants/api_constants.dart';
import 'package:mycoinpoll_metamask/framework/utils/customToastMessage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../framework/components/BlockButton.dart';
import '../../../../framework/utils/enums/toast_type.dart';
import '../../../data/services/api_service.dart';
import '../../models/user_model.dart';


class FeedbackViewModel extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  List<File> _images = [];
  bool _sending = false;

  static const String apiUrl = "${ApiConstants.baseUrl}/user-app-feedback";

  List<File> get images => _images;
  bool get sending => _sending;
  bool _loading = false;
  bool get loading => _loading;

  /// Pick multiple images from gallery
  Future<void> pickImage() async {
    try {
      _loading = true;
      notifyListeners();

      final List<XFile>? pickedFiles = await _picker.pickMultiImage(
        imageQuality: 75,
      );
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        for (var xfile in pickedFiles){
          if(_images.length >= 10){
            ToastMessage.show(message: "You can only upload 10 images");
            return;
          }
          final file = File(xfile.path);
          final sizeInMb = await file.length() / (1024 * 1024);

          if(sizeInMb > 7){
            ToastMessage.show(message: "Image size should be less than 7 MB");
            continue;
          }
          _images.add(file);
        }
        notifyListeners();

        // _images.addAll(pickedFiles.map((xfile) => File(xfile.path)));
        // notifyListeners();
      }
    } catch (e) {
      print("Error picking images: $e");
      ToastMessage.show(message: "Failed to pick images");
    }finally{
      _loading = false;
      notifyListeners();
    }
  }


  /// Remove selected image
  void removeImage(int index) {
    _images.removeAt(index);
    notifyListeners();
  }

  /// Submit feedback
  Future<void> submitFeedback(String username) async {
    if (controller.text.trim().isEmpty && _images.isEmpty) {
      ToastMessage.show(message: 'Please write feedback or upload an image');
      return;
    }

    _sending = true;
    notifyListeners();

    try {
      List<String> base64Images = [];
      for (var img in _images) {
        final bytes = await img.readAsBytes();
        base64Images.add(base64Encode(bytes));
      }

    final success = await ApiService().submitUserFeedback(
      message: controller.text.trim(),
      username: username,
      base64Images: base64Images,
    );

    if (success) {
      ToastMessage.show(
        type:MessageType.success,
        gravity: CustomToastGravity.BOTTOM,
        message: 'Feedback submitted successfully!',
      );
      controller.clear();
      _images.clear();
      notifyListeners();
    }

    } catch (e) {
      print("Error submitFeedback: $e");
      ToastMessage.show(
        gravity: CustomToastGravity.BOTTOM,
        message: 'Error: $e',
      );
    } finally {
      _sending = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}


class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FeedbackViewModel(),
      child: const FeedbackScreenBody(),
    );
  }
}

class FeedbackScreenBody extends StatelessWidget {
  const FeedbackScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FeedbackViewModel>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final baseSize = screenHeight > screenWidth ? screenWidth : screenHeight;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: const BoxDecoration(
            color: Color(0xFF01090B),
            image: DecorationImage(
              image: AssetImage('assets/images/solidBackGround.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.01),
              _buildHeader(screenWidth, context),
              SizedBox(height: screenHeight * 0.01),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.01),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.02),
                        _buildFeedbackInput(screenWidth, screenHeight, vm),
                        SizedBox(height: screenHeight * 0.03),
                        _buildImagePicker(screenWidth, screenHeight, vm),
                        SizedBox(height: screenHeight * 0.03),
                        _buildSubmitButton(screenWidth, screenHeight, baseSize, vm),
                        SizedBox(height: screenHeight * 0.01),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: SvgPicture.asset('assets/icons/back_button.svg',
              color: Colors.white,
              width: screenWidth * 0.04,
              height: screenWidth * 0.04),
          onPressed: () => Navigator.pop(context),
        ),
        Expanded(
          child: Center(
            child: Text(
              'Feedback',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.05,
              ),
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.12),
      ],
    );
  }

  Widget _buildFeedbackInput(
      double screenWidth, double screenHeight, FeedbackViewModel vm) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
      decoration: BoxDecoration(
        color: const Color(0xff040C16),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Write your Feedback!',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: const Color(0xFFF4F4F5),
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.042,
                height: 1.6,
                letterSpacing: -0.40,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Container(
            width: screenWidth,
            height: screenHeight * 0.25,
            padding: EdgeInsets.all(screenWidth * 0.03),
            decoration: BoxDecoration(
              color: const Color(0xFF101A29),
              borderRadius: BorderRadius.circular(screenWidth * 0.02),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3F9C9C9C),
                  blurRadius: 6.4,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: TextField(
              controller: vm.controller,
              maxLines: null,
              expands: true,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.035,
                fontFamily: 'Poppins',
              ),
              decoration: InputDecoration(
                hintText: 'Feel free to write what you say...',
                hintStyle: TextStyle(
                  color: const Color(0xFF7D8FA9),
                  fontSize: screenWidth * 0.035,
                  fontFamily: 'Poppins',
                  letterSpacing: -0.4,
                  height: 1.6,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
              cursorColor: Colors.tealAccent,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildImagePicker(
      double screenWidth, double screenHeight, FeedbackViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: vm.pickImage,
          child: Container(
            width: screenWidth,
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white54),
            ),
            child: vm.images.isEmpty
                ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Tap to upload screenshots",
                    style: TextStyle(color: Colors.white70, height: 1.5),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Max 10 images, each should be less than 7 MB",
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: screenWidth * 0.03,
                    ),
                  ),
                ],
              ),
            )
                : SizedBox(
              height: screenHeight * 0.15,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: vm.images.length,
                itemBuilder: (context, index) {
                  final img = vm.images[index];
                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: screenWidth * 0.28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: FileImage(img),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => vm.removeImage(index),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      // Loading overlay
                      if (vm.loading)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black45,
                            child: const Center(
                              child: CircularProgressIndicator(color: Colors.white),
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${index + 1}/${vm.images.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),

        // Optional: show remaining image count
        if (vm.images.isNotEmpty)
          Text(
            'You can upload ${10 - vm.images.length} more image(s)',
            style: TextStyle(
              color: Colors.white38,
              fontSize: screenWidth * 0.03,
            ),
          ),


      ],
    );
  }

  Widget _buildSubmitButton(
      double screenWidth, double screenHeight, double baseSize, FeedbackViewModel vm) {
    return vm.sending
        ? const CircularProgressIndicator(color: Colors.white)
        : BlockButton(
      height: screenHeight * 0.052,
      width: screenWidth * 0.7,
      label: 'Submit',
      textStyle: TextStyle(
        fontWeight: FontWeight.w700,
        color: Colors.white,
        fontSize: baseSize * 0.044,
      ),
      gradientColors: const [
        Color(0xFF2680EF),
        Color(0xFF1CD494),
      ],
      onTap: ()async{
        try{
          final prefs = await SharedPreferences.getInstance();
          final userJson = prefs.getString('user');

          if (userJson == null) {
            ToastMessage.show(message: "User not found. Please login again.");
            return;
          }
          final user = UserModel.fromJson(jsonDecode(userJson));
          final username = user.username ?? "Unknown";
          await vm.submitFeedback(username);
        }catch(e){

        }
      },
    );
  }
}
