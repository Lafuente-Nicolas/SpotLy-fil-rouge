import react from '@vitejs/plugin-react';
import tailwindcss from '@tailwindcss/vite';
import { defineConfig } from 'vite';

// https://vite.dev/config/
export default defineConfig({
  plugins: [react(), tailwindcss()],
  server: {
    // En développement, les requêtes vers /api sont transmises à l'API (port 3000).
    // Le frontend et l'API semblent ainsi servis par la même adresse,
    // ce qui permet d'utiliser le cookie de session (décision D23).
    proxy: {
      '/api': 'http://localhost:3000',
    },
  },
});
