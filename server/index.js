const express = require('express');
const dotenv = require('dotenv');
const connectDB = require('./config/db');
const utilisateurRoutes = require('./routes/utilisateurRoutes');
const logementRoutes = require('./routes/logementRoutes');
const upload =require('./middleware/upload')
const cors = require('cors');

dotenv.config();

const app = express();

app.use(express.json());
app.use(cors());

connectDB();

app.use('/api/logements', logementRoutes); 
app.use('/api/utilisateur', utilisateurRoutes);
app.use('/uploads', express.static('uploads'));

 



const PORT = process.env.PORT || 5000;

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
});
