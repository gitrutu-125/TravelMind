
import 'package:flutter/material.dart';
import 'package:trip_planner/l10n/app_localizations.dart';

import '../../services/api_service.dart';
import 'itinerary_result_screen.dart';

class TripPlanningScreen extends StatefulWidget {
  const TripPlanningScreen({super.key});

  @override
  State<TripPlanningScreen> createState() =>
      _TripPlanningScreenState();
}

class _TripPlanningScreenState extends State<TripPlanningScreen> {
  static const Color primary = Color(0xFF5146C8);
  static const Color darkBlue = Color(0xFF17165C);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController startingController =
      TextEditingController();

  final TextEditingController destinationController =
      TextEditingController();

  final TextEditingController budgetController =
      TextEditingController();

  // API service
  final ApiService apiService = ApiService();

  // Loading state
  bool isGenerating = false;

  DateTime? selectedDate;
  int numberOfDays = 3;
  int travellers = 1;
  String travelStyle = 'Adventure';

  final List<String> interests = [
    'Nature',
    'Adventure',
    'Beaches',
    'Culture',
    'Food',
    'Shopping',
  ];

  final Set<String> selectedInterests = {};

  @override
  void dispose() {
    startingController.dispose();
    destinationController.dispose();
    budgetController.dispose();
    super.dispose();
  }

  Future<void> chooseDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(
        const Duration(days: 1),
      ),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Generate trip and connect with FastAPI
 
  Future<void> generateTrip() async {
  if (isGenerating) return;

  if (!_formKey.currentState!.validate()) {
    return;
  }

  if (selectedDate == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select your travel date.'),
      ),
    );
    return;
  }

  if (selectedInterests.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select at least one interest.'),
      ),
    );
    return;
  }

  final tripData = {
    'starting_location': startingController.text.trim(),
    'destination': destinationController.text.trim(),
    'travel_date':
        selectedDate!.toIso8601String().split('T').first,
    'number_of_days': numberOfDays,
    'travellers': travellers,
    'budget': double.parse(budgetController.text.trim()),
    'travel_style': travelStyle,
    'interests': selectedInterests.toList(),
  };

  debugPrint('Sending Trip Data: $tripData');

  setState(() {
    isGenerating = true;
  });

  try {
    // Send trip details to FastAPI.
    final response = await apiService.post(
      '/trips/generate',
      tripData,
    );

    if (!mounted) return;

    debugPrint('Backend Response: $response');

    // Extract the itinerary from the response.
    final itineraryData = response['itinerary'];

    if (itineraryData is! Map) {
      throw Exception(
        'The server did not return a valid itinerary.',
      );
    }

    final itinerary = Map<String, dynamic>.from(
      itineraryData,
    );

    // Open the itinerary result screen.
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItineraryResultScreen(
          itinerary: itinerary,
        ),
      ),
    );
  } catch (e) {
    if (!mounted) return;

    debugPrint('Trip Generation Error: $e');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString().replaceFirst('Exception: ', ''),
        ),
        backgroundColor: Colors.red,
      ),
    );
  } finally {
    if (mounted) {
      setState(() {
        isGenerating = false;
      });
    }
  }
}


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FF),
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(l10n.aiTripPlanner),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Plan Your Dream Trip ✈️',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Enter your preferences and let TravelMind '
                'help you plan your journey.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 25),

              _sectionTitle('Travel Details'),

              _buildTextField(
                controller: startingController,
                label: 'Starting Location',
                hint: 'Enter your starting city',
                icon: Icons.my_location,
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: destinationController,
                label: 'Destination',
                hint: 'Where do you want to go?',
                icon: Icons.location_on_outlined,
              ),

              const SizedBox(height: 16),

              _sectionTitle('Travel Date'),

              InkWell(
                onTap: chooseDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Select Travel Date',
                    prefixIcon: const Icon(
                      Icons.calendar_month,
                      color: primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  child: Text(
                    selectedDate == null
                        ? 'Choose your travel date'
                        : '${selectedDate!.day}/'
                            '${selectedDate!.month}/'
                            '${selectedDate!.year}',
                  ),
                ),
              ),

              const SizedBox(height: 22),

              _sectionTitle('Trip Duration'),

              DropdownButtonFormField<int>(
                initialValue: numberOfDays,
                decoration: InputDecoration(
                  labelText: 'Number of Days',
                  prefixIcon: const Icon(
                    Icons.calendar_today,
                    color: primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: List.generate(
                  15,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('${index + 1} Days'),
                  ),
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      numberOfDays = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 22),

              _sectionTitle('Travellers'),

              DropdownButtonFormField<int>(
                initialValue: travellers,
                decoration: InputDecoration(
                  labelText: 'Number of Travellers',
                  prefixIcon: const Icon(
                    Icons.people_outline,
                    color: primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: List.generate(
                  10,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('${index + 1} Traveller(s)'),
                  ),
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      travellers = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 22),

              _sectionTitle('Your Budget'),

              _buildTextField(
                controller: budgetController,
                label: 'Total Budget (₹)',
                hint: 'Example: 10000',
                icon: Icons.currency_rupee,
                keyboardType: TextInputType.number,
                isNumber: true,
              ),

              const SizedBox(height: 22),

              _sectionTitle('Travel Style'),

              DropdownButtonFormField<String>(
                initialValue: travelStyle,
                decoration: InputDecoration(
                  labelText: 'Choose Travel Style',
                  prefixIcon: const Icon(
                    Icons.explore_outlined,
                    color: primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: [
                  'Adventure',
                  'Relaxation',
                  'Luxury',
                  'Budget',
                  'Family',
                  'Solo',
                ].map((style) {
                  return DropdownMenuItem(
                    value: style,
                    child: Text(style),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      travelStyle = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 22),

              _sectionTitle('Your Interests'),

              const Text(
                'Select the activities you enjoy.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: interests.map((interest) {
                  final selected =
                      selectedInterests.contains(interest);

                  return FilterChip(
                    label: Text(interest),
                    selected: selected,
                    selectedColor: primary.withValues(alpha: 0.15),
                    checkmarkColor: primary,
                    onSelected: (value) {
                      setState(() {
                        if (value) {
                          selectedInterests.add(interest);
                        } else {
                          selectedInterests.remove(interest);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed:
                      isGenerating ? null : generateTrip,

                  icon: isGenerating
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.auto_awesome),

                  label: Text(
                    isGenerating
                        ? 'Sending Details...'
                        : 'Generate My Trip',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: darkBlue,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $label';
        }

        if (isNumber) {
          final amount = double.tryParse(value.trim());

          if (amount == null || amount <= 0) {
            return 'Please enter a valid budget';
          }
        }

        return null;
      },
    );
  }
}
