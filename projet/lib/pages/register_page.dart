import 'package:fluent_ui/fluent_ui.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final String baseUrl = "http://192.168.1.165:5000/api/utilisateur/inscription";

  bool _isLoading = false;
  String? _telephoneError; 
  String? _infoMessage; 
  InfoBarSeverity _infoSeverity = InfoBarSeverity.info;


  Future<void> _inscrire() async {
    if (_nomController.text.isEmpty || _telephoneController.text.isEmpty) {
      _afficherMessage(
        "Veuillez remplir tous les champs.",
        InfoBarSeverity.warning,
      );
      return;
    }

    if (_telephoneError != null) {
      _afficherMessage(
        "Veuillez corriger les erreurs avant de continuer.",
        InfoBarSeverity.error,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nom": _nomController.text.trim(),
          "telephone": _telephoneController.text.trim(),
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);

        final String nom = data['nom'] ?? "Utilisateur";

        _afficherMessage(
          "Inscription réussie. Bienvenue, $nom!",
          InfoBarSeverity.success,
        );

        Navigator.pushReplacementNamed(
          context,
          '/login',
          arguments: _telephoneController.text.trim(),
        );
      } else {
        final error = jsonDecode(response.body)['message'] ?? "Erreur inconnue";
        _afficherMessage(
          "Échec de l'inscription : $error",
          InfoBarSeverity.error,
        );
      }
    } catch (e) {
      print("Erreur lors de la requête : $e");
      _afficherMessage(
        "Erreur réseau ou serveur.",
        InfoBarSeverity.error,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _afficherMessage(String message, InfoBarSeverity severity) {
    setState(() {
      _infoMessage = message;
      _infoSeverity = severity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: "Inscription",
      theme: FluentThemeData(),
      home: ScaffoldPage(
        header: PageHeader(title: Text("Inscription")),
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_infoMessage != null)
                InfoBar(
                  title: const Text("Message"),
                  content: Text(_infoMessage!),
                  severity: _infoSeverity,
                  isLong: true,
                ),
              const SizedBox(height: 16),
              TextBox(
                controller: _nomController,
                placeholder: "Nom",
              ),
              const SizedBox(height: 16),
              TextBox(
                controller: _telephoneController,
                placeholder: "Téléphone",
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  setState(() {
                    if (!RegExp(r'^03\d{8}$').hasMatch(value)) {
                      _telephoneError =
                          "Le numéro doit commencer par '03' et contenir exactement 10 chiffres.";
                    } else {
                      _telephoneError = null;
                    }
                  });
                },
              ),
              if (_telephoneError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _telephoneError!,
                    style: TextStyle(
                      color: Colors.red, 
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _isLoading ? null : _inscrire,
                child: _isLoading
                    ? const ProgressRing()
                    : const Text("S'inscrire"),
              ),
                            const SizedBox(height: 10),
              HyperlinkButton(
                child: const Text("Déjà inscrit ? Connectez-vous"),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
