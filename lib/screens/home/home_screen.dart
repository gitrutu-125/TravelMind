
import 'package:flutter/material.dart';

import '../saved/saved_trips_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color primary = Color(0xFF5146C8);
  static const Color darkBlue = Color(0xFF17165C);
  static const Color background = Color(0xFFF8F8FF);

  int selectedIndex = 0;

  final TextEditingController searchController =
      TextEditingController();

  final List<Map<String, dynamic>> destinations = [
    {
      'name': 'Goa',
      'subtitle': 'Beaches & Adventure',
      'image':
          'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=700',
    },
    {
      'name': 'Manali',
      'subtitle': 'Mountains & Nature',
      'image':
          'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=700',
    },
    {
      'name': 'Jaipur',
      'subtitle': 'Culture & Heritage',
      'image':
          'https://images.unsplash.com/photo-1599661046827-dacff0c0f09a?w=700',
    },
    {
      'name': 'Kerala',
      'subtitle': 'Nature & Backwaters',
      'image':
          'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=700',
    },
  ];

  final List<Map<String, dynamic>> features = [
    {
      'title': 'AI Trip Planner',
      'subtitle': 'Create your perfect trip',
      'icon': Icons.map_rounded,
      'color': Color(0xFF5146C8),
      'screen': 'AI Trip Planner',
    },
    {
      'title': 'Mood Planner',
      'subtitle': 'Travel with your mood',
      'icon': Icons.mood_rounded,
      'color': Color(0xFFE6A23C),
      'screen': 'Mood-Based Planner',
    },
    {
      'title': 'Companionship',
      'subtitle': 'Find travel buddies',
      'icon': Icons.groups_rounded,
      'color': Color(0xFF3985D9),
      'screen': 'AI Companionship',
    },
    {
      'title': 'Packing Assistant',
      'subtitle': 'Pack smartly with AI',
      'icon': Icons.luggage_rounded,
      'color': Color(0xFF269C85),
      'screen': 'AI Packing Assistant',
    },
    {
      'title': '360° View',
      'subtitle': 'Explore places virtually',
      'icon': Icons.threesixty_rounded,
      'color': Color(0xFF299BC8),
      'screen': '360° Destination View',
    },
    {
      'title': 'Traffic Map',
      'subtitle': 'Discover better routes',
      'icon': Icons.traffic_rounded,
      'color': Color(0xFFE45B69),
      'screen': 'Traffic Detection',
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void openFeature(String screenName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FeaturePlaceholderScreen(
          title: screenName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildHomePage(),
      const SavedTripsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: background,

      body: SafeArea(
        child: pages[selectedIndex],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
        ),
        elevation: 12,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_rounded),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // HOME PAGE
  // ==========================================================

  Widget buildHomePage() {
    final filteredDestinations = destinations.where((destination) {
      return destination['name']
          .toString()
          .toLowerCase()
          .contains(searchController.text.trim().toLowerCase());
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ==================================================
          // WELCOME HEADER
          // ==================================================

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hello, Traveller! 👋',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Ready for your next adventure?',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = 2;
                  });
                },
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFE9E6FF),
                        Color(0xFFD8D3FF),
                      ],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: primary,
                    size: 27,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          // ==================================================
          // SEARCH BAR
          // ==================================================

          const Text(
            'Where do you want to go?',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: searchController,
            onChanged: (_) {
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: 'Search Goa, Manali, Jaipur...',
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 13,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: primary,
              ),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () {
                        searchController.clear();
                        setState(() {});
                      },
                    )
                  : const Icon(
                      Icons.tune_rounded,
                      color: primary,
                    ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 17,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Colors.grey.shade200,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: primary,
                  width: 1.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          // ==================================================
          // AI TRIP PLANNER BANNER
          // ==================================================

          Container(
            width: double.infinity,
            height: 270,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=1000',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: primary,
                      );
                    },
                  ),

                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF17165C)
                              .withValues(alpha: 0.95),
                          const Color(0xFF5146C8)
                              .withValues(alpha: 0.65),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_awesome_rounded,
                                color: Colors.white,
                                size: 15,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'AI POWERED TRAVEL',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          'Plan Your Dream Trip!',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Discover amazing places and create '
                          'your personalized travel itinerary.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 16),

                        ElevatedButton(
                          onPressed: () {
                            openFeature('AI Trip Planner');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 19,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Start Planning',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // ==================================================
          // FEATURES SECTION
          // ==================================================

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Explore TravelMind',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFECEAFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '6 Features',
                  style: TextStyle(
                    fontSize: 11,
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: features.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 13,
              mainAxisSpacing: 13,
              childAspectRatio: 1.12,
            ),
            itemBuilder: (context, index) {
              final feature = features[index];
              final Color featureColor = feature['color'];

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    openFeature(feature['screen']);
                  },
                  child: Ink(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          featureColor.withValues(alpha: 0.15),
                          Colors.white,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: featureColor.withValues(alpha: 0.18),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: featureColor.withValues(alpha: 0.07),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            color: featureColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            feature['icon'],
                            color: featureColor,
                            size: 26,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          feature['title'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: darkBlue,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          feature['subtitle'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 30),

          // ==================================================
          // POPULAR DESTINATIONS
          // ==================================================

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Popular Destinations',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),

              TextButton(
                onPressed: () {
                  searchController.clear();
                  setState(() {});
                },
                child: const Text(
                  'View all',
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          if (filteredDestinations.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: Center(
                child: Text(
                  'No destinations found.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            SizedBox(
              height: 205,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filteredDestinations.length,
                itemBuilder: (context, index) {
                  final destination = filteredDestinations[index];

                  return Container(
                    width: 175,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            destination['image'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFFDDEBFF),
                                child: const Icon(
                                  Icons.landscape_rounded,
                                  size: 50,
                                  color: primary,
                                ),
                              );
                            },
                          ),

                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Color(0xDD000000),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  destination['name'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  destination['subtitle'],
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                  ),
                                ),

                                const SizedBox(height: 9),

                                const Row(
                                  children: [
                                    Text(
                                      'Explore destination',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                openFeature(
                                  '${destination['name']} Destination',
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

          const SizedBox(height: 25),

          // ==================================================
          // BOTTOM MOTIVATION CARD
          // ==================================================

          Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: const Color(0xFFECEAFF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.explore_rounded,
                  color: primary,
                  size: 35,
                ),

                SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Adventure is calling!',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: darkBlue,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Explore new places and make memories.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF666480),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// PLACEHOLDER FEATURE SCREEN
// ==========================================================

class FeaturePlaceholderScreen extends StatelessWidget {
  final String title;

  const FeaturePlaceholderScreen({
    super.key,
    required this.title,
  });

  static const Color primary = Color(0xFF5146C8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FF),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF17165C),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.construction_rounded,
                size: 65,
                color: primary,
              ),

              const SizedBox(height: 20),

              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'This feature will be developed in the '
                'upcoming TravelMind development phase.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
