export interface OnboardingProfile {
  age: number | null;
  sex: string;
  weight: string;
  height: string;
  bodyType: string;
  activityHistory: string;
  trainingDays: string[];
  goal: string;
  targetDistance: string;
  targetTime: string;
  foodIntolerances: string;
  availableEquipment: string[];
  onboardingCompleted: boolean;
}

export type SaveOnboardingProfileRequest = Omit<OnboardingProfile, 'onboardingCompleted'>;
