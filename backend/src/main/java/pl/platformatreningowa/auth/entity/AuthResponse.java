package pl.platformatreningowa.auth.entity;

public record AuthResponse(
        String token,
        String email,
        boolean onboardingCompleted,
        boolean legalConsentsAccepted,
        String redirectTo
) {
}
