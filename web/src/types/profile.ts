export interface UserProfile {
  email: string;
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
}

export interface UpdateProfileRequest {
  weight: number;
  trainingDays: string[];
  goal: string;
  foodIntolerances: string;
  availableEquipment: string[];
}

export interface ChangePasswordRequest {
  currentPassword: string;
  newPassword: string;
  confirmNewPassword: string;
}
