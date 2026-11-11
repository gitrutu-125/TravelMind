
import 'package:flutter/material.dart';

class SavedTripsScreen extends StatelessWidget {
  const SavedTripsScreen({super.key});

  static const Color primary = Color(0xFF5146C8);
  static const Color darkBlue = Color(0xFF17165C);

  // Temporary sample trips.
  // Later, we will load actual saved trips from PostgreSQL/Hive.
  final List<Map<String, dynamic>> sampleTrips = const [
    {
      'destination': 'Goa',
      'duration': '3 Days',
      'budget': '₹8,000',
      'icon': Icons.beach_access_rounded,
      'color': Color(0xFFFFE5D9),
    },
    {
      'destination': 'Manali',
      'duration': '5 Days',
      'budget': '₹12,000',
      'icon': Icons.landscape_rounded,
      'color': Color(0xFFDDEBFF),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FF),

      appBar: AppBar(
        title: const Text(
          'Saved Trips',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Your Travel Collection ✈️',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Keep your favourite travel plans in one place.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 25),

            if (sampleTrips.isEmpty)
              _buildEmptyState()
            else
              ...sampleTrips.map(
                (trip) => _buildTripCard(trip),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripCard(Map<String, dynamic> trip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(
              color: trip['color'],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              trip['icon'],
              color: darkBlue,
              size: 32,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip['destination'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  '${trip['duration']}  •  ${trip['budget']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: primary,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Icon(
            Icons.bookmark_border_rounded,
            size: 75,
            color: primary,
          ),
          SizedBox(height: 18),
          Text(
            'No Saved Trips Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Your saved itineraries will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
