import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/custom_app_bar.dart';
import '../../config/theme.dart';

class PublicHomeScreen extends StatelessWidget {
  const PublicHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: CustomAppBar(
        title: 'PawGuard AI',
        leadingIcon: Icons.pets,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.pets,
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Every Paw Matters',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Help us protect and care for our furry friends',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Quick Actions
            Text(
              'QUICK ACTIONS',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: theme.colorScheme.onBackground.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 12),
            
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildActionCard(
                  context,
                  icon: Icons.camera_alt,
                  title: 'AI Scan',
                  description: 'Identify pets',
                  onTap: () => context.go('/public/camera'),
                ),
                _buildActionCard(
                  context,
                  icon: Icons.report,
                  title: 'Report',
                  description: 'Spotted a stray',
                  onTap: () => context.go('/public/report'),
                ),
                _buildActionCard(
                  context,
                  icon: Icons.favorite,
                  title: 'Adopt',
                  description: 'Find a friend',
                  onTap: () => context.go('/public/adoption'),
                ),
                _buildActionCard(
                  context,
                  icon: Icons.groups,
                  title: 'Community',
                  description: 'Join us',
                  onTap: () => context.go('/public/community'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Recent Sightings
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Sightings',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Sighting Cards (placeholder)
            _buildSightingCard(
              context,
              imageUrl: 'https://via.placeholder.com/150',
              title: 'Golden Retriever',
              location: 'Central Park, Manila',
              timeAgo: '2 hours ago',
            ),
            _buildSightingCard(
              context,
              imageUrl: 'https://via.placeholder.com/150',
              title: 'Persian Cat',
              location: 'BGC, Taguig',
              timeAgo: '5 hours ago',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSightingCard(
    BuildContext context, {
    required String imageUrl,
    required String title,
    required String location,
    required String timeAgo,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 60,
                height: 60,
                color: theme.colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.pets,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeAgo,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}

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
                      // Navigate to camera
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
                      // Navigate to report
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
                      // Navigate to adoption list
                    },
                  ),
                  const SizedBox(height: 100), // Space for bottom nav
                ],
              ),
            ),
          ],
        ),
      ),
      
      // Bottom Navigation
      bottomNavigationBar: _CustomBottomNav(),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          // Open camera
        },
        backgroundColor: const Color(0xFF40bf75),
        elevation: 8,
        child: const Icon(
          Icons.photo_camera,
          size: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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

class _CustomBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF064E3B).withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(0),
        ),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: ClipPath(
        clipper: _BottomNavClipper(),
        child: Container(
          height: 80,
          padding: const EdgeInsets.only(bottom: 24, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavItem(
                icon: Icons.home,
                label: 'Home',
                isSelected: true,
                onTap: () {},
              ),
              _NavItem(
                icon: Icons.groups_outlined,
                label: 'Community',
                isSelected: false,
                onTap: () {},
              ),
              const SizedBox(width: 60), // Space for FAB
              _NavItem(
                icon: Icons.volunteer_activism_outlined,
                label: 'Adoption',
                isSelected: false,
                onTap: () {},
              ),
              _NavItem(
                icon: Icons.person_outline,
                label: 'Profile',
                isSelected: false,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? const Color(0xFF40bf75)
        : Colors.white.withOpacity(0.4);

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    
    // Left side
    path.lineTo(size.width * 0.35, 0);
    
    // Curve for FAB
    path.quadraticBezierTo(
      size.width * 0.40, 0,
      size.width * 0.42, 10,
    );
    path.arcToPoint(
      Offset(size.width * 0.58, 10),
      radius: const Radius.circular(45),
      clockwise: false,
    );
    path.quadraticBezierTo(
      size.width * 0.60, 0,
      size.width * 0.65, 0,
    );
    
    // Right side
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
