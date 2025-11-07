import 'package:flutter/material.dart';

class PatientHistoryPage extends StatelessWidget {
  final Map<String, dynamic> patient;

  const PatientHistoryPage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    // Safely cast the list from the patient map. History entries are now batches.
    final history = patient['treatmentHistory'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${patient['name']}'s Verification History",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
      ),
      body: history.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_late_outlined,
                      size: 50,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "No verified history entries yet.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                // Reverse list so newest entries are first
                final reversedIndex = history.length - 1 - index;
                final historyEntry = history[reversedIndex];

                final String dateString = historyEntry['date'].toString();
                final List<dynamic> drugs =
                    historyEntry['drugs'] as List<dynamic>;

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    leading: Icon(
                      Icons.check_circle,
                      color: Colors.green.shade600,
                    ),
                    title: Text(
                      "Verification Log: ${dateString.split(' ')[0]}",
                    ),
                    subtitle: Text(
                      "Verified: ${dateString.split(' ')[1]} | Drugs: ${drugs.length}",
                    ),
                    childrenPadding: const EdgeInsets.only(
                      left: 20,
                      right: 16,
                      bottom: 8,
                    ),
                    children: [
                      // List the drugs verified in this batch
                      ...drugs
                          .map(
                            (drug) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    drug['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    drug['dosage'],
                                    style: TextStyle(
                                      color: Colors.blue.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      const Divider(height: 10),
                      Text(
                        'Verification done by Pharmacist on: $dateString',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
