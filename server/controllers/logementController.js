
const Logement = require('../models/logementModel');

const getLogements = async (req, res) => {
  try {
    const logements = await Logement.find();
    res.json(logements);
  } catch (err) {
    res.status(500).json({ message: 'Erreur lors de la récupération des logements', error: err });
  }
};

const addLogement = async (req, res) => {
  const { titre, description, prix, ville } = req.body;
  const imageUrl = req.file ? `/uploads/${req.file.filename}` : ''; 

  try {
    const newLogement = new Logement({
      titre,
      description,
      prix,
      imageUrl, 
      ville,
    });
    await newLogement.save();
    res.status(201).json(newLogement);  
  } catch (err) {
    res.status(500).json({ message: 'Erreur lors de l\'ajout du logement', error: err });
  }
};

const updateLogement = async (req, res) => {
  const { id } = req.params; 
  const { titre, description, prix, ville } = req.body;
  const imageUrl = req.file ? `/uploads/${req.file.filename}` : undefined; 

  try {
    const logement = await Logement.findById(id);

    if (!logement) {
      return res.status(404).json({ message: 'Logement introuvable' });
    }

    logement.titre = titre || logement.titre;
    logement.description = description || logement.description;
    logement.prix = prix || logement.prix;
    logement.ville = ville || logement.ville;
    if (imageUrl) logement.imageUrl = imageUrl;

    await logement.save();

    res.status(200).json(logement);
  } catch (err) {
    res.status(500).json({ message: 'Erreur lors de la modification du logement', error: err });
  }
};
const deleteLogement = async (req, res) => {
  const { id } = req.params; 

  try {
    const logement = await Logement.findById(id); 

    if (!logement) {
      return res.status(404).json({ message: 'Logement introuvable' });
    }

    await logement.deleteOne(); 

    res.status(200).json({ message: 'Logement supprimé avec succès' });
  } catch (err) {
    res.status(500).json({ message: 'Erreur lors de la suppression du logement', error: err.message });
  }
};



module.exports = {
  getLogements,
  addLogement,
  updateLogement,
  deleteLogement,
};
