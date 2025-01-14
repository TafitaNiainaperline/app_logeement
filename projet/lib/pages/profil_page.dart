import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  String userId = "";
  String nom = "";
  String telephone = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? "";
      nom = prefs.getString('nom') ?? "Nom inconnu";
      telephone = prefs.getString('telephone') ?? "Téléphone inconnu";
    });
  }

  Future<void> _deconnexion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _supprimerCompte() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmer la suppression"),
          content: Text("Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Annuler"),
            ),
            TextButton(
              onPressed: () async {
                final response = await http.delete(
                  Uri.parse('https://votre-api.com/utilisateur/$userId'),
                  headers: <String, String>{
                    'Content-Type': 'application/json',
                  },
                );

                if (response.statusCode == 200) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  Navigator.pushReplacementNamed(context, '/login');
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Erreur"),
                        content: Text('Échec de la suppression du compte'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Fermer'),
                          ),
                        ],
                      );
                    },
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text("Supprimer"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mon Profil"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _deconnexion,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Informations du compte",
                      style: Theme.of(context).textTheme.titleLarge ,
                    ),
                    const SizedBox(height: 10),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.account_circle, color: Colors.blue),
                      title: Text("Nom"),
                      subtitle: Text(nom),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone, color: Colors.green),
                      title: Text("Téléphone"),
                      subtitle: Text(telephone),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/edit-profile'),
              child: Row(
                children: const [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text("Modifier mon compte"),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _deconnexion,
              child: Row(
                children: const [
                  Icon(Icons.exit_to_app),
                  SizedBox(width: 8),
                  Text("Se déconnecter"),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _supprimerCompte,
              child: Row(
                children: const [
                  Icon(Icons.delete, color: Colors.white),
                  SizedBox(width: 8),
                  Text("Supprimer mon compte"),
                ],
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
