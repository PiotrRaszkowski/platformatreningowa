package pl.platformatreningowa.onboarding.boundary;

import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pl.platformatreningowa.onboarding.control.OnboardingProfileService;
import pl.platformatreningowa.onboarding.entity.OnboardingProfile;
import pl.platformatreningowa.onboarding.entity.SaveOnboardingProfileRequest;

@RestController
@RequestMapping("/api/auth/onboarding")
public class OnboardingProfileController {

    private final OnboardingProfileService onboardingProfileService;

    public OnboardingProfileController(OnboardingProfileService onboardingProfileService) {
        this.onboardingProfileService = onboardingProfileService;
    }

    @GetMapping("/me")
    public ResponseEntity<OnboardingProfile> getCurrentProfile(@RequestHeader("Authorization") String authorizationHeader) {
        return ResponseEntity.ok(onboardingProfileService.getCurrentProfile(authorizationHeader));
    }

    @PutMapping("/me")
    public ResponseEntity<OnboardingProfile> saveProfile(
            @RequestHeader("Authorization") String authorizationHeader,
            @Valid @RequestBody SaveOnboardingProfileRequest request
    ) {
        return ResponseEntity.ok(onboardingProfileService.saveProfile(authorizationHeader, request));
    }
}
