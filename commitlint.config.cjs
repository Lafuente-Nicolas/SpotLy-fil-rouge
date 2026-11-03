// Vérifie que chaque message de commit respecte les commits conventionnels.
// Les règles du projet sont expliquées dans CONTRIBUTING.md.
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    // Les descriptions sont en français : on n'impose pas de casse
    'subject-case': [0],
    'header-max-length': [2, 'always', 100],
  },
};
