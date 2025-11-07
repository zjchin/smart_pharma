import 'package:flutter/material.dart';
import 'patient_history_page.dart';
import 'patient_verification_page.dart';
import 'feedback_page.dart'; // Import the new FeedbackPage

class PharmacistPage extends StatefulWidget {
  const PharmacistPage({super.key});

  @override
  State<PharmacistPage> createState() => _PharmacistPageState();
}

class _PharmacistPageState extends State<PharmacistPage> {
  // Mock data structure compatible with both downstream pages
  List<Map<String, dynamic>> toBeVerified = [
    {
      'ic': '900101-01-1234',
      'id': 'P-2001',
      'name': 'Patient A',
      'age': 55,
      'allergies': ['None'],
      'conditions': ['Fever, mild', 'Asthma'],
      'status': 'Stable',
      'treatmentPlan': [
        {'name': 'Antibiotic A', 'dosage': '3 per day'},
        {'name': 'Antibiotic B', 'dosage': '1 per day'},
      ],
      'treatmentHistory': [],
    },
    {
      'ic': '900202-02-5678',
      'id': 'P-2002',
      'name': 'Patient B',
      'age': 72,
      'allergies': ['Ibuprofen'],
      'conditions': ['High fever', 'Low BP', 'Renal Impairment'],
      'status': 'Emergency',
      'treatmentPlan': [
        {'name': 'Antibiotic C', 'dosage': '2 per day'},
        {'name': 'IV Fluids', 'dosage': '100ml/hr'},
      ],
      'treatmentHistory': [],
    },
  ];

  List<Map<String, dynamic>> verified = [];

  String searchToBeVerified = '';
  String searchVerified = '';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Pharmacist Verification Console",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blue.shade700,
          bottom: const TabBar(
            // Removed counts from tab titles
            indicatorColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            tabs: [
              Tab(text: "Verification Queue"), // Updated name
              Tab(text: "Treatment Plan History"), // Updated name
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPatientList(toBeVerified, true),
            _buildPatientList(verified, false),
          ],
        ),

        // --- User Feedback FAB ---
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to the FeedbackPage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FeedbackPage()),
            );
          },
          backgroundColor: Colors.orange.shade700,
          tooltip: 'Send Feedback',
          child: const Icon(Icons.flag, color: Colors.white), // Flag icon
        ),
        // -------------------------
      ),
    );
  }

  Widget _buildPatientList(
    List<Map<String, dynamic>> patients,
    bool isToBeVerified,
  ) {
    // Determine which search term to use
    final search = isToBeVerified ? searchToBeVerified : searchVerified;

    // Filter by IC
    final filtered = patients
        .where((p) => p['ic'].toLowerCase().contains(search.toLowerCase()))
        .toList();

    // Sort 'To Be Verified' list by status (Emergency first)
    if (isToBeVerified) {
      filtered.sort((a, b) {
        if (a['status'] == b['status']) return 0;
        if (a['status'] == 'Emergency') return -1;
        return 1;
      });
    }

    // Determine the onChanged callback for the TextField
    void Function(String)? onChangedCallback = (val) {
      setState(() {
        if (isToBeVerified) {
          searchToBeVerified = val;
        } else {
          searchVerified = val;
        }
      });
    };

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: onChangedCallback,
            decoration: InputDecoration(
              labelText: "Search by Patient IC",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.search),
              hintText: "Enter patient IC...",
            ),
          ),
        ),
        if (filtered.isEmpty)
          const Expanded(
            child: Center(
              child: Text(
                "No patients match the filter criteria.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final patient = filtered[index];
                final isEmergency = patient['status'] == 'Emergency';

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: isToBeVerified
                        ? Icon(
                            isEmergency
                                ? Icons.warning
                                : Icons.check_circle_outline,
                            color: isEmergency
                                ? Colors.red.shade700
                                : Colors.green.shade600,
                          )
                        : Icon(Icons.history, color: Colors.blue.shade600),
                    title: Text(
                      "${patient['name']} (IC: ${patient['ic']})",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: isToBeVerified
                        ? Text(
                            "Status: ${patient['status']} | Condition: ${patient['conditions'].join(', ')}",
                            style: TextStyle(
                              color: isEmergency
                                  ? Colors.red.shade700
                                  : Colors.black87,
                              fontWeight: isEmergency
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          )
                        : Text("Tap to view complete treatment history."),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                    onTap: () async {
                      if (isToBeVerified) {
                        // 1. Navigate to verification page
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PatientVerificationPage(patient: patient),
                          ),
                        );

                        // 2. If approved (result == true), move patient and return to THIS page.
                        if (result == true) {
                          // Log the success and update the list state
                          setState(() {
                            final index = toBeVerified.indexWhere(
                              (p) => p['ic'] == patient['ic'],
                            );
                            if (index != -1) {
                              final p = toBeVerified.removeAt(index);
                              verified.add(p);
                            }
                          });
                        }
                      } else {
                        // If in Verified tab, open patient history page to see the latest log
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PatientHistoryPage(patient: patient),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
