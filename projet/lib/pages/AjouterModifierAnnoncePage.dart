import 'dart:io'; 
import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart'; 
import 'package:image_picker/image_picker.dart'; 
import 'package:file_picker/file_picker.dart'; 
import 'package:http/http.dart' as http; 
import '../models/logement.dart';

class AjouterModifierAnnoncePage extends StatefulWidget {
  final Function(String titre, String ville, double prix, String imagePath) onSave;
  final Logement? logement;

  const AjouterModifierAnnoncePage({required this.onSave, this.logement, Key? key}) : super(key: key);

  @override
  _AjouterModifierAnnoncePageState createState() => _AjouterModifierAnnoncePageState();
}

class _AjouterModifierAnnoncePageState extends State<AjouterModifierAnnoncePage> {

  late TextEditingController _titreController;
  late TextEditingController _villeController;
  late TextEditingController _prixController;
  String? _imagePath;
  Uint8List? _webImageBytes; 

  @override
  void initState() {
    super.initState();
    _titreController = TextEditingController(text: widget.logement?.titre ?? '');
    _villeController = TextEditingController(text: widget.logement?.ville ?? '');
    _prixController = TextEditingController(text: widget.logement?.prix.toString() ?? '');
    _imagePath = widget.logement?.imageUrl;
  }

  @override
  void dispose() {
    _titreController.dispose();
    _villeController.dispose();
    _prixController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _webImageBytes = result.files.single.bytes; 
          _imagePath = result.files.single.name; 
        });
      } else {
        _showErrorMessage('Aucune image sélectionnée');
      }
    } else {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });
      } else {
        _showErrorMessage('Aucune image sélectionnée');
      }
    }
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_titreController.text.isEmpty) {
      _showErrorMessage('Le titre est requis');
      return;
    }
    if (_villeController.text.isEmpty) {
      _showErrorMessage('La ville est requise');
      return;
    }
    if (_prixController.text.isEmpty || double.tryParse(_prixController.text) == null) {
      _showErrorMessage('Veuillez entrer un prix valide');
      return;
    }
    if (_imagePath == null && _webImageBytes == null) {
      _showErrorMessage('Veuillez sélectionner une image');
      return;
    }

    final url = widget.logement == null
        ? 'http://192.168.43.24:5000/api/logements' 
        : 'http://192.168.1.165/api/logements/${widget.logement!.id}'; 

    final request = http.MultipartRequest(
      widget.logement == null ? 'POST' : 'PUT', 
      Uri.parse(url),
    );

    request.fields['titre'] = _titreController.text;
    request.fields['ville'] = _villeController.text;
    request.fields['prix'] = _prixController.text;

    if (_imagePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', _imagePath!));
    } else if (_webImageBytes != null) {
      request.files.add(http.MultipartFile.fromBytes('image', _webImageBytes!));
    }

    try {
      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context); 
        widget.onSave(
          _titreController.text,
          _villeController.text,
          double.parse(_prixController.text),
          _imagePath ?? '',
        );
      } else {
        _showErrorMessage('Erreur ${response.statusCode} lors de l\'enregistrement');
      }
    } catch (e) {
      _showErrorMessage('Erreur : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.logement == null ? 'Ajouter une annonce' : 'Modifier l\'annonce'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titreController,
                decoration: InputDecoration(labelText: 'Titre de l\'annonce'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _villeController,
                decoration: InputDecoration(labelText: 'Ville'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _prixController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Prix (ar )'),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Choisir une image'),
                  ),
                  SizedBox(width: 8.0),
                  if (_imagePath != null || _webImageBytes != null)
                    Text('Image sélectionnée'),
                ],
              ),
              SizedBox(height: 16.0),
              if (_webImageBytes != null)
                Image.memory(
                  _webImageBytes!,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              if (_imagePath != null && _webImageBytes == null && !kIsWeb)
                Image.file(
                  File(_imagePath!),
                  height: 150,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.logement == null ? 'Ajouter' : 'Modifier'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
