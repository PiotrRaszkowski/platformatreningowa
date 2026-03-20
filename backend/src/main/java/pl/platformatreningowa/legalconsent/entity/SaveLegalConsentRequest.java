package pl.platformatreningowa.legalconsent.entity;

import jakarta.validation.constraints.AssertTrue;

public record SaveLegalConsentRequest(
        @AssertTrue(message = "Regulamin musi zostać zaakceptowany")
        boolean termsAccepted,
        @AssertTrue(message = "Oświadczenie zdrowotne musi zostać zaakceptowane")
        boolean healthStatementAccepted,
        @AssertTrue(message = "Zgoda RODO musi zostać zaakceptowana")
        boolean privacyPolicyAccepted
) {
}
