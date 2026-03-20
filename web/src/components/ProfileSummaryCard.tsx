import type { OnboardingProfile } from '../types/onboarding';

export function ProfileSummaryCard({ profile, onEdit }: { profile: OnboardingProfile; onEdit: () => void }) {
  return <div className="card shadow-sm mt-4"><div className="card-body">
    <div className="d-flex justify-content-between align-items-center mb-3"><h2 className="h5 mb-0">Profil biegacza</h2><button className="btn btn-outline-success btn-sm" onClick={onEdit}>Edytuj onboarding</button></div>
    <div className="row g-3 small">
      <div className="col-md-6"><strong>Wiek:</strong> {profile.age}</div>
      <div className="col-md-6"><strong>Płeć:</strong> {profile.sex}</div>
      <div className="col-md-6"><strong>Waga / wzrost:</strong> {profile.weight} kg / {profile.height} cm</div>
      <div className="col-md-6"><strong>Sylwetka:</strong> {profile.bodyType}</div>
      <div className="col-md-6"><strong>Aktywność:</strong> {profile.activityHistory}</div>
      <div className="col-md-6"><strong>Cel:</strong> {profile.goal}</div>
      <div className="col-md-6"><strong>Dni:</strong> {profile.trainingDays.join(', ')}</div>
      <div className="col-md-6"><strong>Sprzęt:</strong> {profile.availableEquipment.join(', ')}</div>
      <div className="col-12"><strong>Nietolerancje:</strong> {profile.foodIntolerances || 'brak'}</div>
    </div>
  </div></div>;
}
