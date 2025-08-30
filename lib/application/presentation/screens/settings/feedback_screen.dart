import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mycoinpoll_metamask/framework/utils/customToastMessage.dart';
import 'package:provider/provider.dart';
import '../../../../framework/components/BlockButton.dart';

class FeedbackViewModel extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _image;
  bool _sending = false;

  static const String webhookUrl =
      // 'https://webhook.site/96adf430-109c-442c-9905-56ec064c29ca';
      'https://webhook.site/408b6f19-873f-4c9f-bf00-14533168ef06';

  File? get image => _image;
  bool get sending => _sending;

  /// Pick image from gallery
  Future<void> pickImage() async {
    final picked =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (picked != null) {
      _image = File(picked.path);
      notifyListeners();
    }
  }

  /// Remove selected image
  void removeImage() {
    _image = null;
    notifyListeners();
  }

  /// Submit feedback
  Future<void> submitFeedback() async {
    if (controller.text.trim().isEmpty && _image == null) {
      ToastMessage.show(message: 'Please write feedback or upload an image');
      return;
    }

    _sending = true;
    notifyListeners();

    try {
      final request = http.MultipartRequest('POST', Uri.parse(webhookUrl));
      request.fields["message"] = controller.text.trim();
      request.fields["createdAt"] = DateTime.now().toIso8601String();

      if (_image != null) {
        request.files.add(await http.MultipartFile.fromPath("image", _image!.path));
      }

      final response = await request.send();
      final res = await http.Response.fromStream(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ToastMessage.show(
            gravity: CustomToastGravity.TOP,
            message: 'Feedback submitted successfully!');
        controller.clear();
        removeImage();
      } else {
        ToastMessage.show(
            gravity: CustomToastGravity.TOP, message: 'Failed to submit feedback');
        print("Server response: ${res.body}");
      }
    } catch (e) {
      print("Error submitFeedback: $e");
      ToastMessage.show(gravity: CustomToastGravity.TOP, message: 'Error: $e');
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
    return Stack(
      children: [
        GestureDetector(
          onTap: vm.pickImage,
          child: Container(
            width: screenWidth * 0.8,
             decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white54),
            ),
            child: vm.image == null
                ? const Center(
              child: Text(
                "Tap to upload screenshots",
                style: TextStyle(color: Colors.white70, height: 3.5),
              ),
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(vm.image!, fit: BoxFit.cover),
            ),
          ),
        ),
        if (vm.image != null)
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: vm.removeImage,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.white,
                ),
              ),
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
      onTap: vm.submitFeedback,
    );
  }
}
