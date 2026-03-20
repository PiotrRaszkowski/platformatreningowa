package pl.platformatreningowa.onboarding.control;

import java.util.Arrays;
import java.util.List;
import org.springframework.stereotype.Service;
import pl.platformatreningowa.auth.control.JwtService;
import pl.platformatreningowa.auth.control.UserRepository;
import pl.platformatreningowa.auth.entity.UserEntity;
import pl.platformatreningowa.onboarding.entity.OnboardingProfile;
import pl.platformatreningowa.onboarding.entity.SaveOnboardingProfileRequest;
import pl.platformatreningowa.shared.entity.UnauthorizedException;

@Service
public class OnboardingProfileService {

    private final UserRepository userRepository;
    private final JwtService jwtService;

    public OnboardingProfileService(UserRepository userRepository, JwtService jwtService) {
        this.userRepository = userRepository;
        this.jwtService = jwtService;
    }

    public OnboardingProfile getCurrentProfile(String authorizationHeader) {
        return toProfile(getUserFromAuthorizationHeader(authorizationHeader));
    }

    public OnboardingProfile saveProfile(String authorizationHeader, SaveOnboardingProfileRequest request) {
        UserEntity user = getUserFromAuthorizationHeader(authorizationHeader);
        user.setAge(request.age());
        user.setSex(request.sex());
        user.setWeight(request.weight());
        user.setHeight(request.height());
        user.setBodyType(request.bodyType());
        user.setActivityHistory(request.activityHistory());
        user.setTrainingDays(String.join(",", request.trainingDays()));
        user.setGoal(request.goal());
        user.setTargetDistance(request.targetDistance());
        user.setTargetTime(blankToNull(request.targetTime()));
        user.setFoodIntolerances(blankToNull(request.foodIntolerances()));
        user.setAvailableEquipment(String.join(",", request.availableEquipment()));
        user.setOnboardingCompleted(true);
        return toProfile(userRepository.save(user));
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

    private OnboardingProfile toProfile(UserEntity user) {
        return new OnboardingProfile(
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
                splitCsv(user.getAvailableEquipment()),
                user.isOnboardingCompleted()
        );
    }

    private List<String> splitCsv(String value) {
        if (value == null || value.isBlank()) {
            return List.of();
        }
        return Arrays.stream(value.split(",")).map(String::trim).filter(item -> !item.isEmpty()).toList();
    }
}
