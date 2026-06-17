const express = require('express');
const { body, validationResult } = require('express-validator');
const admin = require('firebase-admin');

const router = express.Router();

const firebaseAuthRequest = async (endpoint, payload) => {
  const apiKey = process.env.FIREBASE_WEB_API_KEY;

  if (!apiKey) {
    const error = new Error('FIREBASE_WEB_API_KEY no está configurada');
    error.status = 500;
    throw error;
  }

  const response = await fetch(
    `https://identitytoolkit.googleapis.com/v1/accounts:${endpoint}?key=${apiKey}`,
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ ...payload, returnSecureToken: true })
    }
  );

  const data = await response.json();

  if (!response.ok) {
    const error = new Error(data.error?.message || 'Firebase Auth error');
    error.status = response.status;
    error.code = data.error?.message;
    throw error;
  }

  return data;
};

const authErrorMessage = (code) => {
  switch (code) {
    case 'EMAIL_EXISTS':
      return 'El correo electrónico ya está en uso';
    case 'EMAIL_NOT_FOUND':
    case 'INVALID_PASSWORD':
    case 'INVALID_LOGIN_CREDENTIALS':
      return 'Credenciales inválidas';
    case 'WEAK_PASSWORD : Password should be at least 6 characters':
      return 'La contraseña debe tener al menos 6 caracteres';
    default:
      return 'No se pudo completar la autenticación';
  }
};

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
      const authData = await firebaseAuthRequest('signUp', {
        email,
        password
      });
      const uid = authData.localId;

      const userRecord = await req.admin.auth().updateUser(uid, { displayName });

      await req.db.collection('users').doc(uid).set({
        id: uid,
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

      res.status(201).json({
        success: true,
        user: {
          uid,
          email: userRecord.email,
          displayName: userRecord.displayName
        },
        token: authData.idToken
      });
    } catch (error) {
      console.error('Registration error:', error);

      const status = error.status && error.status < 500 ? 400 : 500;
      res.status(status).json({ error: authErrorMessage(error.code) });
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
      const authData = await firebaseAuthRequest('signInWithPassword', {
        email,
        password
      });
      const userRecord = await req.admin.auth().getUser(authData.localId);

      res.json({
        success: true,
        user: {
          uid: userRecord.uid,
          email: userRecord.email,
          displayName: userRecord.displayName,
          photoURL: userRecord.photoURL
        },
        token: authData.idToken
      });
    } catch (error) {
      console.error('Login error:', error);

      res.status(401).json({ error: authErrorMessage(error.code) });
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
