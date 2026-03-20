package pl.platformatreningowa.legalconsent.entity;

import java.time.Instant;

public record LegalConsent(
        boolean termsAccepted,
        boolean healthStatementAccepted,
        boolean privacyPolicyAccepted,
        Instant acceptedAt,
        boolean completed
) {
}
