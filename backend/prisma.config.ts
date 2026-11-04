// Configuration de Prisma 7 : emplacement du schéma, des migrations,
// du script de données de départ et adresse de la base de données.
import { existsSync } from 'node:fs';
import { defineConfig, env } from 'prisma/config';

// Charge le fichier .env situé à la racine du dépôt (fonction intégrée à Node.js).
// En intégration continue, il n'existe pas : les variables sont fournies par GitHub Actions.
if (existsSync('../.env')) {
  process.loadEnvFile('../.env');
}

export default defineConfig({
  schema: 'prisma/schema.prisma',
  migrations: {
    path: 'prisma/migrations',
    seed: 'tsx --env-file=../.env prisma/seed.ts',
  },
  datasource: {
    url: env('DATABASE_URL'),
  },
});
