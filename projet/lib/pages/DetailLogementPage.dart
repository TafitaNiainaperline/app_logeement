import 'package:fluent_ui/fluent_ui.dart';
import '../models/logement.dart';

class LogementDetailPage extends StatelessWidget {
  final Logement logement;

  const LogementDetailPage({Key? key, required this.logement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String baseUrl = 'http://192.168.1.165:5000';
    final String imageUrl = logement.imageUrl.startsWith('/uploads/')
        ? '$baseUrl${logement.imageUrl}'
        : logement.imageUrl;

    return FluentApp(
      title: logement.titre,
      theme: FluentThemeData(
        accentColor: Colors.green,
      ),
      home: ScaffoldPage(
        header: PageHeader(
          title: Text(logement.titre),
          leading: IconButton(
            icon: Icon(FluentIcons.back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        content: SingleChildScrollView( 
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 250,
                      color: Colors.grey.withOpacity(0.2),
                      child: const Center(
                        child: Icon(FluentIcons.image_search, size: 50),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  logement.titre,
                  style: FluentTheme.of(context).typography.titleLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  '${logement.prix} AR',
                  style: FluentTheme.of(context).typography.bodyLarge?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                // Ville
                Row(
                  children: [
                    const Icon(FluentIcons.map_pin, size: 20, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      logement.ville,
                      style: FluentTheme.of(context).typography.bodyLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Date de publication
                Row(
                  children: [
                    const Icon(FluentIcons.calendar, size: 20, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'Publié le ${logement.datePublication.toString().substring(0, 10)}',
                      style: FluentTheme.of(context).typography.bodyLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Description
                Text(
                  'Description :',
                  style: FluentTheme.of(context).typography.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  logement.description,
                  style: FluentTheme.of(context).typography.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
