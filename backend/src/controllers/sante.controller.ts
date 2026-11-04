// Contrôleur : répond aux requêtes de la route /api/sante.
import type { Request, Response } from 'express';

export function getSante(_req: Request, res: Response) {
  res.json({ statut: 'ok' });
}
