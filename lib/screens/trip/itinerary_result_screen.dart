
import 'package:flutter/material.dart';

class ItineraryResultScreen extends StatelessWidget {
  final Map<String, dynamic> itinerary;

  const ItineraryResultScreen({
    super.key,
    required this.itinerary,
  });

  static const Color primary = Color(0xFF5146C8);
  static const Color darkBlue = Color(0xFF17165C);
  static const Color background = Color(0xFFF8F8FF);

  String _formatDate(dynamic value) {
    if (value == null) return 'Not available';

    final parsedDate = DateTime.tryParse(value.toString());

    if (parsedDate == null) return value.toString();

    return '${parsedDate.day.toString().padLeft(2, '0')}/'
        '${parsedDate.month.toString().padLeft(2, '0')}/'
        '${parsedDate.year}';
  }

  String _formatAmount(dynamic value) {
    final amount = double.tryParse(value.toString()) ?? 0;
    return '₹${amount.toStringAsFixed(0)}';
  }

  Map<String, dynamic> _toMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    final dailyPlan = itinerary['daily_plan'] is List
        ? itinerary['daily_plan'] as List
        : [];

    final budgetPlan = _toMap(itinerary['budget_plan']);
    final allocation = _toMap(budgetPlan['allocation']);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Your Trip Itinerary'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip heading
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [primary, darkBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.flight_takeoff,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    itinerary['title']?.toString() ?? 'Your Trip',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _headerInfo(
                    Icons.location_on_outlined,
                    'From: ${itinerary['starting_location'] ?? '-'}',
                  ),
                  const SizedBox(height: 7),
                  _headerInfo(
                    Icons.flag_outlined,
                    'To: ${itinerary['destination'] ?? '-'}',
                  ),
                  const SizedBox(height: 7),
                  _headerInfo(
                    Icons.calendar_month,
                    '${_formatDate(itinerary['travel_date'])} - '
                    '${_formatDate(itinerary['return_date'])}',
                  ),
                  const SizedBox(height: 7),
                  _headerInfo(
                    Icons.people_outline,
                    '${itinerary['travellers'] ?? 1} Traveller(s)',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Daily itinerary
            const Text(
              'Your Day-wise Plan',
              style: TextStyle(
                color: darkBlue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            if (dailyPlan.isEmpty)
              const Text('No daily activities are available.')
            else
              ...dailyPlan.map((item) {
                final day = _toMap(item);
                return _buildDayCard(day);
              }),

            const SizedBox(height: 25),

            // Budget section
            const Text(
              'Estimated Budget Breakdown',
              style: TextStyle(
                color: darkBlue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: primary.withValues(alpha: 0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Trip Budget',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _formatAmount(budgetPlan['total_budget']),
                    style: const TextStyle(
                      color: primary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    budgetPlan['budget_scope']?.toString() ??
                        'Estimated budget',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                  const Divider(height: 28),

                  _budgetRow(
                    'Accommodation',
                    allocation['accommodation'],
                    Icons.hotel_outlined,
                  ),
                  _budgetRow(
                    'Food',
                    allocation['food'],
                    Icons.restaurant_outlined,
                  ),
                  _budgetRow(
                    'Transport',
                    allocation['transport'],
                    Icons.directions_bus_outlined,
                  ),
                  _budgetRow(
                    'Activities & Other',
                    allocation['activities_and_other'],
                    Icons.local_activity_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Important note
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.orange.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.deepOrange,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      itinerary['important_note']?.toString() ??
                          'Activity suggestions and budget amounts are '
                              'estimates. Verify details before travelling.',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Back button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Trip Planning'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primary,
                  side: const BorderSide(color: primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _headerInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayCard(Map<String, dynamic> day) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: primary.withValues(alpha: 0.13),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Day ${day['day'] ?? '-'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  day['theme']?.toString() ?? 'Activities',
                  style: const TextStyle(
                    color: darkBlue,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          Text(
            _formatDate(day['date']),
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
            ),
          ),

          const Divider(height: 25),

          _activityRow(
            Icons.wb_sunny_outlined,
            'Morning',
            day['morning'],
          ),

          _activityRow(
            Icons.wb_twilight,
            'Afternoon',
            day['afternoon'],
          ),

          _activityRow(
            Icons.nights_stay_outlined,
            'Evening',
            day['evening'],
          ),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: primary,
                  size: 19,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    day['travel_tip']?.toString() ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      color: darkBlue,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _activityRow(
    IconData icon,
    String title,
    dynamic description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description?.toString() ?? 'No activity available.',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _budgetRow(
    String title,
    dynamic amount,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Row(
        children: [
          Icon(icon, color: primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            _formatAmount(amount),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),
        ],
      ),
    );
  }
}
