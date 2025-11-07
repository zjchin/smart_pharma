import 'package:flutter/material.dart';

class PatientHistoryPage extends StatelessWidget {
  final Map<String, dynamic> patient;
  const PatientHistoryPage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${patient['name']} History")),
      body: ListView.builder(
        itemCount: patient['history'].length,
        itemBuilder: (context, index) {
          final plan = patient['history'][index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ExpansionTile(
              title: Text("Verified on: ${plan['verifiedDate']}"),
              children: plan['treatmentPlan']
                  .map<Widget>(
                    (med) => ListTile(
                      title: Text(med['name']),
                      subtitle: Text(med['dosage']),
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
