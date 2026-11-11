
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color primary = Color(0xFF5146C8);
  static const Color darkBlue = Color(0xFF17165C);

  final List<Map<String, dynamic>> profileOptions = const [
    {
      'title': 'My Trips',
      'subtitle': 'View your travel history',
      'icon': Icons.luggage_rounded,
    },
    {
      'title': 'Travel Preferences',
      'subtitle': 'Manage your travel interests',
      'icon': Icons.tune_rounded,
    },
    {
      'title': 'Safety Settings',
      'subtitle': 'Manage travel and privacy settings',
      'icon': Icons.shield_rounded,
    },
    {
      'title': 'Language',
      'subtitle': 'Change application language',
      'icon': Icons.language_rounded,
    },
    {
      'title': 'Notifications',
      'subtitle': 'Manage your notifications',
      'icon': Icons.notifications_none_rounded,
    },
    {
      'title': 'About TravelMind',
      'subtitle': 'Learn more about our application',
      'icon': Icons.info_outline_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FF),

      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            // PROFILE HEADER

            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    primary,
                    Color(0xFF7770E8),
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 43,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person_rounded,
                      size: 48,
                      color: primary,
                    ),
                  ),

                  SizedBox(height: 14),

                  Text(
                    'Traveller',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    'Welcome to TravelMind!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Account Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),

            const SizedBox(height: 14),

            ...profileOptions.map(
              (option) => _buildOption(
                context,
                option['title'] as String,
                option['subtitle'] as String,
                option['icon'] as IconData,
              ),
            ),

            const SizedBox(height: 15),

            // LOGOUT BUTTON

            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Logout will be connected to authentication later.',
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                ),
                label: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Center(
              child: Text(
                'TravelMind v1.0.0',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),

        leading: Container(
          height: 43,
          width: 43,
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: primary,
          ),
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: darkBlue,
            fontSize: 14,
          ),
        ),

        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 15,
          color: primary,
        ),

        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title will be implemented later.'),
            ),
          );
        },
      ),
    );
  }
}
