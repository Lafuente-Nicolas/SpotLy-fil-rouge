// Point d'entrée : démarre le serveur HTTP de l'API.
import { app } from './app.js';

const PORT = Number(process.env.PORT ?? 3000);

app.listen(PORT, () => {
  console.log(`API Spotly démarrée sur http://localhost:${PORT}`);
});
