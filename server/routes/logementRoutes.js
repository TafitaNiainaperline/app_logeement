
const express = require('express');
const router = express.Router();
const logementController = require('../controllers/logementController');
const upload = require('../middleware/upload');  


router.get('/', logementController.getLogements);
router.post('/', upload.single('image'), logementController.addLogement);
router.put('/:id', upload.single('image'), logementController.updateLogement); 
router.delete('/:id', logementController.deleteLogement); 

module.exports = router;