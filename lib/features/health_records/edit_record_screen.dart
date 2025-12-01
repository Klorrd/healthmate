import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/health_record.dart';
import './health_records_provider.dart';

class EditRecordScreen extends StatefulWidget {
  final HealthRecord record;

  const EditRecordScreen({super.key, required this.record});

  @override
  State<EditRecordScreen> createState() => _EditRecordScreenState();
}

class _EditRecordScreenState extends State<EditRecordScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _dateController;
  late TextEditingController _stepsController;
  late TextEditingController _caloriesController;
  late TextEditingController _waterController;

  @override
  void initState() {
    super.initState();

    // Preload existing values
    _dateController = TextEditingController(text: widget.record.date);
    _stepsController =
        TextEditingController(text: widget.record.steps.toString());
    _caloriesController =
        TextEditingController(text: widget.record.calories.toString());
    _waterController =
        TextEditingController(text: widget.record.water.toString());
  }

  // Format date 
  String _formatDate(DateTime d) {
    return "${d.year.toString().padLeft(4, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.day.toString().padLeft(2, '0')}";
  }

  // Open DatePicker
  Future<void> _pickDate(BuildContext context) async {
    final initialDate = DateTime.tryParse(_dateController.text) ??
        DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      _dateController.text = _formatDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Health Record"),
      ),

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
                validator: (v) =>
                    v == null || v.isEmpty ? "Date is required" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _stepsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Steps",
                  border: OutlineInputBorder(),
                ),
                validator: _validate,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Calories",
                  border: OutlineInputBorder(),
                ),
                validator: _validate,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _waterController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Water Intake (ml)",
                  border: OutlineInputBorder(),
                ),
                validator: _validate,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final updated = HealthRecord(
                        id: widget.record.id,
                        date: _dateController.text.trim(),
                        steps: int.parse(_stepsController.text.trim()),
                        calories: int.parse(_caloriesController.text.trim()),
                        water: int.parse(_waterController.text.trim()),
                      );

                      await context.read<HealthRecordsProvider>().updateRecord(updated);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Record updated successfully!"),
                        ),
                      );

                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Update Record"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validate(String? v) {
    if (v == null || v.isEmpty) return "This field is required";
    if (int.tryParse(v) == null) return "Enter a valid number";
    return null;
  }
}