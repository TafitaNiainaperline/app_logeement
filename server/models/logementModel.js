const mongoose = require('mongoose');

const logementSchema = new mongoose.Schema({
  titre: { type: String, required: true },
  description: { type: String, required: true },
  prix: { type: Number, required: true },
  imageUrl: { type: String },
  ville: { type: String, required: true },
  datePublication: {
    type: String,  
    default: () => new Date().toISOString().split('T')[0],  
  },
});

const Logement = mongoose.model('Logement', logementSchema);

module.exports = Logement;
