import type { AuthRequest, AuthResponse } from '../types/auth';

const registeredUsers = new Map<string, { password: string; onboardingCompleted: boolean }>();

function delay<T>(value: T): Promise<T> {
  return new Promise((resolve) => setTimeout(() => resolve(value), 150));
}

export async function register(request: AuthRequest): Promise<AuthResponse> {
  const email = request.email.trim().toLowerCase();
  if (registeredUsers.has(email)) {
    throw new Error('Użytkownik z tym adresem e-mail już istnieje.');
  }

  registeredUsers.set(email, {
    password: request.password,
    onboardingCompleted: false
  });

  return delay({
    token: `mock-token-${email}`,
    email,
    onboardingCompleted: false,
    redirectTo: '/onboarding'
  });
}

export async function login(request: AuthRequest): Promise<AuthResponse> {
  const email = request.email.trim().toLowerCase();
  const user = registeredUsers.get(email);

  if (!user || user.password !== request.password) {
    throw new Error('Nieprawidłowy email lub hasło.');
  }

  return delay({
    token: `mock-token-${email}`,
    email,
    onboardingCompleted: user.onboardingCompleted,
    redirectTo: user.onboardingCompleted ? '/dashboard' : '/onboarding'
  });
}

export function seedAuthUser(email: string, password: string, onboardingCompleted: boolean): void {
  registeredUsers.set(email.trim().toLowerCase(), { password, onboardingCompleted });
}
