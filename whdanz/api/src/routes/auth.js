const express = require('express');
const { body, validationResult } = require('express-validator');
const admin = require('firebase-admin');

const router = express.Router();

router.post('/register',
  body('email').isEmail().normalizeEmail(),
  body('password').isLength({ min: 6 }),
  body('displayName').trim().notEmpty(),
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { email, password, displayName } = req.body;

    try {
      const userRecord = await req.admin.auth().createUser({
        email,
        password,
        displayName
      });

      await req.db.collection('users').doc(userRecord.uid).set({
        id: userRecord.uid,
        email,
        displayName,
        photoURL: null,
        bio: '',
        followersCount: 0,
        followingCount: 0,
        postsCount: 0,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
      });

      const customToken = await req.admin.auth().createCustomToken(userRecord.uid);

      res.status(201).json({
        success: true,
        user: {
          uid: userRecord.uid,
          email: userRecord.email,
          displayName: userRecord.displayName
        },
        token: customToken
      });
    } catch (error) {
      console.error('Registration error:', error);
      
      if (error.code === 'auth/email-already-exists') {
        return res.status(400).json({ error: 'El correo electrónico ya está en uso' });
      }
      
      res.status(500).json({ error: error.message });
    }
  }
);

router.post('/login',
  body('email').isEmail().normalizeEmail(),
  body('password').notEmpty(),
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { email, password } = req.body;

    try {
      const userRecord = await req.admin.auth().getUserByEmail(email);

      const customToken = await req.admin.auth().createCustomToken(userRecord.uid);

      res.json({
        success: true,
        user: {
          uid: userRecord.uid,
          email: userRecord.email,
          displayName: userRecord.displayName,
          photoURL: userRecord.photoURL
        },
        token: customToken
      });
    } catch (error) {
      console.error('Login error:', error);
      
      if (error.code === 'auth/user-not-found') {
        return res.status(401).json({ error: 'Usuario no encontrado' });
      }
      
      res.status(401).json({ error: 'Credenciales inválidas' });
    }
  }
);

router.get('/verify', async (req, res) => {
  const authHeader = req.headers.authorization;
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Token no proporcionado' });
  }

  const idToken = authHeader.split('Bearer ')[1];

  try {
    const decodedToken = await req.admin.auth().verifyIdToken(idToken);
    const userRecord = await req.admin.auth().getUser(decodedToken.uid);
    
    const userDoc = await req.db.collection('users').doc(decodedToken.uid).get();
    const userData = userDoc.exists ? userDoc.data() : null;

    res.json({
      success: true,
      user: {
        uid: userRecord.uid,
        email: userRecord.email,
        displayName: userRecord.displayName,
        photoURL: userRecord.photoURL
      },
      profile: userData
    });
  } catch (error) {
    console.error('Verify error:', error);
    res.status(401).json({ error: 'Token inválido o expirado' });
  }
});

module.exports = router;
