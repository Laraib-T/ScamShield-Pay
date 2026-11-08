
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../processing/processing_screen.dart';

class AnalyzeScreen extends StatefulWidget {
  const AnalyzeScreen({super.key});

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  final TextEditingController linkController =
      TextEditingController();

  final TextEditingController detailsController =
      TextEditingController();

  final ImagePicker picker = ImagePicker();

  XFile? selectedImage;
  Uint8List? imageBytes;

  bool isLoading = false;

  static const Color darkPurple = Color(0xFF54205F);
  static const Color purple = Color(0xFF933E9F);
  static const Color lightPurple = Color(0xFFEAD6F0);
  static const Color background = Color(0xFFFFF5FA);

  Future<void> uploadImage() async {
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1200,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();

        if (bytes.length > 5 * 1024 * 1024) {
          showMessage('Image must be smaller than 5 MB.');
          return;
        }

        setState(() {
          selectedImage = image;
          imageBytes = bytes;
        });
      }
    } catch (e) {
      showMessage('Unable to upload image. Please try again.');
    }
  }

  void removeImage() {
    setState(() {
      selectedImage = null;
      imageBytes = null;
    });
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: darkPurple,
      ),
    );
  }

  void analyzePayment() {
    final link = linkController.text.trim();
    final details = detailsController.text.trim();

    if (link.isEmpty && selectedImage == null) {
      showMessage(
        'Please enter a payment link or upload a screenshot.',
      );
      return;
    }

    if (link.isNotEmpty) {
      final uri = Uri.tryParse(link);

      if (uri == null ||
          !uri.hasScheme ||
          (uri.scheme != 'https' && uri.scheme != 'http') ||
          uri.host.isEmpty) {
        showMessage('Please enter a valid payment link.');
        return;
      }
    }

    setState(() {
      isLoading = true;
    });

    // Analysis service will be connected in the next step.
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        title: const Text(
          'Ready for Analysis!',
          style: TextStyle(
            color: darkPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Your ${link.isNotEmpty ? 'payment link' : 'screenshot'} '
          'and listing details are ready.',
        ),
        actions: [
  TextButton(
    onPressed: () {
      Navigator.pop(dialogContext);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProcessingScreen(),
        ),
      );
    },
    child: const Text(
      'Continue',
      style: TextStyle(color: purple),
    ),
  ),
],
      ),
    ).then((_) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    linkController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: darkPurple,
            size: 21,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Analyze',
          style: TextStyle(
            color: darkPurple,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              height: 260,
              width: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: lightPurple.withOpacity(0.35),
              ),
            ),
          ),

          SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 30),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // TOP ILLUSTRATION
                  Container(
                    height: 145,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFF0DDF3),
                          Color(0xFFFFE9EF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_bag_rounded,
                          color: Color(0xFF9C60AA),
                          size: 72,
                        ),
                        Positioned(
                          right: 65,
                          bottom: 22,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.link_rounded,
                              color: darkPurple,
                              size: 27,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 15,
                          left: 22,
                          child: Icon(
                            Icons.auto_awesome,
                            color: purple.withOpacity(0.6),
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 27),

                  const Text(
                    'Paste Your Payment Link',
                    style: TextStyle(
                      color: darkPurple,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // PAYMENT LINK FIELD
                  TextField(
                    controller: linkController,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      hintText: 'https://example.com/product',
                      hintStyle: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          linkController.clear();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 19),

                  // OR DIVIDER
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Add Listing Details (Optional)',
                    style: TextStyle(
                      color: darkPurple,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // DETAILS FIELD
                  TextField(
                    controller: detailsController,
                    maxLines: 4,
                    maxLength: 300,
                    decoration: InputDecoration(
                      hintText: 'Describe the product or seller...',
                      hintStyle: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // UPLOAD BUTTON
                  InkWell(
                    onTap: uploadImage,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 65,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: lightPurple,
                          width: 1.5,
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_rounded,
                            color: purple,
                            size: 28,
                          ),
                          SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upload Screenshot',
                                style: TextStyle(
                                  color: darkPurple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'JPG, PNG (Max 5MB)',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // IMAGE PREVIEW
                  if (imageBytes != null)
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 155,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              imageBytes!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: removeImage,
                            child: const CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 17,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 25),

                  // ANALYZE BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFA34BA8),
                            Color(0xFF672274),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: purple.withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: isLoading ? null : analyzePayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Analyze Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 17),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shield_rounded,
                        color: darkPurple,
                        size: 17,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'Your data is secure & private',
                        style: TextStyle(
                          color: darkPurple,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
