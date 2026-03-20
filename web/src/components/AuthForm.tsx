import { useMemo, useState } from 'react';
import type { AuthResponse } from '../types/auth';
import { login, register } from '../services/authService';

interface AuthFormProps {
  mode: 'login' | 'register';
  onAuthenticated: (response: AuthResponse) => void;
}

interface FormState {
  email: string;
  password: string;
  confirmPassword: string;
}

export function AuthForm({ mode, onAuthenticated }: AuthFormProps) {
  const [form, setForm] = useState<FormState>({ email: '', password: '', confirmPassword: '' });
  const [error, setError] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const title = mode === 'login' ? 'Logowanie' : 'Rejestracja';
  const buttonLabel = mode === 'login' ? 'Zaloguj się' : 'Załóż konto';

  const validationError = useMemo(() => {
    if (!form.email.trim()) return 'Email jest wymagany.';
    if (!/^\S+@\S+\.\S+$/.test(form.email)) return 'Podaj poprawny adres e-mail.';
    if (!form.password) return 'Hasło jest wymagane.';
    if (form.password.length < 8) return 'Hasło musi mieć co najmniej 8 znaków.';
    if (mode === 'register' && !form.confirmPassword) return 'Potwierdzenie hasła jest wymagane.';
    if (mode === 'register' && form.password !== form.confirmPassword) return 'Hasła muszą być identyczne.';
    return null;
  }, [form, mode]);

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setError(null);

    if (validationError) {
      setError(validationError);
      return;
    }

    setIsSubmitting(true);
    try {
      const response = mode === 'login' ? await login(form) : await register(form);
      onAuthenticated(response);
    } catch (submissionError) {
      setError(submissionError instanceof Error ? submissionError.message : 'Nie udało się uwierzytelnić użytkownika.');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="card shadow-sm">
      <div className="card-body p-4">
        <h2 className="h4 mb-4">{title}</h2>
        <form onSubmit={handleSubmit} noValidate>
          <div className="mb-3">
            <label htmlFor={`${mode}-email`} className="form-label">Email</label>
            <input
              id={`${mode}-email`}
              className="form-control"
              type="email"
              value={form.email}
              onChange={(event) => setForm((current) => ({ ...current, email: event.target.value }))}
              placeholder="runner@example.com"
            />
          </div>
          <div className="mb-3">
            <label htmlFor={`${mode}-password`} className="form-label">Hasło</label>
            <input
              id={`${mode}-password`}
              className="form-control"
              type="password"
              value={form.password}
              onChange={(event) => setForm((current) => ({ ...current, password: event.target.value }))}
            />
          </div>
          {mode === 'register' && (
            <div className="mb-3">
              <label htmlFor="register-confirm-password" className="form-label">Powtórz hasło</label>
              <input
                id="register-confirm-password"
                className="form-control"
                type="password"
                value={form.confirmPassword}
                onChange={(event) => setForm((current) => ({ ...current, confirmPassword: event.target.value }))}
              />
            </div>
          )}
          {error && <div className="alert alert-danger py-2">{error}</div>}
          <button type="submit" className="btn btn-success w-100" disabled={isSubmitting}>
            {isSubmitting ? 'Przetwarzanie...' : buttonLabel}
          </button>
        </form>
      </div>
    </div>
  );
}
