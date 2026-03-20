package pl.platformatreningowa.profile.control;

import java.util.Arrays;
import java.util.List;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import pl.platformatreningowa.auth.control.JwtService;
import pl.platformatreningowa.auth.control.UserRepository;
import pl.platformatreningowa.auth.entity.UserEntity;
import pl.platformatreningowa.profile.entity.ChangePasswordRequest;
import pl.platformatreningowa.profile.entity.UpdateProfileRequest;
import pl.platformatreningowa.profile.entity.UserProfile;
import pl.platformatreningowa.shared.entity.UnauthorizedException;
import pl.platformatreningowa.shared.entity.ValidationException;

@Service
public class ProfileService {

    private final UserRepository userRepository;
    private final JwtService jwtService;
    private final PasswordEncoder passwordEncoder;

    public ProfileService(UserRepository userRepository, JwtService jwtService, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.jwtService = jwtService;
        this.passwordEncoder = passwordEncoder;
    }

    public UserProfile getProfile(String authorizationHeader) {
        return toProfile(getUserFromAuthorizationHeader(authorizationHeader));
    }

    public UserProfile updateProfile(String authorizationHeader, UpdateProfileRequest request) {
        UserEntity user = getUserFromAuthorizationHeader(authorizationHeader);
        user.setWeight(request.weight());
        user.setTrainingDays(String.join(",", request.trainingDays()));
        user.setGoal(request.goal());
        user.setFoodIntolerances(blankToNull(request.foodIntolerances()));
        user.setAvailableEquipment(String.join(",", request.availableEquipment()));
        return toProfile(userRepository.save(user));
    }

    public void changePassword(String authorizationHeader, ChangePasswordRequest request) {
        UserEntity user = getUserFromAuthorizationHeader(authorizationHeader);
        if (!passwordEncoder.matches(request.currentPassword(), user.getPasswordHash())) {
            throw new ValidationException("Nieprawidłowe aktualne hasło.");
        }
        if (!request.newPassword().equals(request.confirmNewPassword())) {
            throw new ValidationException("Nowe hasła muszą być identyczne.");
        }
        user.setPasswordHash(passwordEncoder.encode(request.newPassword()));
        userRepository.save(user);
    }

    private String blankToNull(String value) {
        return value == null || value.isBlank() ? null : value.trim();
    }

    private UserEntity getUserFromAuthorizationHeader(String authorizationHeader) {
        if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
            throw new UnauthorizedException("Missing or invalid Authorization header");
        }
        try {
            Long userId = jwtService.extractUserId(authorizationHeader.substring(7).trim());
            return userRepository.findById(userId).orElseThrow(() -> new UnauthorizedException("User for token was not found"));
        } catch (RuntimeException exception) {
            throw new UnauthorizedException("Invalid or expired token");
        }
    }

    private UserProfile toProfile(UserEntity user) {
        return new UserProfile(
                user.getEmail(),
                user.getAge(),
                user.getSex(),
                user.getWeight(),
                user.getHeight(),
                user.getBodyType(),
                user.getActivityHistory(),
                splitCsv(user.getTrainingDays()),
                user.getGoal(),
                user.getTargetDistance(),
                user.getTargetTime(),
                user.getFoodIntolerances(),
                splitCsv(user.getAvailableEquipment())
        );
    }

    private List<String> splitCsv(String value) {
        if (value == null || value.isBlank()) {
            return List.of();
        }
        return Arrays.stream(value.split(",")).map(String::trim).filter(item -> !item.isEmpty()).toList();
    }
}
