const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const admin = require('firebase-admin');
const fs = require('fs');

dotenv.config();

const serviceAccount = JSON.parse(
  fs.readFileSync(process.env.GOOGLE_APPLICATION_CREDENTIALS || './service-account-key.json', 'utf8')
);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

const authRoutes = require('./routes/auth');
const usersRoutes = require('./routes/users');

const app = express();

app.use(cors());
app.use(express.json());

app.use((req, res, next) => {
  req.db = db;
  req.admin = admin;
  next();
});

app.use('/api/auth', authRoutes);
app.use('/api/users', usersRoutes);

app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`WhDanz API running on port ${PORT}`);
});

module.exports = app;
