// Tests de la route de vérification de l'état de l'API.
// Supertest envoie des requêtes à l'application Express sans démarrer le serveur.
import request from 'supertest';
import { describe, expect, it } from 'vitest';
import { app } from '../src/app.js';

describe('GET /api/sante', () => {
  it("répond 200 avec le statut de l'API", async () => {
    const reponse = await request(app).get('/api/sante');

    expect(reponse.status).toBe(200);
    expect(reponse.body).toEqual({ statut: 'ok' });
  });
});

describe('Route inconnue', () => {
  it('répond 404 avec un message', async () => {
    const reponse = await request(app).get('/api/route-inexistante');

    expect(reponse.status).toBe(404);
    expect(reponse.body).toEqual({ message: 'Route introuvable' });
  });
});
