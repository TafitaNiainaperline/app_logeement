const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const Utilisateur = require('../models/Utilisateur');

exports.creerCompte = async (req, res) => {
    const { nom, telephone } = req.body;

    try {
        const utilisateurExistant = await Utilisateur.findOne({ telephone, nom });
        if (utilisateurExistant) {
            return res.status(400).json({ message: 'Un utilisateur avec ce nom et ce numéro de téléphone existe déjà.' });
        }

        const utilisateur = new Utilisateur({ nom, telephone });
        await utilisateur.save();
        res.status(201).json({ message: 'Compte créé avec succès.' });
    } catch (err) {
        res.status(500).json({ message: 'Erreur serveur.' });
    }
};

exports.seConnecterParTelephone = async (req, res) => {
    const { telephone } = req.body;

    try {
        const utilisateur = await Utilisateur.findOne({ telephone });
        if (!utilisateur) {
            return res.status(404).json({ message: 'Utilisateur non trouvé.' });
        }
        res.status(200).json({ utilisateur });
    } catch (err) {
        res.status(500).json({ message: 'Erreur serveur.' });
    }
};

exports.getUtilisateurParId = async (req, res) => {
  const { id } = req.params;

  try {
      const utilisateur = await Utilisateur.findById(id);
      if (!utilisateur) {
          return res.status(404).json({ message: 'Utilisateur non trouvé.' });
      }
      res.status(200).json(utilisateur);
  } catch (err) {
      res.status(500).json({ message: 'Erreur serveur.' });
  }
};
exports.modifierUtilisateur = async (req, res) => {
  const { id } = req.params;
  const { nom, telephone } = req.body;

  try {
      const utilisateur = await Utilisateur.findByIdAndUpdate(
          id,
          { nom, telephone },
          { new: true, runValidators: true }
      );
      if (!utilisateur) {
          return res.status(404).json({ message: 'Utilisateur non trouvé.' });
      }
      res.status(200).json({ message: 'Utilisateur modifié avec succès.', utilisateur });
  } catch (err) {
      res.status(500).json({ message: 'Erreur serveur.' });
  }
};

exports.supprimerUtilisateur = async (req, res) => {
  const { id } = req.params;

  try {
      const utilisateur = await Utilisateur.findByIdAndDelete(id);
      if (!utilisateur) {
          return res.status(404).json({ message: 'Utilisateur non trouvé.' });
      }
      res.status(200).json({ message: 'Compte supprimé avec succès.' });
  } catch (err) {
      res.status(500).json({ message: 'Erreur serveur.' });
  }
};

