// Routes de vérification de l'état de l'API.
import { Router } from 'express';
import { getSante } from '../controllers/sante.controller.js';

export const santeRouter = Router();

santeRouter.get('/', getSante);
