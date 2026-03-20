package pl.platformatreningowa.auth.control;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import pl.platformatreningowa.auth.entity.AuthResponse;
import pl.platformatreningowa.auth.entity.LoginRequest;
import pl.platformatreningowa.auth.entity.RegisterRequest;
import pl.platformatreningowa.auth.entity.UserEntity;
import pl.platformatreningowa.shared.entity.ConflictException;
import pl.platformatreningowa.shared.entity.UnauthorizedException;
import pl.platformatreningowa.shared.entity.ValidationException;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthService(UserRepository userRepository, PasswordEncoder passwordEncoder, JwtService jwtService) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    public AuthResponse register(RegisterRequest request) {
        validatePasswords(request.password(), request.confirmPassword());
        String normalizedEmail = request.email().trim().toLowerCase();
        if (userRepository.existsByEmailIgnoreCase(normalizedEmail)) {
            throw new ConflictException("User with this email already exists");
        }

        UserEntity user = new UserEntity();
        user.setEmail(normalizedEmail);
        user.setPasswordHash(passwordEncoder.encode(request.password()));
        user.setOnboardingCompleted(false);

        UserEntity savedUser = userRepository.save(user);
        return toAuthResponse(savedUser);
    }

    public AuthResponse login(LoginRequest request) {
        String normalizedEmail = request.email().trim().toLowerCase();
        UserEntity user = userRepository.findByEmailIgnoreCase(normalizedEmail)
                .orElseThrow(() -> new UnauthorizedException("Invalid email or password"));

        if (!passwordEncoder.matches(request.password(), user.getPasswordHash())) {
            throw new UnauthorizedException("Invalid email or password");
        }

        return toAuthResponse(user);
    }

    private void validatePasswords(String password, String confirmPassword) {
        if (!password.equals(confirmPassword)) {
            throw new ValidationException("Passwords do not match");
        }
    }

    private AuthResponse toAuthResponse(UserEntity user) {
        return new AuthResponse(
                jwtService.generateToken(user),
                user.getEmail(),
                user.isOnboardingCompleted(),
                user.isOnboardingCompleted() ? "/dashboard" : "/onboarding"
        );
    }
}
