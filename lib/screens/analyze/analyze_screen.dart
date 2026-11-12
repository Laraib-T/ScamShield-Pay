
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../compare/compare_screen.dart';
import '../processing/processing_screen.dart';

class AnalyzeScreen extends StatefulWidget {
  const AnalyzeScreen({super.key});

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  final TextEditingController linkController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  XFile? selectedImage;
  Uint8List? imageBytes;

  bool isLoading = false;

  static const Color darkPurple = Color(0xFF54205F);
  static const Color purple = Color(0xFF933E9F);
  static const Color lightPurple = Color(0xFFEAD6F0);
  static const Color background = Color(0xFFFFF5FA);

  bool get isDark =>
      Theme.of(context).brightness == Brightness.dark;

  Color get pageColor =>
      isDark ? const Color(0xFF17121B) : background;

  Color get cardColor =>
      isDark ? const Color(0xFF29212F) : Colors.white;

  Color get headingColor =>
      isDark ? const Color(0xFFF4E8F7) : darkPurple;

  Color get secondaryColor =>
      isDark ? Colors.white70 : Colors.grey;

  Color get borderColor =>
      isDark ? const Color(0xFF59445F) : lightPurple;

  Future<void> uploadImage() async {
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1200,
      );

      if (image == null) return;

      final bytes = await image.readAsBytes();

      if (bytes.length > 5 * 1024 * 1024) {
        showMessage('Image must be smaller than 5 MB.');
        return;
      }

      setState(() {
        selectedImage = image;
        imageBytes = bytes;
      });
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

  void clearAll() {
    linkController.clear();
    detailsController.clear();

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

    if (link.isEmpty && details.isEmpty && imageBytes == null) {
      showMessage(
        'Please enter details, a product link or upload a screenshot.',
      );
      return;
    }

    if (link.isNotEmpty) {
      final uri = Uri.tryParse(link);

      if (uri == null ||
          !uri.hasScheme ||
          (uri.scheme != 'https' && uri.scheme != 'http') ||
          uri.host.isEmpty ||
          uri.host.contains(' ')) {
        showMessage('Please enter a valid product link.');
        return;
      }
    }

    final List<String> inputs = [];

    if (link.isNotEmpty) inputs.add('product link');
    if (details.isNotEmpty) inputs.add('seller details');
    if (imageBytes != null) inputs.add('screenshot');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        title: Text(
          'Ready for Analysis?',
          style: TextStyle(
            color: headingColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'You have provided: ${inputs.join(', ')}.\n\n'
          'Continue to the processing screen?',
          style: TextStyle(color: secondaryColor),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);

              final parts = <String>[];

              if (link.isNotEmpty) {
                parts.add('Product link: $link');
              }

              if (details.isNotEmpty) {
                parts.add('Seller/listing details: $details');
              }

              final name = (selectedImage?.name ?? '').toLowerCase();

              final mediaType = name.endsWith('.png')
                  ? 'image/png'
                  : name.endsWith('.webp')
                      ? 'image/webp'
                      : 'image/jpeg';

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProcessingScreen(
                    text: parts.join('\n'),
                    imageBytes: imageBytes,
                    mediaType: mediaType,
                  ),
                ),
              );
            },
            child: const Text(
              'Continue',
              style: TextStyle(
                color: purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration inputDecoration({
    required String hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 13,
        color: secondaryColor,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: cardColor,
      counterStyle: TextStyle(color: secondaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: purple, width: 1.5),
      ),
    );
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
      backgroundColor: pageColor,

      appBar: AppBar(
        backgroundColor: pageColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: headingColor,
            size: 21,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Analyze',
          style: TextStyle(
            color: headingColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Compare sellers',
            icon: Icon(
              Icons.compare_arrows_rounded,
              color: headingColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CompareScreen(),
                ),
              );
            },
          ),
          TextButton(
            onPressed: clearAll,
            child: const Text(
              'Clear',
              style: TextStyle(
                color: purple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
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
                color: (isDark ? purple : lightPurple)
                    .withValues(alpha: isDark ? 0.12 : 0.35),
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
                      gradient: LinearGradient(
                        colors: isDark
                            ? const [
                                Color(0xFF49304F),
                                Color(0xFF302333),
                              ]
                            : const [
                                Color(0xFFF0DDF3),
                                Color(0xFFFFE9EF),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_rounded,
                          color: isDark
                              ? const Color(0xFFD3A4DF)
                              : const Color(0xFF9C60AA),
                          size: 72,
                        ),
                        Positioned(
                          right: 65,
                          bottom: 22,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: cardColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.link_rounded,
                              color: headingColor,
                              size: 27,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 15,
                          left: 22,
                          child: Icon(
                            Icons.auto_awesome,
                            color: purple.withValues(alpha: 0.7),
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 27),

                  Text(
                    'Paste Your Product Link',
                    style: TextStyle(
                      color: headingColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: linkController,
                    keyboardType: TextInputType.url,
                    style: TextStyle(color: headingColor),
                    decoration: inputDecoration(
                      hint: 'https://example.com/product',
                      prefixIcon: const Icon(
                        Icons.link_rounded,
                        color: purple,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          linkController.clear();
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 19),

                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'Add Listing Details',
                    style: TextStyle(
                      color: headingColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Describe the seller, product or payment request.',
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: detailsController,
                    maxLines: 4,
                    maxLength: 300,
                    style: TextStyle(color: headingColor),
                    decoration: inputDecoration(
                      hint: 'Describe the product or seller...',
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
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: borderColor,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.image_rounded,
                            color: purple,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upload Screenshot',
                                style: TextStyle(
                                  color: headingColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'JPG, PNG (Max 5MB)',
                                style: TextStyle(
                                  color: secondaryColor,
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
                            color: cardColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: borderColor),
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
                            color: purple.withValues(alpha: 0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: isLoading ? null : analyzePayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          disabledBackgroundColor: Colors.transparent,
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shield_rounded,
                        color: headingColor,
                        size: 17,
                      ),
                      const SizedBox(width: 7),
                      Flexible(
                        child: Text(
                          'Your listing is analyzed by AI. See Settings > Privacy.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: headingColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
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
