import { useEffect, useState } from 'react';
import { getLegalConsents, saveLegalConsents } from '../services/authService';
import type { AuthResponse } from '../types/auth';
import type { LegalConsentState } from '../types/legalConsent';

interface LegalConsentCardProps {
  authResult: AuthResponse;
  onCompleted: (acceptedAt: string) => void;
}

const initialState: LegalConsentState = {
  termsAccepted: false,
  healthStatementAccepted: false,
  privacyPolicyAccepted: false,
  acceptedAt: null,
  completed: false
};

export function LegalConsentCard({ authResult, onCompleted }: LegalConsentCardProps) {
  const [consentState, setConsentState] = useState<LegalConsentState>(initialState);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    getLegalConsents(authResult.token)
      .then(setConsentState)
      .catch((loadError: Error) => setError(loadError.message));
  }, [authResult.token]);

  const allChecked = consentState.termsAccepted && consentState.healthStatementAccepted && consentState.privacyPolicyAccepted;

  const updateCheckbox = (field: 'termsAccepted' | 'healthStatementAccepted' | 'privacyPolicyAccepted') => {
    setConsentState((current) => ({ ...current, [field]: !current[field] }));
  };

  const handleSubmit = async () => {
    setIsSubmitting(true);
    setError(null);
    try {
      const saved = await saveLegalConsents(authResult.token, {
        termsAccepted: consentState.termsAccepted,
        healthStatementAccepted: consentState.healthStatementAccepted,
        privacyPolicyAccepted: consentState.privacyPolicyAccepted
      });
      setConsentState(saved);
      onCompleted(saved.acceptedAt ?? new Date().toISOString());
    } catch (saveError) {
      setError(saveError instanceof Error ? saveError.message : 'Nie udało się zapisać zgód.');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="card shadow-sm">
      <div className="card-body">
        <span className="badge text-bg-warning mb-3">Krok obowiązkowy</span>
        <h2 className="h4">Regulamin, disclaimer i odpowiedzialność</h2>
        <p className="text-secondary">
          Platforma nie zastępuje lekarza ani trenera prowadzącego. Korzystasz z planów i rekomendacji na własną
          odpowiedzialność. W razie wątpliwości zdrowotnych skonsultuj się z lekarzem.
        </p>

        <div className="border rounded p-3 bg-light mb-3">
          <p className="fw-semibold mb-2">Najważniejsze punkty</p>
          <ul className="mb-0 ps-3">
            <li>Akceptujesz regulamin świadczenia usługi.</li>
            <li>Potwierdzasz, że Twój stan zdrowia pozwala na trening lub masz zgodę specjalisty.</li>
            <li>Akceptujesz przetwarzanie danych zgodnie z polityką prywatności / RODO.</li>
          </ul>
        </div>

        <div className="form-check mb-2">
          <input id="termsAccepted" className="form-check-input" type="checkbox" checked={consentState.termsAccepted} onChange={() => updateCheckbox('termsAccepted')} />
          <label className="form-check-label" htmlFor="termsAccepted">Akceptuję regulamin platformy.</label>
        </div>
        <div className="form-check mb-2">
          <input id="healthStatementAccepted" className="form-check-input" type="checkbox" checked={consentState.healthStatementAccepted} onChange={() => updateCheckbox('healthStatementAccepted')} />
          <label className="form-check-label" htmlFor="healthStatementAccepted">Oświadczam, że biorę odpowiedzialność za stan zdrowia i trening.</label>
        </div>
        <div className="form-check mb-3">
          <input id="privacyPolicyAccepted" className="form-check-input" type="checkbox" checked={consentState.privacyPolicyAccepted} onChange={() => updateCheckbox('privacyPolicyAccepted')} />
          <label className="form-check-label" htmlFor="privacyPolicyAccepted">Akceptuję politykę prywatności i przetwarzanie danych osobowych (RODO).</label>
        </div>

        {error && <div className="alert alert-danger py-2">{error}</div>}
        {consentState.acceptedAt && <div className="alert alert-success py-2">Zgody zapisane: {consentState.acceptedAt}</div>}

        <button className="btn btn-success" onClick={handleSubmit} disabled={isSubmitting || !allChecked}>
          {isSubmitting ? 'Zapisywanie...' : 'Akceptuję i kontynuuję'}
        </button>
      </div>
    </div>
  );
}
