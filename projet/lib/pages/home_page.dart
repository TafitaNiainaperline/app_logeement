import 'package:fluent_ui/fluent_ui.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/logement.dart';
import '../widgets/logement_card.dart';
import '../pages/DetailLogementPage.dart';
import 'mes_annonces_page.dart';
import 'profil_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Logement> _logements = [];
  String _searchQuery = '';
  bool _isLoading = true;
  int _selectedIndex = 0;

  Future<void> _fetchLogements({String query = ''}) async {
    final String apiUrl = query.isNotEmpty
        ? 'http://localhost:5000/api/logements?search=$query'
        : 'http://localhost:5000/api/logements';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Données reçues : $data'); 

        setState(() {
          _logements = data.map((item) => Logement.fromJson(item)).toList();
          _isLoading = false;
        });
      } else {
        print('Erreur : ${response.statusCode}, Message : ${response.body}');
      }
    } catch (e) {
      print('Erreur lors de la récupération des logements : $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLogements();
  }

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Accueil',
      theme: FluentThemeData(
        accentColor: Colors.green, 
      ),
      home: NavigationView(
        appBar: NavigationAppBar(
          automaticallyImplyLeading: false,
          title: const Text('Application de Logement'),
        ),
        pane: NavigationPane(
          selected: _selectedIndex,
          onChanged: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            PaneItem(
              icon: const Icon(FluentIcons.home),
              title: const Text('Accueil'),
              body: _buildHomeContent(),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.list),
              title: const Text('Mes Annonces'),
              body: MesAnnoncesPage(),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.contact),
              title: const Text('Profil'),
              body: ProfilPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextBox(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              _fetchLogements(query: value); 
            },
            placeholder: 'Rechercher un logement',
            suffix: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(FluentIcons.clear),
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                      });
                      _fetchLogements(); 
                    },
                  )
                : null,
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: ProgressRing())
              : _logements.isEmpty
                  ? const Center(child: Text('Aucun logement trouvé.'))
                  : ListView.builder(
                      itemCount: _logements.length,
                      itemBuilder: (context, index) {
                        final logement = _logements[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              FluentPageRoute(
                                builder: (context) =>
                                    LogementDetailPage(logement: logement),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: LogementCard(logement: logement),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
