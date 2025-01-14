const mongoose = require('mongoose');

const utilisateurSchema = new mongoose.Schema({
    nom: { type: String, required: true },
    telephone: { type: String, required: true, unique: true },
    typeUtilisateur: { type: String, default: 'utilisateur' },
});

const Utilisateur = mongoose.model('Utilisateur', utilisateurSchema);

module.exports = Utilisateur;
