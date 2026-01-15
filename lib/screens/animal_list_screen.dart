import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/cctv_simulator.dart';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({super.key});

  @override
  State<AnimalListScreen> createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  final _cctvSimulator = CctvSimulator();

  @override
  void initState() {
    super.initState();
    _cctvSimulator.start(); // Start simulated CCTV
  }

  @override
  void dispose() {
    _cctvSimulator.stop(); // Stop CCTV when screen closes
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PawGuard AI – Animals'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('animals')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No animals found'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data =
                  docs[index].data() as Map<String, dynamic>;

              final species = data['species'] ?? 'unknown';
              final status = data['status'] ?? 'unknown';

              final health =
                  data['health'] as Map<String, dynamic>? ?? {};
              final vaccinated = health['vaccinated'] ?? false;
              final neutered = health['neutered'] ?? false;

              final verified = data['verifiedByNGO'] == true;

              return ListTile(
                leading: const Icon(Icons.pets),
                title: Text(
                  species,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Status: $status • '
                  'Vaccinated: $vaccinated • '
                  'Neutered: $neutered',
                ),
                trailing: verified
                    ? const Icon(Icons.verified, color: Colors.green)
                    : const Icon(Icons.help_outline),
              );
            },
          );
        },
      ),
    );
  }
}
