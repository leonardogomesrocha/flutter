import 'package:flutter/material.dart';
import 'package:heart_bpm/heart_bpm.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int? heartBeat;
  bool isMeasuring = false;
  List<SensorValue> data = [];

  void startCameraMeasurement() {
    setState(() {
      isMeasuring = true;
      data.clear();
    });
  }

  void stopCameraMeasurement(int bpm) {
    setState(() {
      isMeasuring = false;
      heartBeat = bpm;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Heart Beat registrado: $bpm BPM'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text(
          'Main Page',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: const BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                ),
                SizedBox(height: 12),
                Text(
                  'Bem-vindo!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          if (isMeasuring)
            HeartBPMDialog(
              context: context,
              onRawData: (value) {
                setState(() {
                  data.add(value);
                });
              },
              onBPM: (value) {
                stopCameraMeasurement(value);
              },
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                if (heartBeat != null)
                  Text(
                    'Último BPM: $heartBeat',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.favorite),
                    label: const Text('Medir com a câmera'),
                    onPressed: startCameraMeasurement,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Card(
          child: ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }
}
