// config/db.js
require('dotenv').config();
const mongoose = require('mongoose');

const connectDB = () => {
  mongoose
    .connect(process.env.DB_URI, { dbName: "app-logement" })
    .then(() => {
      console.log("Connected to the database");
    })
    .catch((err) => {
      console.error("Database connection error:", err);
      process.exit(1);
    });
};

module.exports = connectDB;
