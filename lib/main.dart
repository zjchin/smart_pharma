import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Pharma',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PatientFormPage(),
    );
  }
}

class PatientFormPage extends StatefulWidget {
  const PatientFormPage({super.key});

  @override
  State<PatientFormPage> createState() => _PatientFormPageState();
}

class _PatientFormPageState extends State<PatientFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _medsController = TextEditingController();

  String _recommendationText = '';

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _symptomsController.dispose();
    _medsController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final age = int.tryParse(_ageController.text.trim()) ?? 0;
    final weight = double.tryParse(_weightController.text.trim());
    final symptoms = _symptomsController.text.trim();
    final meds = _medsController.text.trim();

    setState(() {
      _recommendationText =
          "✅ Patient Data Received:\n"
          "Age: $age years\n"
          "Weight: ${weight != null ? "$weight kg" : "N/A"}\n"
          "Symptoms: $symptoms\n"
          "Meds/Allergies: ${meds.isNotEmpty ? meds : "None"}\n\n"
          "⚠ Recommendation: (AI Model Placeholder)\n"
          "Example: Review antibiotic allergy risk before prescribing.\n";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Pharma Input')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Age required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _weightController,
                      decoration: const InputDecoration(
                        labelText: 'Weight (kg)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _symptomsController,
                      decoration: const InputDecoration(
                        labelText: 'Symptoms',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _medsController,
                      decoration: const InputDecoration(
                        labelText: 'Medications / Allergies (optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: _handleSubmit,
                      child: const Text("Get Recommendation"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_recommendationText.isNotEmpty)
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(_recommendationText),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
