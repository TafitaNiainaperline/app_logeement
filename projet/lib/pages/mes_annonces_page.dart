import 'dart:convert';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:http/http.dart' as http;
import '../models/logement.dart';
import 'AjouterModifierAnnoncePage.dart';


class MesAnnoncesPage extends StatefulWidget {
  @override
  _MesAnnoncesPageState createState() => _MesAnnoncesPageState();
}

class _MesAnnoncesPageState extends State<MesAnnoncesPage> {
  List<Logement> _mesAnnonces = [];
  bool _isLoading = true;
  final String _baseUrl = 'http://192.168.1.165:5000/api';

  @override
  void initState() {
    super.initState();
    _fetchLogements();
  }

  Future<void> _fetchLogements() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/logements'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _mesAnnonces = data.map((json) => Logement.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        _showFlyoutMessage(
          'Erreur ${response.statusCode} lors du chargement des logements',
          success: false,
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showFlyoutMessage('Erreur : $e', success: false);
    }
  }

  Future<void> _deleteLogement(String id) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/logements/$id'));
      if (response.statusCode == 200) {
        setState(() {
          _mesAnnonces.removeWhere((logement) => logement.id == id);
        });
        _showFlyoutMessage('Logement supprimé avec succès');
      } else {
        _showFlyoutMessage(
          'Erreur ${response.statusCode} lors de la suppression',
          success: false,
        );
      }
    } catch (e) {
      _showFlyoutMessage('Erreur : $e', success: false);
    }
  }

  void _showFlyoutMessage(String message, {bool success = true}) {
    showDialog(
      context: context,
      builder: (context) {
        return ContentDialog(
          title: Text(success ? 'Succès' : 'Erreur'),
          content: Text(message),
          actions: [
            Button(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void _handleSave(String titre, String ville, double prix, String imagePath) {
    print('Annonce saved: $titre, $ville, $prix, $imagePath');
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: const Text('Mes Annonces'),
        commandBar: FilledButton(
          child: const Text('Ajouter une annonce'),
          onPressed: () {
            Navigator.push(
              context,
              FluentPageRoute(
                builder: (context) => AjouterModifierAnnoncePage(
                  onSave: _handleSave,
                ),
              ),
            );
          },
        ),
      ),
      content: _isLoading
          ? const Center(child: ProgressRing())
          : _mesAnnonces.isEmpty
              ? const Center(child: Text('Aucune annonce disponible.'))
              : ListView.builder(
                  itemCount: _mesAnnonces.length,
                  itemBuilder: (context, index) {
                    final logement = _mesAnnonces[index];
                    String imageUrl = logement.imageUrl;

                    if (!imageUrl.startsWith('http')) {
                      imageUrl = 'http://192.168.1.165:5000$imageUrl';
                    }

                    return Card(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey,
                                child: const Icon(
                                  FluentIcons.error,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  logement.titre,
                                  style: FluentTheme.of(context).typography.subtitle,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${logement.prix} AR - ${logement.ville}',
                                  style: FluentTheme.of(context)
                                      .typography
                                      .body
                                      ?.copyWith(color: FluentTheme.of(context).inactiveColor),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(FluentIcons.delete),
                                onPressed: () => _deleteLogement(logement.id),
                              ),
                              IconButton(
                                icon: const Icon(FluentIcons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    FluentPageRoute(
                                      builder: (context) => AjouterModifierAnnoncePage(
                                        onSave: _handleSave,
                                        logement: logement,
                                      ),
                                    ),
                                  );
                                }, 
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
