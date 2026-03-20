package pl.platformatreningowa.auth.control;

import static org.assertj.core.api.Assertions.assertThat;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import java.nio.charset.StandardCharsets;
import org.junit.jupiter.api.Test;
import pl.platformatreningowa.auth.entity.UserEntity;

class JwtServiceTest {

    @Test
    void generateTokenIncludesExpectedClaims() {
        String secret = "01234567890123456789012345678901";
        JwtService jwtService = new JwtService(secret, 60);
        UserEntity user = new UserEntity();
        user.setId(7L);
        user.setEmail("runner@example.com");
        user.setOnboardingCompleted(false);

        String token = jwtService.generateToken(user);

        Claims claims = Jwts.parser()
                .verifyWith(Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8)))
                .build()
                .parseSignedClaims(token)
                .getPayload();

        assertThat(claims.getSubject()).isEqualTo("7");
        assertThat(claims.get("email", String.class)).isEqualTo("runner@example.com");
        assertThat(claims.get("onboardingCompleted", Boolean.class)).isFalse();
    }
}
