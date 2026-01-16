import 'package:flutter/material.dart';
import 'package:flutter_app/services/metric_service.dart';
import 'package:flutter_app/services/auth_session.dart';
import 'package:flutter_app/pages/login_page.dart';
import '../models/TrainingZone.dart';
import '../components/TimeZoneComponent.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<TrainingZone> zones = [
    TrainingZone(value: 1, label: 'Very Little', color: Colors.blue),
    TrainingZone(value: 2, label: 'Little', color: Colors.green),
    TrainingZone(value: 3, label: 'Moderate', color: Colors.purple),
    TrainingZone(value: 4, label: 'Above', color: Colors.yellow),
    TrainingZone(value: 5, label: 'High', color: Colors.orange),
    TrainingZone(value: 6, label: 'Maximum', color: Colors.red),
  ];

  int? selectedZone;

  final _formKey = GlobalKey<FormState>();

  DateTime referenceDate = DateTime.now();
  int effort = 0;
  int heartBeat = 60;
  double weight = 70;
  double sleepTime = 8;
  int cmj = 0;
  int imtp = 0;
  int pushUp = 0;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: referenceDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        referenceDate = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final payload = {
        "referenceDate": referenceDate.toIso8601String(),
        "effort": effort,
        "heartBeat": heartBeat,
        "weight": weight,
        "sleepTime": sleepTime,
        "cmj": cmj,
        "imtp": imtp,
        "pushUp": pushUp,
      };

      debugPrint(payload.toString());

      final snackBarMessenger = ScaffoldMessenger.of(context);

      try {
        // Call the TrainingMetricService
        final service = TrainingMetricService();
        final result = await service.createTrainingMetric(
          referenceDate: referenceDate,
          effort: effort,
          heartBeat: heartBeat,
          weight: weight.toDouble(),
          sleepTime: sleepTime.toDouble(),
        );

        debugPrint('Metric saved: $result');

        // Success message
        snackBarMessenger.showSnackBar(
          const SnackBar(
            content: Text('Metrics saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        // Error message
        snackBarMessenger.showSnackBar(
          SnackBar(
            content: Text('Failed to save data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text(
          'Daily Metrics',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// DATE
              Text('Date', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  child: Text(DateFormat('dd/MM/yyyy').format(referenceDate)),
                ),
              ),

              const SizedBox(height: 20),

              /// EFFORT
              Text('Borg Scale (0–10)'),
              Slider(
                value: effort.toDouble(),
                min: 0,
                max: 10,
                divisions: 10,
                label: effort.toString(),
                onChanged: (value) {
                  setState(() {
                    effort = value.round();
                  });
                },
              ),

              const SizedBox(height: 20),

              // Inject your ZoneSelector here
              ZoneSelector(
                zones: zones, // your list of TrainingZone
                selectedZone: selectedZone, // currently selected value
                onSelected: (value) {
                  // callback when user taps a zone
                  setState(() {
                    selectedZone = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              /// HEART BEAT
              TextFormField(
                initialValue: heartBeat.toString(),
                decoration: InputDecoration(
                  labelText: 'Heart Rate (20–250 BPM)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blueAccent,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final v = int.tryParse(value ?? '');
                  if (v == null || v < 30 || v > 250) {
                    return 'Value must be between 30 and 250';
                  }
                  return null;
                },

                onSaved: (value) {
                  heartBeat = int.parse(value!);
                },
              ),

              const SizedBox(height: 20),

              /// WEIGHT
              TextFormField(
                initialValue: weight.toString(),
                decoration:  InputDecoration(
                  labelText: 'Weight (kg – max 300)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blueAccent,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final v = double.tryParse(value ?? '');
                  if (v == null || v < 0 || v > 300) {
                    return 'Invalid weight';
                  }
                  return null;
                },
                onSaved: (value) {
                  weight = double.parse(value!);
                },
              ),

              const SizedBox(height: 20),

              /// SLEEP TIME
              TextFormField(
                initialValue: sleepTime.toString(),
                decoration: InputDecoration(
                  labelText: 'Sleep hours (0–24)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blueAccent,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final v = double.tryParse(value ?? '');
                  if (v == null || v < 0 || v > 24) {
                    return 'Value must be between 0 and 24';
                  }
                  return null;
                },
                onSaved: (value) {
                  sleepTime = double.parse(value!);
                },
              ),

              const SizedBox(height: 20),

              /// CMJ
              TextFormField(
                initialValue: cmj.toString(),
                decoration:  InputDecoration(
                  labelText: 'CMJ (0–100)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blueAccent,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final v = int.tryParse(value ?? '');
                  if (v == null || v < 0 || v > 100)
                    return 'CMJ must be between 0 and 100';
                  return null;
                },
                onSaved: (value) {
                  cmj = int.parse(value!);
                },
              ),

              const SizedBox(height: 20),

              /// IMTP
              TextFormField(
                initialValue: imtp.toString(),
                decoration:  InputDecoration(
                  labelText: 'IMTP (0–100)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blueAccent,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final v = int.tryParse(value ?? '');
                  if (v == null || v < 0 || v > 100)
                    return 'IMTP must be between 0 and 100';
                  return null;
                },
                onSaved: (value) {
                  imtp = int.parse(value!);
                },
              ),

              const SizedBox(height: 20),

              /// Push Up
              TextFormField(
                initialValue: pushUp.toString(),
                decoration:  InputDecoration(
                  labelText: 'Push Up (0–100)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blueAccent,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final v = int.tryParse(value ?? '');
                  if (v == null || v < 0 || v > 100)
                    return 'Push Up must be between 0 and 100';
                  return null;
                },
                onSaved: (value) {
                  pushUp = int.parse(value!);
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Card(
          child: ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: () async {
              // Show confirmation dialog
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Logout'),
                  content: const Text('Are you sure you want to log out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false), // cancel
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true), // confirm
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
              // If user confirmed, logout
              if (shouldLogout ?? false) {
                AuthSession().clear();

                // Navigate to login page and remove all previous routes
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthenticationScreen(),
                  ),
                  (route) => false,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
