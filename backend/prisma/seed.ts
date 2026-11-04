// Données de départ : les 10 catégories (décision D16) et les tags proposés.
// Lancement : npx prisma db seed
// upsert = créer la ligne si elle n'existe pas, sinon la laisser telle quelle :
// le script peut donc être relancé sans créer de doublons.
import { prisma } from '../src/lib/prisma.js';

const categories = [
  { libelle: 'Café', icone: 'cafe' },
  { libelle: 'Coworking', icone: 'coworking' },
  { libelle: 'Restauration', icone: 'restauration' },
  { libelle: 'Bar et rooftop', icone: 'bar' },
  { libelle: 'Point de vue', icone: 'point-de-vue' },
  { libelle: 'Plage et baignade', icone: 'plage' },
  { libelle: 'Nature et randonnée', icone: 'nature' },
  { libelle: 'Culture et patrimoine', icone: 'culture' },
  { libelle: 'Marché', icone: 'marche' },
  { libelle: 'Activité', icone: 'activite' },
];

const tags = [
  'Gratuit',
  'Wifi',
  'Coucher de soleil',
  'Street food',
  'Accessible à pied',
  'Adapté à la pluie',
  'Calme',
  'En famille',
];

async function main() {
  for (const categorie of categories) {
    await prisma.categorie.upsert({
      where: { libelle: categorie.libelle },
      update: {},
      create: categorie,
    });
  }

  for (const libelle of tags) {
    await prisma.tag.upsert({ where: { libelle }, update: {}, create: { libelle } });
  }

  console.log(`${categories.length} catégories et ${tags.length} tags en base.`);
}

main()
  .catch((erreur) => {
    console.error(erreur);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
