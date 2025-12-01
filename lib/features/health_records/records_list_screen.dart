import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/health_record.dart';
import './health_records_provider.dart';
import 'edit_record_screen.dart';

class RecordsListScreen extends StatefulWidget {
  const RecordsListScreen({super.key});

  @override
  State<RecordsListScreen> createState() => _RecordsListScreenState();
}

class _RecordsListScreenState extends State<RecordsListScreen> {
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HealthRecordsProvider>();
    final records = provider.records;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(title: const Text("Health Records")),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Select Date",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => _pickDate(context),
                  ),
                ),

                const SizedBox(width: 8),

                ElevatedButton(
                  onPressed: () {
                    if (_dateController.text.trim().isEmpty) return;
                    // Using context.read for method calls in callbacks
                    context.read<HealthRecordsProvider>().searchByDate(_dateController.text.trim());
                  },
                  child: const Text("Search"),
                ),

                const SizedBox(width: 8),

                OutlinedButton(
                  onPressed: () {
                    _dateController.clear();
                    // Using context.read for method calls in callbacks
                    context.read<HealthRecordsProvider>().loadAll();
                  },
                  child: const Text("Reset"),
                ),
              ],
            ),
          ),

          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : records.isEmpty
                ? const Center(
                    child: Text(
                      "No records found.",
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                  )
                : ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return _buildRecordItem(context, record);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final selected = _formatDate(picked);
      _dateController.text = selected;

      // Auto-search immediately after picking date
      // Using context.read for method calls in callbacks (no rebuild needed)
      context.read<HealthRecordsProvider>().searchByDate(selected);
    }
  }

  // Format date
  String _formatDate(DateTime d) {
    return "${d.year.toString().padLeft(4, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.day.toString().padLeft(2, '0')}";
  }

  // Record item UI is below
  Widget _buildRecordItem(
    BuildContext context,
    HealthRecord record,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      color: const Color(0xFF2D2D2D),
      child: ListTile(
        title: Text(
          record.date,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          "Steps: ${record.steps}\n"
          "Calories: ${record.calories}\n"
          "Water: ${record.water} ml",
          style: const TextStyle(color: Colors.white70),
        ),
        isThreeLine: true,

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditRecordScreen(record: record),
                  ),
                );
              },
            ),

            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                // Using context.read for method calls in callbacks
                await context.read<HealthRecordsProvider>().deleteRecord(record.id!);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Record deleted")));
              },
            ),
          ],
        ),
      ),
    );
  }
}
