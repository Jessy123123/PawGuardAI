import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnimalListScreen extends StatelessWidget {
  const AnimalListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PawGuard AI – Animals')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('animals').snapshots(),
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
              final data = docs[index].data() as Map<String, dynamic>;

              final species = data['species'] ?? 'unknown';
              final status = data['status'] ?? 'unknown';

              final health = data['health'] as Map<String, dynamic>? ?? {};
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
