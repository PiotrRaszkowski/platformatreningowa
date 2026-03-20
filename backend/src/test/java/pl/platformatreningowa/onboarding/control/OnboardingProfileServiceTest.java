package pl.platformatreningowa.onboarding.control;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pl.platformatreningowa.auth.control.JwtService;
import pl.platformatreningowa.auth.control.UserRepository;
import pl.platformatreningowa.auth.entity.UserEntity;
import pl.platformatreningowa.onboarding.entity.OnboardingProfile;
import pl.platformatreningowa.onboarding.entity.SaveOnboardingProfileRequest;
import pl.platformatreningowa.shared.entity.UnauthorizedException;

@ExtendWith(MockitoExtension.class)
class OnboardingProfileServiceTest {

    @Mock private UserRepository userRepository;
    @Mock private JwtService jwtService;
    @InjectMocks private OnboardingProfileService service;

    private UserEntity user;

    @BeforeEach
    void setUp() {
        user = new UserEntity();
        user.setId(7L);
        user.setEmail("runner@example.com");
    }

    @Test
    void savesProfileAndMarksOnboardingCompleted() {
        given(jwtService.extractUserId("token")).willReturn(7L);
        given(userRepository.findById(7L)).willReturn(Optional.of(user));
        given(userRepository.save(any(UserEntity.class))).willAnswer(invocation -> invocation.getArgument(0));

        OnboardingProfile profile = service.saveProfile("Bearer token", new SaveOnboardingProfileRequest(
                31, "mężczyzna", new BigDecimal("76.5"), new BigDecimal("182"), "średni", "regularnie",
                List.of("MON", "WED", "SAT"), "biegać szybciej", new BigDecimal("10"), "50:00", "laktoza", List.of("gumy", "siłownia")
        ));

        assertThat(profile.onboardingCompleted()).isTrue();
        assertThat(profile.trainingDays()).containsExactly("MON", "WED", "SAT");
        assertThat(user.getAvailableEquipment()).isEqualTo("gumy,siłownia");
    }

    @Test
    void returnsSavedProfile() {
        user.setTrainingDays("MON,FRI");
        user.setAvailableEquipment("nic,hantle");
        given(jwtService.extractUserId("token")).willReturn(7L);
        given(userRepository.findById(7L)).willReturn(Optional.of(user));

        OnboardingProfile profile = service.getCurrentProfile("Bearer token");

        assertThat(profile.trainingDays()).containsExactly("MON", "FRI");
        assertThat(profile.availableEquipment()).containsExactly("nic", "hantle");
    }

    @Test
    void rejectsMissingBearerToken() {
        assertThatThrownBy(() -> service.getCurrentProfile(null))
                .isInstanceOf(UnauthorizedException.class)
                .hasMessage("Missing or invalid Authorization header");
    }
}
