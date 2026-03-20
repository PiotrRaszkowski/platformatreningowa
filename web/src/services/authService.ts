import type { AuthRequest, AuthResponse } from '../types/auth';
import type { LegalConsentState, SaveLegalConsentRequest } from '../types/legalConsent';

type MockUser = {
  password: string;
  onboardingCompleted: boolean;
  consents: LegalConsentState;
};

const registeredUsers = new Map<string, MockUser>();

function delay<T>(value: T): Promise<T> {
  return new Promise((resolve) => setTimeout(() => resolve(value), 150));
}

function createToken(email: string): string {
  return `mock-token-${email}`;
}

function getEmailFromToken(token: string): string {
  return token.replace('mock-token-', '');
}

function toAuthResponse(email: string, user: MockUser): AuthResponse {
  return {
    token: createToken(email),
    email,
    onboardingCompleted: user.onboardingCompleted,
    legalConsentsAccepted: user.consents.completed,
    redirectTo: user.consents.completed ? (user.onboardingCompleted ? '/dashboard' : '/onboarding') : '/legal-consents'
  };
}

export async function register(request: AuthRequest): Promise<AuthResponse> {
  const email = request.email.trim().toLowerCase();
  if (registeredUsers.has(email)) {
    throw new Error('Użytkownik z tym adresem e-mail już istnieje.');
  }

  const user: MockUser = {
    password: request.password,
    onboardingCompleted: false,
    consents: {
      termsAccepted: false,
      healthStatementAccepted: false,
      privacyPolicyAccepted: false,
      acceptedAt: null,
      completed: false
    }
  };
  registeredUsers.set(email, user);

  return delay(toAuthResponse(email, user));
}

export async function login(request: AuthRequest): Promise<AuthResponse> {
  const email = request.email.trim().toLowerCase();
  const user = registeredUsers.get(email);

  if (!user || user.password !== request.password) {
    throw new Error('Nieprawidłowy email lub hasło.');
  }

  return delay(toAuthResponse(email, user));
}

export async function getLegalConsents(token: string): Promise<LegalConsentState> {
  const user = registeredUsers.get(getEmailFromToken(token));
  if (!user) {
    throw new Error('Nie znaleziono użytkownika.');
  }
  return delay({ ...user.consents });
}

export async function saveLegalConsents(token: string, request: SaveLegalConsentRequest): Promise<LegalConsentState> {
  if (!request.termsAccepted || !request.healthStatementAccepted || !request.privacyPolicyAccepted) {
    throw new Error('Zaakceptuj regulamin, oświadczenie zdrowotne i RODO.');
  }

  const email = getEmailFromToken(token);
  const user = registeredUsers.get(email);
  if (!user) {
    throw new Error('Nie znaleziono użytkownika.');
  }

  user.consents = {
    ...request,
    acceptedAt: new Date().toISOString(),
    completed: true
  };

  return delay({ ...user.consents });
}

export function seedAuthUser(email: string, password: string, onboardingCompleted: boolean, legalConsentsAccepted = true): void {
  registeredUsers.set(email.trim().toLowerCase(), {
    password,
    onboardingCompleted,
    consents: {
      termsAccepted: legalConsentsAccepted,
      healthStatementAccepted: legalConsentsAccepted,
      privacyPolicyAccepted: legalConsentsAccepted,
      acceptedAt: legalConsentsAccepted ? '2026-03-20T12:00:00.000Z' : null,
      completed: legalConsentsAccepted
    }
  });
}
