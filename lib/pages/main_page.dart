import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/services/metric_service.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _formKey = GlobalKey<FormState>();

  DateTime referenceDate = DateTime.now();
  int effort = 0;
  int heartBeat = 60;
  double weight = 70;
  double sleepTime = 8;

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
          weight: weight.toInt(),
          sleepTime: sleepTime.toInt(),
        );

        debugPrint('Metric saved: $result');

        // Success message
        snackBarMessenger.showSnackBar(
          const SnackBar(
            content: Text('Data saved successfully'),
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
              Text(
                'Date',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(referenceDate),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// EFFORT
              Text('Effort (0–10)'),
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

              /// HEART BEAT
              TextFormField(
                initialValue: heartBeat.toString(),
                decoration: const InputDecoration(
                  labelText: 'Heart Rate (30–250 BPM)',
                  border: OutlineInputBorder(),
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
                decoration: const InputDecoration(
                  labelText: 'Weight (kg – max 300)',
                  border: OutlineInputBorder(),
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
                decoration: const InputDecoration(
                  labelText: 'Sleep hours (0–24)',
                  border: OutlineInputBorder(),
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
            onTap: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }
}

