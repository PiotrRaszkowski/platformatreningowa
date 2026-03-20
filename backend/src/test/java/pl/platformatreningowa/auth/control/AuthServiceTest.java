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

    private UserEntity user;

    @BeforeEach
    void setUp() {
        user = new UserEntity();
        user.setId(1L);
        user.setEmail("runner@example.com");
        user.setPasswordHash("hashed-password");
        user.setOnboardingCompleted(false);
    }

    @Test
    void registerCreatesUserAndReturnsOnboardingRedirect() {
        RegisterRequest request = new RegisterRequest("Runner@Example.com", "password123", "password123");
        given(userRepository.existsByEmailIgnoreCase("runner@example.com")).willReturn(false);
        given(passwordEncoder.encode("password123")).willReturn("hashed-password");
        given(userRepository.save(any(UserEntity.class))).willReturn(user);
        given(jwtService.generateToken(user)).willReturn("jwt-token");

        AuthResponse response = authService.register(request);

        assertThat(response.token()).isEqualTo("jwt-token");
        assertThat(response.email()).isEqualTo("runner@example.com");
        assertThat(response.redirectTo()).isEqualTo("/onboarding");
        verify(userRepository).save(any(UserEntity.class));
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
    void loginReturnsDashboardRedirectForCompletedOnboarding() {
        user.setOnboardingCompleted(true);
        given(userRepository.findByEmailIgnoreCase("runner@example.com")).willReturn(Optional.of(user));
        given(passwordEncoder.matches("password123", "hashed-password")).willReturn(true);
        given(jwtService.generateToken(user)).willReturn("jwt-token");

        AuthResponse response = authService.login(new LoginRequest("runner@example.com", "password123"));

        assertThat(response.redirectTo()).isEqualTo("/dashboard");
        assertThat(response.onboardingCompleted()).isTrue();
    }

    @Test
    void loginRejectsInvalidPassword() {
        given(userRepository.findByEmailIgnoreCase("runner@example.com")).willReturn(Optional.of(user));
        given(passwordEncoder.matches("wrong-password", "hashed-password")).willReturn(false);

        assertThatThrownBy(() -> authService.login(new LoginRequest("runner@example.com", "wrong-password")))
                .isInstanceOf(UnauthorizedException.class)
                .hasMessage("Invalid email or password");
    }
}
