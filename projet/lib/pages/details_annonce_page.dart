import 'package:flutter/material.dart'; 
import '../models/logement.dart';

class DetailsAnnoncePage extends StatelessWidget {
  final Logement logement;

  DetailsAnnoncePage({required this.logement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(logement.titre),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  logement.imageUrl,
                  height: 300,  
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              // Affichage du titre de l'annonce
              Text(
                logement.titre,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Prix : ${logement.prix} AR',
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
              SizedBox(height: 8),
              Text(
                'Ville : ${logement.ville}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                logement.description,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Publié le : ${logement.datePublication}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



