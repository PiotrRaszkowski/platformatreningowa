import type { AuthRequest, AuthResponse } from '../types/auth';
import type { LegalConsentState, SaveLegalConsentRequest } from '../types/legalConsent';
import type { OnboardingProfile, SaveOnboardingProfileRequest } from '../types/onboarding';
import type { UserProfile, UpdateProfileRequest, ChangePasswordRequest } from '../types/profile';

type MockUser = {
  password: string;
  onboardingCompleted: boolean;
  consents: LegalConsentState;
  profile: OnboardingProfile;
};

const emptyProfile: OnboardingProfile = {
  age: null,
  sex: '',
  weight: '',
  height: '',
  bodyType: '',
  activityHistory: '',
  trainingDays: [],
  goal: '',
  targetDistance: '',
  targetTime: '',
  foodIntolerances: '',
  availableEquipment: [],
  onboardingCompleted: false
};

const registeredUsers = new Map<string, MockUser>();

function delay<T>(value: T): Promise<T> {
  return new Promise((resolve) => setTimeout(() => resolve(value), 100));
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
  if (registeredUsers.has(email)) throw new Error('Użytkownik z tym adresem e-mail już istnieje.');
  const user: MockUser = {
    password: request.password,
    onboardingCompleted: false,
    consents: { termsAccepted: false, healthStatementAccepted: false, privacyPolicyAccepted: false, acceptedAt: null, completed: false },
    profile: { ...emptyProfile }
  };
  registeredUsers.set(email, user);
  return delay(toAuthResponse(email, user));
}

export async function login(request: AuthRequest): Promise<AuthResponse> {
  const email = request.email.trim().toLowerCase();
  const user = registeredUsers.get(email);
  if (!user || user.password !== request.password) throw new Error('Nieprawidłowy email lub hasło.');
  return delay(toAuthResponse(email, user));
}

export async function getLegalConsents(token: string): Promise<LegalConsentState> {
  const user = registeredUsers.get(getEmailFromToken(token));
  if (!user) throw new Error('Nie znaleziono użytkownika.');
  return delay({ ...user.consents });
}

export async function saveLegalConsents(token: string, request: SaveLegalConsentRequest): Promise<LegalConsentState> {
  if (!request.termsAccepted || !request.healthStatementAccepted || !request.privacyPolicyAccepted) {
    throw new Error('Zaakceptuj regulamin, oświadczenie zdrowotne i RODO.');
  }
  const user = registeredUsers.get(getEmailFromToken(token));
  if (!user) throw new Error('Nie znaleziono użytkownika.');
  user.consents = { ...request, acceptedAt: new Date().toISOString(), completed: true };
  return delay({ ...user.consents });
}

export async function getOnboardingProfile(token: string): Promise<OnboardingProfile> {
  const user = registeredUsers.get(getEmailFromToken(token));
  if (!user) throw new Error('Nie znaleziono użytkownika.');
  return { ...user.profile, trainingDays: [...user.profile.trainingDays], availableEquipment: [...user.profile.availableEquipment] };
}


export async function saveOnboardingProfile(token: string, request: SaveOnboardingProfileRequest): Promise<OnboardingProfile> {
  const user = registeredUsers.get(getEmailFromToken(token));
  if (!user) throw new Error('Nie znaleziono użytkownika.');
  user.profile = { ...request, onboardingCompleted: true };
  user.onboardingCompleted = true;
  return { ...user.profile, trainingDays: [...user.profile.trainingDays], availableEquipment: [...user.profile.availableEquipment] };
}


export async function getUserProfile(token: string): Promise<UserProfile> {
  const user = registeredUsers.get(getEmailFromToken(token));
  if (!user) throw new Error('Nie znaleziono użytkownika.');
  const p = user.profile;
  return delay({
    email: getEmailFromToken(token),
    age: p.age,
    sex: p.sex,
    weight: p.weight,
    height: p.height,
    bodyType: p.bodyType,
    activityHistory: p.activityHistory,
    trainingDays: [...p.trainingDays],
    goal: p.goal,
    targetDistance: p.targetDistance,
    targetTime: p.targetTime,
    foodIntolerances: p.foodIntolerances,
    availableEquipment: [...p.availableEquipment],
  });
}

export async function updateUserProfile(token: string, request: UpdateProfileRequest): Promise<UserProfile> {
  const user = registeredUsers.get(getEmailFromToken(token));
  if (!user) throw new Error('Nie znaleziono użytkownika.');
  user.profile = {
    ...user.profile,
    weight: String(request.weight),
    trainingDays: [...request.trainingDays],
    goal: request.goal,
    foodIntolerances: request.foodIntolerances,
    availableEquipment: [...request.availableEquipment],
  };
  return getUserProfile(token);
}

export async function changePassword(token: string, request: ChangePasswordRequest): Promise<void> {
  const user = registeredUsers.get(getEmailFromToken(token));
  if (!user) throw new Error('Nie znaleziono użytkownika.');
  if (user.password !== request.currentPassword) throw new Error('Nieprawidłowe aktualne hasło.');
  if (request.newPassword !== request.confirmNewPassword) throw new Error('Nowe hasła muszą być identyczne.');
  if (request.newPassword.length < 8) throw new Error('Nowe hasło musi mieć co najmniej 8 znaków.');
  user.password = request.newPassword;
  await delay(undefined);
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
    },
    profile: onboardingCompleted ? {
      age: 31,
      sex: 'mężczyzna',
      weight: '76.5',
      height: '182',
      bodyType: 'średni',
      activityHistory: 'regularnie',
      trainingDays: ['MON', 'WED'],
      goal: 'poprawić kondycję',
      targetDistance: '10',
      targetTime: '50:00',
      foodIntolerances: 'laktoza',
      availableEquipment: ['gumy'],
      onboardingCompleted: true
    } : { ...emptyProfile }
  });
}
