import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Information'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section: How to Use the App
              const Text(
                'How to Use This App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '1. Login or Register: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          'Start by logging in with your credentials or registering a new account if you are a first-time user.',
                    ),
                  ],
                ),
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '2. Update Your Profile: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          'Complete your profile with accurate details to ensure proper reporting and tracking.',
                    ),
                  ],
                ),
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '3. Report Malaria Cases: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          'Navigate to the "Malaria Cases" tab to report new cases or view existing reports.',
                    ),
                  ],
                ),
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '4. Volunteer: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          'Use the "Volunteers" tab to manage or view volunteer activities.',
                    ),
                  ],
                ),
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '5. Access Information: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          'Visit the "Info" tab (this screen) to learn more about malaria and how to use the app effectively.',
                    ),
                  ],
                ),
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),

              // Section: Malaria Information
              const Text(
                'About Malaria',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Malaria is a life-threatening disease caused by parasites that are transmitted to people through the bites of infected female Anopheles mosquitoes.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Symptoms:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '- Fever\n- Chills\n- Headache\n- Nausea and vomiting\n- Muscle pain and fatigue',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Prevention:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '- Use insect repellent\n- Sleep under insecticide-treated bed nets\n- Wear protective clothing\n- Take antimalarial medication if traveling to high-risk areas',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Treatment:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Malaria can be treated with prescription drugs. The type of medication and length of treatment depend on the type of malaria, the severity of the disease, and the patient’s age and health condition.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
