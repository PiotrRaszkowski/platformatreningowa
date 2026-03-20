package pl.platformatreningowa.profile.boundary;

import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pl.platformatreningowa.profile.control.ProfileService;
import pl.platformatreningowa.profile.entity.ChangePasswordRequest;
import pl.platformatreningowa.profile.entity.UpdateProfileRequest;
import pl.platformatreningowa.profile.entity.UserProfile;

@RestController
@RequestMapping("/api/auth/profile")
public class ProfileController {

    private final ProfileService profileService;

    public ProfileController(ProfileService profileService) {
        this.profileService = profileService;
    }

    @GetMapping("/me")
    public ResponseEntity<UserProfile> getProfile(@RequestHeader("Authorization") String authorization) {
        return ResponseEntity.ok(profileService.getProfile(authorization));
    }

    @PutMapping("/me")
    public ResponseEntity<UserProfile> updateProfile(
            @RequestHeader("Authorization") String authorization,
            @Valid @RequestBody UpdateProfileRequest request) {
        return ResponseEntity.ok(profileService.updateProfile(authorization, request));
    }

    @PutMapping("/me/password")
    public ResponseEntity<Void> changePassword(
            @RequestHeader("Authorization") String authorization,
            @Valid @RequestBody ChangePasswordRequest request) {
        profileService.changePassword(authorization, request);
        return ResponseEntity.noContent().build();
    }
}
