import 'package:fluent_ui/fluent_ui.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_service.dart'; 

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _telephoneController = TextEditingController();
  final String baseUrl = "http://192.168.1.165:5000/api/utilisateur/connexion";

  String? _infoMessage; 
  InfoBarSeverity _infoSeverity = InfoBarSeverity.info;
  bool _isLoading = false; 

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String? telephone = ModalRoute.of(context)?.settings.arguments as String?;
    if (telephone != null) {
      _telephoneController.text = telephone;
    }
  }

  Future<void> _connecter() async {
    final telephone = _telephoneController.text.trim();

    if (telephone.isEmpty) {
      _afficherMessage("Veuillez entrer votre numéro de téléphone.", InfoBarSeverity.warning);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"telephone": telephone}),
      );

      if (response.statusCode == 200) {
        final utilisateur = jsonDecode(response.body)['utilisateur'];

        await saveUserSession(utilisateur['_id'], utilisateur['nom'], utilisateur['telephone']);

        _afficherMessage("Bienvenue, ${utilisateur['nom']}", InfoBarSeverity.success);

        Navigator.pushReplacementNamed(context, '/home', arguments: utilisateur);
      } else {
        final error = jsonDecode(response.body)['message'] ?? "Erreur inconnue";
        _afficherMessage("Connexion échouée : $error", InfoBarSeverity.error);
      }
    } catch (e) {
      _afficherMessage("Erreur réseau ou serveur. Vérifiez votre connexion.", InfoBarSeverity.error);
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
      title: "Connexion",
      theme: FluentThemeData(),
      home: ScaffoldPage(
        header: PageHeader(
          title: const Text("Connexion"),
        ),
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
              const SizedBox(height: 26),
              TextBox(
                controller: _telephoneController,
                placeholder: "Entrez votre numéro de téléphone",
                keyboardType: TextInputType.phone,
                prefix: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(FluentIcons.phone),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _connecter,
                  child: _isLoading
                      ? const ProgressRing()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(FluentIcons.contact),
                            SizedBox(width: 8),
                            Text("Se connecter"),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 10),
              HyperlinkButton(
                child: const Text("Pas encore inscrit ? Créez un compte"),
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
