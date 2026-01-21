import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/custom_app_bar.dart';
import '../../config/theme.dart';
import 'package:flutter/widget_previews.dart';

@Preview(name: 'Public Home Screen')
Widget previewPublicHome() => const PublicHomeScreen();

class PublicHomeScreen extends StatelessWidget {
  const PublicHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF065645),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
              child: Row(
                children: [
                  // User Avatar
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF40bf75).withOpacity(0.3),
                        width: 2,
                      ),
                      image: const DecorationImage(
                        image: NetworkImage('https://i.pravatar.cc/150?img=5'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hello, Sarah!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '28 years old',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF40bf75).withOpacity(0.9),
                              ),
                            ),
                            Container(
                              width: 4,
                              height: 4,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF40bf75).withOpacity(0.4),
                              ),
                            ),
                            Text(
                              'Austin, TX',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF40bf75).withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Notification Button
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
            
            // Main Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const SizedBox(height: 8),
                  
                  // Live Camera Scan Card
                  _ActionCard(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF40bf75), Color(0xFF2d9c5e)],
                    ),
                    icon: Icons.photo_camera,
                    iconColor: const Color(0xFF40bf75),
                    title: 'Live Camera Scan',
                    subtitle: 'Identify animals instantly with AI vision.',
                    buttonText: 'Scan Now',
                    buttonColor: const Color(0xFF40bf75),
                    imageUrl: 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=400',
                    onPressed: () {
                      context.go('/public/camera');
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Report a Stray Card
                  _ActionCard(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade400, Colors.orange.shade600],
                    ),
                    icon: Icons.edit_document,
                    iconColor: Colors.orange.shade600,
                    title: 'Report a Stray',
                    subtitle: 'Alert local rescue services manually.',
                    buttonText: 'Report',
                    buttonColor: const Color(0xFF065645),
                    imageUrl: 'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=400',
                    onPressed: () {
                      context.go('/public/report');
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Adoption List Card
                  _ActionCard(
                    gradient: LinearGradient(
                      colors: [Colors.red.shade300, Colors.red.shade500],
                    ),
                    icon: Icons.favorite,
                    iconColor: Colors.red.shade500,
                    title: 'Adoption List',
                    subtitle: 'Find a furry friend looking for a home.',
                    buttonText: 'View List',
                    buttonColor: const Color(0xFF40bf75),
                    imageUrl: 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=400',
                    onPressed: () {
                       context.go('/public/adoption');
                    },
                  ),
                  const SizedBox(height: 100), // Space for bottom nav
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final Gradient gradient;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String buttonText;
  final Color buttonColor;
  final String imageUrl;
  final VoidCallback onPressed;

  const _ActionCard({
    required this.gradient,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.buttonColor,
    required this.imageUrl,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Left Content
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Title
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF064E3B),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Subtitle
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Button
                    FilledButton(
                      onPressed: onPressed,
                      style: FilledButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 4,
                        shadowColor: buttonColor.withOpacity(0.3),
                      ),
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              
              // Right Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 128,
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade100,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.pets,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


