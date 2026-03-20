export interface AuthRequest {
  email: string;
  password: string;
  confirmPassword?: string;
}

export interface AuthResponse {
  token: string;
  email: string;
  onboardingCompleted: boolean;
  legalConsentsAccepted: boolean;
  redirectTo: '/legal-consents' | '/onboarding' | '/dashboard';
}
