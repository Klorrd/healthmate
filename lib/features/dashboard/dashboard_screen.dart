import 'package:flutter/material.dart';
import 'package:healthmate/features/health_records/add_record_screen.dart';
import 'package:healthmate/features/health_records/records_list_screen.dart';
import 'package:provider/provider.dart';

import '../health_records/health_records_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HealthRecordsProvider>(context);

    // Filter todays records
    final today = DateTime.now();
    final todayString =
        "${today.year.toString().padLeft(4, '0')}-"
        "${today.month.toString().padLeft(2, '0')}-"
        "${today.day.toString().padLeft(2, '0')}";

    final todayRecords = provider.records
        .where((r) => r.date == todayString)
        .toList();

    // Calculate totals
    final totalWater = todayRecords.fold(0, (sum, r) => sum + r.water);
    final totalSteps = todayRecords.fold(0, (sum, r) => sum + r.steps);
    final totalCalories = todayRecords.fold(0, (sum, r) => sum + r.calories);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(title: const Text("HealthMate Dashboard")),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Summary",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 20),

                  // Summary Cards
                  _buildCard("Water Intake", "$totalWater ml", Colors.blue),
                  _buildCard("Steps", "$totalSteps steps", Colors.green),
                  _buildCard("Calories", "$totalCalories kcal", Colors.red),

                  const Spacer(),

                  // Buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AddRecordScreen()),
                        );
                      },
                      child: const Text("Add Record"),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RecordsListScreen(),
                          ),
                        );
                      },
                      child: const Text("View Records"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCard(String title, String value, Color color) {
    return Card(
      elevation: 2,
      color: const Color(0xFF2D2D2D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
