package pl.platformatreningowa.auth.control;

import static org.assertj.core.api.Assertions.assertThat;

import io.jsonwebtoken.Claims;
import org.junit.jupiter.api.Test;
import pl.platformatreningowa.auth.entity.UserEntity;

class JwtServiceTest {

    @Test
    void generateTokenIncludesAuthAndConsentClaims() {
        JwtService jwtService = new JwtService("test-secret-key-test-secret-key-123456", 60);
        UserEntity user = new UserEntity();
        user.setId(7L);
        user.setEmail("runner@example.com");
        user.setOnboardingCompleted(false);
        user.setTermsAccepted(true);
        user.setHealthStatementAccepted(true);
        user.setPrivacyPolicyAccepted(true);
        user.setLegalAcceptedAt(java.time.Instant.parse("2026-03-20T12:00:00Z"));

        String token = jwtService.generateToken(user);
        Claims claims = jwtService.parseToken(token);

        assertThat(claims.getSubject()).isEqualTo("7");
        assertThat(claims.get("email", String.class)).isEqualTo("runner@example.com");
        assertThat(claims.get("onboardingCompleted", Boolean.class)).isFalse();
        assertThat(claims.get("legalConsentsAccepted", Boolean.class)).isTrue();
    }
}
