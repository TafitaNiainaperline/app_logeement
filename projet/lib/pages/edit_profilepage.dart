import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String userId = "";
  String nom = "";
  String telephone = "";
  bool _isLoading = false;
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? "Inconnu";
      nom = prefs.getString('nom') ?? "Nom inconnu";
      telephone = prefs.getString('telephone') ?? "Téléphone inconnu";
      _nomController.text = nom;
      _telephoneController.text = telephone;
    });
  }

  Future<void> _modifierCompte() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.put(
        Uri.parse("http://192.168.1.165:5000/api/utilisateur/$userId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nom": _nomController.text.trim(),
          "telephone": _telephoneController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          nom = data['utilisateur']['nom'];
          telephone = data['utilisateur']['telephone'];
        });
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('nom', nom);
        await prefs.setString('telephone', telephone);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Succès'),
            content: Text('Informations mises à jour'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/profil'),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Erreur'),
            content: Text('Échec de la mise à jour'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Erreur réseau ou serveur'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier mon profil"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomController,
              decoration: InputDecoration(labelText: "Nom"),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _telephoneController,
              decoration: InputDecoration(labelText: "Téléphone"),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _modifierCompte,
              child: _isLoading
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(width: 8),
                        Text("Sauvegarder les modifications"),
                      ],
                    )
                  : Text("Sauvegarder les modifications"),
            ),
          ],
        ),
      ),
    );
  }
}
