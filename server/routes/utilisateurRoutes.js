const express = require('express');
const router = express.Router();
const utilisateurController = require('../controllers/utilisateurController');

router.post('/inscription', utilisateurController.creerCompte);
router.post('/connexion', utilisateurController.seConnecterParTelephone);

router.get('/:id', utilisateurController.getUtilisateurParId);
router.put('/:id', utilisateurController.modifierUtilisateur);
router.delete('/:id', utilisateurController.supprimerUtilisateur);


module.exports = router;
