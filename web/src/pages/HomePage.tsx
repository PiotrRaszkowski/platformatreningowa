import { useState } from 'react';
import { FeatureCard } from '../components/FeatureCard';
import { AuthForm } from '../components/AuthForm';
import { LegalConsentCard } from '../components/LegalConsentCard';
import { OnboardingCard } from '../components/OnboardingCard';
import { ProfileSummaryCard } from '../components/ProfileSummaryCard';
import { useHealthStatus } from '../hooks/useHealthStatus';
import type { AuthResponse } from '../types/auth';
import type { OnboardingProfile } from '../types/onboarding';

const features = [
  { title: 'Legal + onboarding', description: 'Nowy użytkownik przechodzi obowiązkowe zgody i wieloetapową ankietę startową.' },
  { title: 'Minimalizacja danych', description: 'Bez imienia i nazwiska — tylko dane potrzebne do ułożenia planu.' },
  { title: 'Dashboard po starcie', description: 'Po zakończeniu ankiety użytkownik ląduje na dashboardzie z podsumowaniem profilu.' }
];

export function HomePage() {
  const health = useHealthStatus();
  const [mode, setMode] = useState<'login' | 'register'>('register');
  const [authResult, setAuthResult] = useState<AuthResponse | null>(null);
  const [acceptanceTimestamp, setAcceptanceTimestamp] = useState<string | null>(null);
  const [profile, setProfile] = useState<OnboardingProfile | null>(null);

  const stage = !authResult ? 'auth' : !authResult.legalConsentsAccepted ? 'consents' : authResult.onboardingCompleted ? 'dashboard' : 'onboarding';

  const handleConsentsCompleted = (acceptedAt: string) => {
    if (!authResult) return;
    setAcceptanceTimestamp(acceptedAt);
    setAuthResult({ ...authResult, legalConsentsAccepted: true, redirectTo: '/onboarding' });
  };

  const handleOnboardingCompleted = (savedProfile: OnboardingProfile) => {
    if (!authResult) return;
    setProfile(savedProfile);
    setAuthResult({ ...authResult, onboardingCompleted: true, redirectTo: '/dashboard' });
  };

  const handleEdit = () => {
    if (!authResult) return;
    setAuthResult({ ...authResult, onboardingCompleted: false, redirectTo: '/onboarding' });
  };

  return <div className="container py-5">
    <div className="row justify-content-center mb-5"><div className="col-lg-8 text-center"><span className="badge text-bg-success mb-3">Issue #4</span><h1 className="display-5 fw-bold">Platforma Treningowa</h1><p className="lead text-secondary">Rejestracja, zgody prawne i onboarding startowy dla nowych użytkowników.</p><p className="mb-0">Status backendu: <strong data-testid="health-status">{health?.status ?? 'Ładowanie...'}</strong></p></div></div>
    {authResult && stage === 'dashboard' && <div className="alert alert-success" role="status">Zalogowano jako <strong>{authResult.email}</strong>. Redirect: <strong>{authResult.redirectTo}</strong>{acceptanceTimestamp && <span className="d-block mt-2">Zgody zaakceptowane: <strong>{acceptanceTimestamp}</strong></span>}</div>}
    <div className="row g-4 align-items-start"><div className="col-lg-5">{stage === 'auth' && <><div className="d-flex gap-2 mb-3"><button className={`btn ${mode === 'register' ? 'btn-success' : 'btn-outline-success'}`} onClick={() => setMode('register')}>Rejestracja</button><button className={`btn ${mode === 'login' ? 'btn-success' : 'btn-outline-success'}`} onClick={() => setMode('login')}>Logowanie</button></div><AuthForm mode={mode} onAuthenticated={setAuthResult} /></>}{stage === 'consents' && authResult && <LegalConsentCard authResult={authResult} onCompleted={handleConsentsCompleted} />}{stage === 'onboarding' && authResult && <OnboardingCard authResult={authResult} onCompleted={handleOnboardingCompleted} />}{stage === 'dashboard' && profile && <ProfileSummaryCard profile={profile} onEdit={handleEdit} />}</div>
      <div className="col-lg-7"><div className="row g-4">{features.map((feature) => <div key={feature.title} className="col-md-4 col-lg-12"><FeatureCard {...feature} /></div>)}</div></div></div>
  </div>;
}
