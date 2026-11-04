import { useEffect, useState } from 'react';

type EtatApi = 'verification' | 'connectee' | 'injoignable';

// Page de test de la mise en place : vérifie que le frontend communique avec l'API.
// Elle sera remplacée par la carte (US-03).
function App() {
  const [etatApi, setEtatApi] = useState<EtatApi>('verification');

  useEffect(() => {
    fetch('/api/sante')
      .then((reponse) => setEtatApi(reponse.ok ? 'connectee' : 'injoignable'))
      .catch(() => setEtatApi('injoignable'));
  }, []);

  const messages: Record<EtatApi, string> = {
    verification: "Vérification de l'API…",
    connectee: 'API connectée',
    injoignable: 'API injoignable',
  };

  return (
    <main className="flex min-h-screen flex-col items-center justify-center gap-4 bg-gris-clair p-6 text-center">
      <h1 className="text-4xl font-bold text-dark-teal">Spotly</h1>
      <p className="font-medium">Find what&apos;s worth it, right now.</p>

      <p
        role="status"
        className={`rounded-full px-4 py-2 font-semibold text-white ${
          etatApi === 'connectee' ? 'bg-muted-teal' : 'bg-coral-glow'
        }`}
      >
        {messages[etatApi]}
      </p>
    </main>
  );
}

export default App;
