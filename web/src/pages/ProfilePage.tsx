import { useState, useEffect } from 'react';
import type { UserProfile, UpdateProfileRequest, ChangePasswordRequest } from '../types/profile';
import { getUserProfile, updateUserProfile, changePassword } from '../services/authService';

const dayLabels: Record<string, string> = { MON: 'Pon', TUE: 'Wt', WED: 'Śr', THU: 'Czw', FRI: 'Pt', SAT: 'Sob', SUN: 'Ndz' };
const allDays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
const goalOptions = ['schudnąć', 'poprawić kondycję', 'biegać szybciej', 'zacząć się ruszać', 'przygotowanie do zawodów'];
const equipmentOptions = ['nic', 'hantle', 'gumy', 'siłownia'];

export function ProfilePage({ token, email, onLogout }: { token: string; email: string; onLogout: () => void }) {
  const [profile, setProfile] = useState<UserProfile | null>(null);
  const [editing, setEditing] = useState(false);
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const [weight, setWeight] = useState('');
  const [trainingDays, setTrainingDays] = useState<string[]>([]);
  const [goal, setGoal] = useState('');
  const [foodIntolerances, setFoodIntolerances] = useState('');
  const [availableEquipment, setAvailableEquipment] = useState<string[]>([]);

  const [changingPassword, setChangingPassword] = useState(false);
  const [currentPassword, setCurrentPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmNewPassword, setConfirmNewPassword] = useState('');
  const [passwordSaving, setPasswordSaving] = useState(false);
  const [passwordMessage, setPasswordMessage] = useState<string | null>(null);
  const [passwordError, setPasswordError] = useState<string | null>(null);

  useEffect(() => {
    getUserProfile(token).then(setProfile).catch((e) => setError(e.message));
  }, [token]);

  const startEditing = () => {
    if (!profile) return;
    setWeight(profile.weight);
    setTrainingDays([...profile.trainingDays]);
    setGoal(profile.goal);
    setFoodIntolerances(profile.foodIntolerances);
    setAvailableEquipment([...profile.availableEquipment]);
    setEditing(true);
    setMessage(null);
    setError(null);
  };

  const handleSave = async () => {
    setSaving(true);
    setError(null);
    try {
      const request: UpdateProfileRequest = {
        weight: parseFloat(weight),
        trainingDays,
        goal,
        foodIntolerances,
        availableEquipment,
      };
      const updated = await updateUserProfile(token, request);
      setProfile(updated);
      setEditing(false);
      setMessage('Profil zaktualizowany.');
    } catch (e: unknown) {
      setError(e instanceof Error ? e.message : 'Błąd zapisu.');
    } finally {
      setSaving(false);
    }
  };

  const handleChangePassword = async () => {
    setPasswordSaving(true);
    setPasswordError(null);
    setPasswordMessage(null);
    try {
      const request: ChangePasswordRequest = { currentPassword, newPassword, confirmNewPassword };
      await changePassword(token, request);
      setPasswordMessage('Hasło zostało zmienione.');
      setChangingPassword(false);
      setCurrentPassword('');
      setNewPassword('');
      setConfirmNewPassword('');
    } catch (e: unknown) {
      setPasswordError(e instanceof Error ? e.message : 'Błąd zmiany hasła.');
    } finally {
      setPasswordSaving(false);
    }
  };

  const toggleDay = (day: string) => {
    setTrainingDays((prev) => prev.includes(day) ? prev.filter((d) => d !== day) : [...prev, day]);
  };

  const toggleEquipment = (eq: string) => {
    setAvailableEquipment((prev) => prev.includes(eq) ? prev.filter((e) => e !== eq) : [...prev, eq]);
  };

  if (!profile) return <div className="text-center py-4">{error ? <div className="alert alert-danger">{error}</div> : 'Ładowanie profilu...'}</div>;

  return <div className="card shadow-sm">
    <div className="card-body">
      <div className="d-flex justify-content-between align-items-center mb-3">
        <h2 className="h5 mb-0">Profil użytkownika</h2>
        <div className="d-flex gap-2">
          {!editing && <button className="btn btn-outline-success btn-sm" onClick={startEditing}>Edytuj</button>}
          <button className="btn btn-outline-danger btn-sm" onClick={onLogout}>Wyloguj</button>
        </div>
      </div>

      {message && <div className="alert alert-success py-2">{message}</div>}
      {error && <div className="alert alert-danger py-2">{error}</div>}

      {!editing ? (
        <div className="row g-3 small">
          <div className="col-md-6"><strong>Email:</strong> {profile.email}</div>
          <div className="col-md-6"><strong>Wiek:</strong> {profile.age}</div>
          <div className="col-md-6"><strong>Płeć:</strong> {profile.sex}</div>
          <div className="col-md-6"><strong>Waga:</strong> {profile.weight} kg</div>
          <div className="col-md-6"><strong>Wzrost:</strong> {profile.height} cm</div>
          <div className="col-md-6"><strong>Sylwetka:</strong> {profile.bodyType}</div>
          <div className="col-md-6"><strong>Aktywność:</strong> {profile.activityHistory}</div>
          <div className="col-md-6"><strong>Cel:</strong> {profile.goal}</div>
          <div className="col-md-6"><strong>Dni treningowe:</strong> {profile.trainingDays.map((d) => dayLabels[d] || d).join(', ')}</div>
          <div className="col-md-6"><strong>Sprzęt:</strong> {profile.availableEquipment.join(', ')}</div>
          <div className="col-12"><strong>Nietolerancje:</strong> {profile.foodIntolerances || 'brak'}</div>
        </div>
      ) : (
        <div>
          <div className="mb-3">
            <label htmlFor="profile-weight" className="form-label">Waga (kg)</label>
            <input id="profile-weight" className="form-control" type="number" step="0.1" value={weight} onChange={(e) => setWeight(e.target.value)} />
          </div>
          <div className="mb-3">
            <label className="form-label">Dni treningowe</label>
            <div className="d-flex gap-1 flex-wrap">{allDays.map((day) => (
              <button key={day} type="button" className={`btn btn-sm ${trainingDays.includes(day) ? 'btn-success' : 'btn-outline-secondary'}`} onClick={() => toggleDay(day)}>
                {dayLabels[day]}
              </button>
            ))}</div>
          </div>
          <div className="mb-3">
            <label htmlFor="profile-goal" className="form-label">Cel</label>
            <select id="profile-goal" className="form-select" value={goal} onChange={(e) => setGoal(e.target.value)}>
              <option value="">-- wybierz --</option>
              {goalOptions.map((g) => <option key={g} value={g}>{g}</option>)}
            </select>
          </div>
          <div className="mb-3">
            <label htmlFor="profile-intolerances" className="form-label">Nietolerancje pokarmowe</label>
            <textarea id="profile-intolerances" className="form-control" rows={2} value={foodIntolerances} onChange={(e) => setFoodIntolerances(e.target.value)} />
          </div>
          <div className="mb-3">
            <label className="form-label">Dostępny sprzęt</label>
            <div className="d-flex gap-1 flex-wrap">{equipmentOptions.map((eq) => (
              <button key={eq} type="button" className={`btn btn-sm ${availableEquipment.includes(eq) ? 'btn-success' : 'btn-outline-secondary'}`} onClick={() => toggleEquipment(eq)}>
                {eq}
              </button>
            ))}</div>
          </div>
          <div className="d-flex gap-2">
            <button className="btn btn-success" disabled={saving} onClick={handleSave}>{saving ? 'Zapisywanie...' : 'Zapisz'}</button>
            <button className="btn btn-outline-secondary" onClick={() => setEditing(false)}>Anuluj</button>
          </div>
        </div>
      )}

      <hr className="my-4" />

      <h3 className="h6">Zmiana hasła</h3>
      {passwordMessage && <div className="alert alert-success py-2">{passwordMessage}</div>}
      {passwordError && <div className="alert alert-danger py-2">{passwordError}</div>}

      {!changingPassword ? (
        <button className="btn btn-outline-warning btn-sm" onClick={() => { setChangingPassword(true); setPasswordMessage(null); setPasswordError(null); }}>Zmień hasło</button>
      ) : (
        <div>
          <div className="mb-2">
            <label htmlFor="current-password" className="form-label">Aktualne hasło</label>
            <input id="current-password" className="form-control" type="password" value={currentPassword} onChange={(e) => setCurrentPassword(e.target.value)} />
          </div>
          <div className="mb-2">
            <label htmlFor="new-password" className="form-label">Nowe hasło</label>
            <input id="new-password" className="form-control" type="password" value={newPassword} onChange={(e) => setNewPassword(e.target.value)} />
          </div>
          <div className="mb-3">
            <label htmlFor="confirm-new-password" className="form-label">Powtórz nowe hasło</label>
            <input id="confirm-new-password" className="form-control" type="password" value={confirmNewPassword} onChange={(e) => setConfirmNewPassword(e.target.value)} />
          </div>
          <div className="d-flex gap-2">
            <button className="btn btn-warning" disabled={passwordSaving} onClick={handleChangePassword}>{passwordSaving ? 'Zapisywanie...' : 'Zmień hasło'}</button>
            <button className="btn btn-outline-secondary" onClick={() => setChangingPassword(false)}>Anuluj</button>
          </div>
        </div>
      )}
    </div>
  </div>;
}
