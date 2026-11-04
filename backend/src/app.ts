// Configuration de l'application Express : middlewares et routes.
import express from 'express';
import { santeRouter } from './routes/sante.routes.js';

export const app = express();

// Ne pas révéler que le serveur utilise Express (en-tête X-Powered-By)
app.disable('x-powered-by');

// Lire le corps des requêtes au format JSON
app.use(express.json());

// Routes
app.use('/api/sante', santeRouter);

// Route inconnue
app.use((_req, res) => {
  res.status(404).json({ message: 'Route introuvable' });
});
