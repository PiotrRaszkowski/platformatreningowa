import { useMemo, useState } from 'react';
import { saveOnboardingProfile } from '../services/authService';
import type { AuthResponse } from '../types/auth';
import type { OnboardingProfile } from '../types/onboarding';

interface Props {
  authResult: AuthResponse;
  onCompleted: (profile: OnboardingProfile) => void;
}

const dayOptions = [
  ['MON', 'Pon'], ['TUE', 'Wt'], ['WED', 'Śr'], ['THU', 'Czw'], ['FRI', 'Pt'], ['SAT', 'Sob'], ['SUN', 'Niedz']
] as const;
const bodyTypes = ['szczupły', 'średni', 'nadwaga', 'masywny'];
const activityOptions = ['nigdy', 'okazjonalnie', 'regularnie', 'zaawansowany'];
const goalOptions = ['schudnąć', 'poprawić kondycję', 'biegać szybciej', 'zacząć się ruszać', 'przygotowanie do zawodów'];
const equipmentOptions = ['nic', 'hantle', 'gumy', 'siłownia'];
const sexOptions = ['kobieta', 'mężczyzna', 'inna', 'wolę nie podawać'];

const emptyForm: OnboardingProfile = {
  age: null, sex: '', weight: '', height: '', bodyType: '', activityHistory: '', trainingDays: [], goal: '', targetDistance: '', targetTime: '', foodIntolerances: '', availableEquipment: [], onboardingCompleted: false
};

export function OnboardingCard({ authResult, onCompleted }: Props) {
  const [form, setForm] = useState<OnboardingProfile>(emptyForm);
  const [step, setStep] = useState(0);
  const [error, setError] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);


  const stepError = useMemo(() => {
    if (step === 0) {
      if (!form.age || form.age < 12 || form.age > 100) return 'Wiek musi być w zakresie 12-100.';
      if (!form.sex) return 'Wybierz płeć.';
      if (!form.weight || Number(form.weight) < 30) return 'Podaj poprawną wagę.';
      if (!form.height || Number(form.height) < 120) return 'Podaj poprawny wzrost.';
      if (!form.bodyType) return 'Wybierz typ sylwetki.';
      if (!form.activityHistory) return 'Wybierz historię aktywności.';
    }
    if (step === 1) {
      if (form.trainingDays.length === 0) return 'Wybierz co najmniej jeden dzień treningowy.';
      if (!form.goal) return 'Wybierz cel.';
    }
    if (step === 2 && form.availableEquipment.length === 0) return 'Wybierz dostępny sprzęt.';
    return null;
  }, [form, step]);

  const toggleMulti = (field: 'trainingDays' | 'availableEquipment', value: string) => {
    setForm((current) => ({
      ...current,
      [field]: current[field].includes(value) ? current[field].filter((item) => item !== value) : [...current[field], value]
    }));
  };

  const nextStep = () => {
    if (stepError) {
      setError(stepError);
      return;
    }
    setError(null);
    setStep((current) => Math.min(current + 1, 2));
  };

  const submit = async () => {
    if (stepError) {
      setError(stepError);
      return;
    }
    setError(null);
    setIsSubmitting(true);
    try {
      const saved = await saveOnboardingProfile(authResult.token, {
        age: form.age,
        sex: form.sex,
        weight: form.weight,
        height: form.height,
        bodyType: form.bodyType,
        activityHistory: form.activityHistory,
        trainingDays: form.trainingDays,
        goal: form.goal,
        targetDistance: form.targetDistance,
        targetTime: form.targetTime,
        foodIntolerances: form.foodIntolerances,
        availableEquipment: form.availableEquipment
      });
      onCompleted(saved);
    } catch (e) {
      setError(e instanceof Error ? e.message : 'Nie udało się zapisać ankiety.');
    } finally {
      setIsSubmitting(false);
    }
  };

  return <div className="card shadow-sm"><div className="card-body p-4">
    <div className="d-flex justify-content-between align-items-center mb-3"><h2 className="h4 mb-0">Ankieta startowa</h2><span className="badge text-bg-success">Krok {step + 1}/3</span></div>
    {step === 0 && <>
      <div className="row g-3">
        <div className="col-md-6"><label className="form-label">Wiek</label><input aria-label="Wiek" className="form-control" type="number" value={form.age ?? ''} onChange={(e) => setForm((c) => ({ ...c, age: Number(e.target.value) }))} /></div>
        <div className="col-md-6"><label className="form-label">Płeć</label><select aria-label="Płeć" className="form-select" value={form.sex} onChange={(e) => setForm((c) => ({ ...c, sex: e.target.value }))}><option value="">Wybierz</option>{sexOptions.map((o) => <option key={o} value={o}>{o}</option>)}</select></div>
        <div className="col-md-6"><label className="form-label">Waga (kg)</label><input aria-label="Waga (kg)" className="form-control" value={form.weight} onChange={(e) => setForm((c) => ({ ...c, weight: e.target.value }))} /></div>
        <div className="col-md-6"><label className="form-label">Wzrost (cm)</label><input aria-label="Wzrost (cm)" className="form-control" value={form.height} onChange={(e) => setForm((c) => ({ ...c, height: e.target.value }))} /></div>
        <div className="col-md-6"><label className="form-label">Typ sylwetki</label><select aria-label="Typ sylwetki" className="form-select" value={form.bodyType} onChange={(e) => setForm((c) => ({ ...c, bodyType: e.target.value }))}><option value="">Wybierz</option>{bodyTypes.map((o) => <option key={o} value={o}>{o}</option>)}</select></div>
        <div className="col-md-6"><label className="form-label">Historia aktywności</label><select aria-label="Historia aktywności" className="form-select" value={form.activityHistory} onChange={(e) => setForm((c) => ({ ...c, activityHistory: e.target.value }))}><option value="">Wybierz</option>{activityOptions.map((o) => <option key={o} value={o}>{o}</option>)}</select></div>
      </div>
    </>}
    {step === 1 && <>
      <p className="text-secondary mb-2">Wybierz dostępne dni i główny cel.</p>
      <div className="mb-3"><div className="d-flex flex-wrap gap-2">{dayOptions.map(([value, label]) => <button type="button" key={value} className={`btn ${form.trainingDays.includes(value) ? 'btn-success' : 'btn-outline-success'}`} onClick={() => toggleMulti('trainingDays', value)}>{label}</button>)}</div></div>
      <label className="form-label">Cel</label><select aria-label="Cel" className="form-select" value={form.goal} onChange={(e) => setForm((c) => ({ ...c, goal: e.target.value }))}><option value="">Wybierz</option>{goalOptions.map((o) => <option key={o} value={o}>{o}</option>)}</select>
      <div className="row g-3 mt-1"><div className="col-md-6"><label className="form-label">Docelowy dystans (opcjonalnie)</label><input aria-label="Docelowy dystans (opcjonalnie)" className="form-control" value={form.targetDistance} onChange={(e) => setForm((c) => ({ ...c, targetDistance: e.target.value }))} /></div><div className="col-md-6"><label className="form-label">Docelowy czas (opcjonalnie)</label><input aria-label="Docelowy czas (opcjonalnie)" className="form-control" value={form.targetTime} onChange={(e) => setForm((c) => ({ ...c, targetTime: e.target.value }))} /></div></div>
    </>}
    {step === 2 && <>
      <label className="form-label">Nietolerancje pokarmowe (opcjonalnie)</label><textarea aria-label="Nietolerancje pokarmowe (opcjonalnie)" className="form-control mb-3" value={form.foodIntolerances} onChange={(e) => setForm((c) => ({ ...c, foodIntolerances: e.target.value }))} />
      <p className="mb-2">Dostępny sprzęt</p><div className="d-flex flex-wrap gap-2">{equipmentOptions.map((value) => <button type="button" key={value} className={`btn ${form.availableEquipment.includes(value) ? 'btn-success' : 'btn-outline-success'}`} onClick={() => toggleMulti('availableEquipment', value)}>{value}</button>)}</div>
    </>}
    {error && <div className="alert alert-danger py-2 mt-3">{error}</div>}
    <div className="d-flex justify-content-between mt-4"><button type="button" className="btn btn-outline-secondary" disabled={step === 0} onClick={() => setStep((current) => current - 1)}>Wstecz</button>{step < 2 ? <button type="button" className="btn btn-success" onClick={nextStep}>Dalej</button> : <button type="button" className="btn btn-success" onClick={submit} disabled={isSubmitting}>{isSubmitting ? 'Zapisywanie...' : 'Zapisz i przejdź do dashboardu'}</button>}</div>
  </div></div>;
}
