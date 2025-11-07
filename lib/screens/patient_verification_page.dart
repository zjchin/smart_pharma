import 'package:flutter/material.dart';

class PatientVerificationPage extends StatefulWidget {
  final Map<String, dynamic> patient;

  const PatientVerificationPage({super.key, required this.patient});

  @override
  State<PatientVerificationPage> createState() =>
      _PatientVerificationPageState();
}

class _PatientVerificationPageState extends State<PatientVerificationPage> {
  // We use a mutable list for the treatment plan to allow in-page editing
  late List<Map<String, dynamic>> treatmentPlan;

  @override
  void initState() {
    super.initState();
    // Deep copy the list so edits don't immediately affect the parent widget's state
    treatmentPlan = List<Map<String, dynamic>>.from(
      widget.patient['treatmentPlan'],
    );
  }

  // Function to handle opening the dosage edit dialog
  void _editDosage(Map<String, dynamic> med) {
    final controller = TextEditingController(text: med['dosage']);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "Edit ${med['name']} Dosage",
          style: TextStyle(color: Colors.blue.shade800),
        ),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: "New Dosage",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.text,
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                // Find the index of the drug being edited and update its dosage
                final index = treatmentPlan.indexWhere(
                  (element) => element['name'] == med['name'],
                );
                if (index != -1) {
                  treatmentPlan[index]['dosage'] = controller.text;
                }
              });
              Navigator.pop(context);
            },
            child: const Text("Save", style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  // Consolidated function to approve the plan, save to history, and signal success
  void _finalizePlan() {
    // 1. Create history entry details with the current, edited plan
    final historyEntry = {
      'date': DateTime.now().toString().split('.')[0], // Simple timestamp
      // Create a clean list of the final plan drugs
      'drugs': treatmentPlan
          .map((med) => {'name': med['name'], 'dosage': med['dosage']})
          .toList(),
    };

    // 2. Add this new entry to the patient's history list.
    widget.patient['treatmentHistory'].add(historyEntry);

    // 3. Navigate back and signal success (true) to the PharmacistPage
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.patient['name']} Verification",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Info Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name: ${widget.patient['name']} (Age: ${widget.patient['age']})",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Divider(height: 10),
                    Text(
                      "ID/IC: ${widget.patient['ic']}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      "Primary Condition: ${widget.patient['conditions'].join(', ')}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Current Treatment Plan:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Treatment Plan List
            Expanded(
              child: ListView.builder(
                itemCount: treatmentPlan.length,
                itemBuilder: (context, index) {
                  final med = treatmentPlan[index];
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.batch_prediction,
                        color: Colors.blue.shade400,
                      ),
                      title: Text(
                        med['name'],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text("Dosage: ${med['dosage']}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        tooltip: 'Edit Dosage',
                        onPressed: () => _editDosage(med),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Action Button
            Center(
              child: ElevatedButton.icon(
                onPressed: _finalizePlan,
                icon: const Icon(Icons.assignment_turned_in),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 30),
                  child: Text(
                    "Approve & Finalize Plan",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
