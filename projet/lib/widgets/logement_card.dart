import 'package:fluent_ui/fluent_ui.dart';
import '../models/logement.dart';

class LogementCard extends StatelessWidget {
  final Logement logement;
  final VoidCallback? onTap;

  const LogementCard({Key? key, required this.logement, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String baseUrl = 'http://192.168.1.165:5000';

    final String imageUrl = logement.imageUrl.startsWith('/uploads/')
        ? '$baseUrl${logement.imageUrl}'
        : logement.imageUrl;

    return GestureDetector(
      onTap: onTap, 
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.withOpacity(0.2),
                image: logement.imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {
                          debugPrint('Erreur de chargement de l\'image : $exception');
                        },
                      )
                    : null,
              ),
              child: logement.imageUrl.isEmpty
                  ? const Center(child: Icon(FluentIcons.image_search, size: 40))
                  : null,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      logement.titre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${logement.prix} AR',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
