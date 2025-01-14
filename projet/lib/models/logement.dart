
class Logement {
  final String id;
  final String titre;
  final String description;
  final int prix;
  final String imageUrl;
  final String ville;
  final DateTime datePublication;

  Logement({
    required this.id,
    required this.titre,
    required this.description,
    required this.prix,
    required this.imageUrl,
    required this.ville,
    required this.datePublication,
  });

  factory Logement.fromJson(Map<String, dynamic> json) {
    // Fonction pour analyser les dates dans différents formats
    DateTime parseDate(String date) {
      try {
        // Format simple : "2025-01-10"
        if (date.contains('-') && date.length == 10) {
          return DateTime.parse(date);
        }
        // Format complet : "Fri Jan 10 2025 10:10:36 GMT+0300"
        return DateTime.parse(
          DateTime.parse(date).toIso8601String(),
        );
      } catch (e) {
        print('Erreur lors de l\'analyse de la date : $date');
        return DateTime.now(); // Valeur par défaut en cas d'échec
      }
    }

    return Logement(
      id: json['_id'] ?? '',
      titre: json['titre'] ?? '',
      description: json['description'] ?? '',
      prix: json['prix'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      ville: json['ville'] ?? '',
      datePublication: parseDate(json['datePublication'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'titre': titre,
      'description': description,
      'prix': prix,
      'imageUrl': imageUrl,
      'ville': ville,
      'datePublication': datePublication.toIso8601String(),
    };
  }
}
