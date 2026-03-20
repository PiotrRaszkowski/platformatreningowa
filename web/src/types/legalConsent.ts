export interface LegalConsentState {
  termsAccepted: boolean;
  healthStatementAccepted: boolean;
  privacyPolicyAccepted: boolean;
  acceptedAt: string | null;
  completed: boolean;
}

export interface SaveLegalConsentRequest {
  termsAccepted: boolean;
  healthStatementAccepted: boolean;
  privacyPolicyAccepted: boolean;
}
