import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';

class AICameraScreen extends StatelessWidget {
  const AICameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'AI Camera',
        leadingIcon: Icons.camera_alt,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 64),
            SizedBox(height: 16),
            Text('AI Camera Screen'),
            SizedBox(height: 8),
            Text('Integration with existing camera coming soon'),
          ],
        ),
      ),
    );
  }
}
