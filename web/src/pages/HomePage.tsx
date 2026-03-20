import { useState } from 'react';
import { FeatureCard } from '../components/FeatureCard';
import { AuthForm } from '../components/AuthForm';
import { useHealthStatus } from '../hooks/useHealthStatus';
import type { AuthResponse } from '../types/auth';

const features = [
  {
    title: 'Rejestracja email + hasło',
    description: 'Nowy użytkownik tworzy konto z walidacją emaila, hasła i powtórzenia hasła.'
  },
  {
    title: 'Logowanie',
    description: 'JWT/session przygotowane po stronie backendu i spójny przepływ dla web/mobile.'
  },
  {
    title: 'Redirect po zalogowaniu',
    description: 'Nowy biegacz trafia na onboarding, a wracający użytkownik na dashboard.'
  }
];

export function HomePage() {
  const health = useHealthStatus();
  const [mode, setMode] = useState<'login' | 'register'>('register');
  const [authResult, setAuthResult] = useState<AuthResponse | null>(null);

  return (
    <div className="container py-5">
      <div className="row justify-content-center mb-5">
        <div className="col-lg-8 text-center">
          <span className="badge text-bg-success mb-3">Issue #3</span>
          <h1 className="display-5 fw-bold">Platforma Treningowa</h1>
          <p className="lead text-secondary">Rejestracja i logowanie email + hasło dla webowego companion app.</p>
          <p className="mb-0">
            Status backendu: <strong data-testid="health-status">{health?.status ?? 'Ładowanie...'}</strong>
          </p>
        </div>
      </div>

      {authResult && (
        <div className="alert alert-success" role="status">
          Zalogowano jako <strong>{authResult.email}</strong>. Redirect: <strong>{authResult.redirectTo}</strong>
        </div>
      )}

      <div className="row g-4 align-items-start">
        <div className="col-lg-5">
          <div className="d-flex gap-2 mb-3">
            <button
              className={`btn ${mode === 'register' ? 'btn-success' : 'btn-outline-success'}`}
              onClick={() => setMode('register')}
            >
              Rejestracja
            </button>
            <button
              className={`btn ${mode === 'login' ? 'btn-success' : 'btn-outline-success'}`}
              onClick={() => setMode('login')}
            >
              Logowanie
            </button>
          </div>
          <AuthForm mode={mode} onAuthenticated={setAuthResult} />
        </div>
        <div className="col-lg-7">
          <div className="row g-4">
            {features.map((feature) => (
              <div key={feature.title} className="col-md-4 col-lg-12">
                <FeatureCard {...feature} />
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
