import { FeatureCard } from '../components/FeatureCard';
import { useHealthStatus } from '../hooks/useHealthStatus';

const features = [
  {
    title: 'Onboarding zdrowotny',
    description: 'Wywiad startowy pod longevity i performance z miejscem na późniejsze moduły AI.'
  },
  {
    title: 'Plany treningowe',
    description: 'Scaffold pod gotowe plany i cotygodniową adaptację opartą o dane użytkownika.'
  },
  {
    title: 'Monitoring postępów',
    description: 'Miejsce na log treningowy, wnioski tygodniowe i integracje z wearables.'
  }
];

export function HomePage() {
  const health = useHealthStatus();

  return (
    <div className="container py-5">
      <div className="row justify-content-center mb-5">
        <div className="col-lg-8 text-center">
          <span className="badge text-bg-success mb-3">Scaffold MVP</span>
          <h1 className="display-5 fw-bold">Platforma Treningowa</h1>
          <p className="lead text-secondary">
            React + TypeScript + Bootstrap jako webowy companion do aplikacji mobilnej.
          </p>
          <p className="mb-0">
            Status backendu:{' '}
            <strong data-testid="health-status">{health?.status ?? 'Ładowanie...'}</strong>
          </p>
        </div>
      </div>
      <div className="row g-4">
        {features.map((feature) => (
          <div key={feature.title} className="col-md-4">
            <FeatureCard {...feature} />
          </div>
        ))}
      </div>
    </div>
  );
}
