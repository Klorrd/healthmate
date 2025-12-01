import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/health_record.dart';
import './health_records_provider.dart';

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({super.key});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _dateController = TextEditingController();
  final _stepsController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _waterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(DateTime.now()); // Default is today
  }

  // Format a DateTime to yyyy-MM-dd
  String _formatDate(DateTime d) {
    return "${d.year.toString().padLeft(4, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.day.toString().padLeft(2, '0')}";
  }

  // Date Picker
  Future<void> _pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final firstDate = DateTime(2000);
    final lastDate = DateTime(2100);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      _dateController.text = _formatDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Health Record")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Date",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _pickDate(context),
                validator: (value) =>
                    value == null || value.isEmpty ? "Date is required" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _stepsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Steps",
                  border: OutlineInputBorder(),
                ),
                validator: _validateNumber,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Calories",
                  border: OutlineInputBorder(),
                ),
                validator: _validateNumber,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _waterController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Water Intake (ml)",
                  border: OutlineInputBorder(),
                ),
                validator: _validateNumber,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final newRecord = HealthRecord(
                        date: _dateController.text.trim(),
                        steps: int.parse(_stepsController.text.trim()),
                        calories: int.parse(_caloriesController.text.trim()),
                        water: int.parse(_waterController.text.trim()),
                      );

                      await context.read<HealthRecordsProvider>().addRecord(newRecord);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Record added successfully!"),
                        ),
                      );

                      // Go back after saving
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Save Record"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // VALIDATION FOR NUMBER FIELDS
  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required";
    }
    if (int.tryParse(value) == null) {
      return "Enter a valid number";
    }
    return null;
  }
}
