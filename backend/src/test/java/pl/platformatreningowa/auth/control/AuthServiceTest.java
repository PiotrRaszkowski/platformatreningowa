package pl.platformatreningowa.auth.control;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.verify;

import java.util.Optional;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;
import pl.platformatreningowa.auth.entity.AuthResponse;
import pl.platformatreningowa.auth.entity.LoginRequest;
import pl.platformatreningowa.auth.entity.RegisterRequest;
import pl.platformatreningowa.auth.entity.UserEntity;
import pl.platformatreningowa.shared.entity.ConflictException;
import pl.platformatreningowa.shared.entity.UnauthorizedException;
import pl.platformatreningowa.shared.entity.ValidationException;

@ExtendWith(MockitoExtension.class)
class AuthServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private JwtService jwtService;

    @InjectMocks
    private AuthService authService;

    @Captor
    private ArgumentCaptor<UserEntity> userCaptor;

    private UserEntity user;

    @BeforeEach
    void setUp() {
        user = new UserEntity();
        user.setId(7L);
        user.setEmail("runner@example.com");
        user.setPasswordHash("encoded-password");
        user.setOnboardingCompleted(false);
        user.setTermsAccepted(false);
        user.setHealthStatementAccepted(false);
        user.setPrivacyPolicyAccepted(false);
    }

    @Test
    void registerCreatesUserAndReturnsLegalConsentRedirect() {
        RegisterRequest request = new RegisterRequest("Runner@Example.com", "password123", "password123");
        given(userRepository.existsByEmailIgnoreCase("runner@example.com")).willReturn(false);
        given(passwordEncoder.encode("password123")).willReturn("encoded-password");
        given(userRepository.save(any(UserEntity.class))).willAnswer(invocation -> {
            UserEntity saved = invocation.getArgument(0);
            saved.setId(7L);
            return saved;
        });
        given(jwtService.generateToken(any(UserEntity.class))).willReturn("jwt-token");

        AuthResponse response = authService.register(request);

        verify(userRepository).save(userCaptor.capture());
        assertThat(userCaptor.getValue().isTermsAccepted()).isFalse();
        assertThat(userCaptor.getValue().getLegalAcceptedAt()).isNull();
        assertThat(response.redirectTo()).isEqualTo("/legal-consents");
        assertThat(response.legalConsentsAccepted()).isFalse();
    }

    @Test
    void registerRejectsMismatchedPasswords() {
        RegisterRequest request = new RegisterRequest("runner@example.com", "password123", "password999");

        assertThatThrownBy(() -> authService.register(request))
                .isInstanceOf(ValidationException.class)
                .hasMessage("Passwords do not match");
    }

    @Test
    void registerRejectsDuplicateEmail() {
        RegisterRequest request = new RegisterRequest("runner@example.com", "password123", "password123");
        given(userRepository.existsByEmailIgnoreCase("runner@example.com")).willReturn(true);

        assertThatThrownBy(() -> authService.register(request))
                .isInstanceOf(ConflictException.class)
                .hasMessage("User with this email already exists");
    }

    @Test
    void loginReturnsLegalConsentRedirectWhenConsentsMissing() {
        given(userRepository.findByEmailIgnoreCase("runner@example.com")).willReturn(Optional.of(user));
        given(passwordEncoder.matches("password123", "encoded-password")).willReturn(true);
        given(jwtService.generateToken(user)).willReturn("jwt-token");

        AuthResponse response = authService.login(new LoginRequest("runner@example.com", "password123"));

        assertThat(response.onboardingCompleted()).isFalse();
        assertThat(response.legalConsentsAccepted()).isFalse();
        assertThat(response.redirectTo()).isEqualTo("/legal-consents");
    }

    @Test
    void loginReturnsDashboardRedirectForCompletedOnboardingAndConsents() {
        user.setOnboardingCompleted(true);
        user.setTermsAccepted(true);
        user.setHealthStatementAccepted(true);
        user.setPrivacyPolicyAccepted(true);
        user.setLegalAcceptedAt(java.time.Instant.parse("2026-03-20T12:00:00Z"));
        given(userRepository.findByEmailIgnoreCase("runner@example.com")).willReturn(Optional.of(user));
        given(passwordEncoder.matches("password123", "encoded-password")).willReturn(true);
        given(jwtService.generateToken(user)).willReturn("jwt-token");

        AuthResponse response = authService.login(new LoginRequest("runner@example.com", "password123"));

        assertThat(response.onboardingCompleted()).isTrue();
        assertThat(response.legalConsentsAccepted()).isTrue();
        assertThat(response.redirectTo()).isEqualTo("/dashboard");
    }

    @Test
    void loginRejectsInvalidPassword() {
        given(userRepository.findByEmailIgnoreCase("runner@example.com")).willReturn(Optional.of(user));
        given(passwordEncoder.matches("wrong-password", "encoded-password")).willReturn(false);

        assertThatThrownBy(() -> authService.login(new LoginRequest("runner@example.com", "wrong-password")))
                .isInstanceOf(UnauthorizedException.class)
                .hasMessage("Invalid email or password");
    }
}
