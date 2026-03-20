package pl.platformatreningowa.profile.control;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.verify;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;
import pl.platformatreningowa.auth.control.JwtService;
import pl.platformatreningowa.auth.control.UserRepository;
import pl.platformatreningowa.auth.entity.UserEntity;
import pl.platformatreningowa.profile.entity.ChangePasswordRequest;
import pl.platformatreningowa.profile.entity.UpdateProfileRequest;
import pl.platformatreningowa.profile.entity.UserProfile;
import pl.platformatreningowa.shared.entity.UnauthorizedException;
import pl.platformatreningowa.shared.entity.ValidationException;

@ExtendWith(MockitoExtension.class)
class ProfileServiceTest {

    @Mock private UserRepository userRepository;
    @Mock private JwtService jwtService;
    @Mock private PasswordEncoder passwordEncoder;
    @InjectMocks private ProfileService service;

    private UserEntity user;

    @BeforeEach
    void setUp() {
        user = new UserEntity();
        user.setId(7L);
        user.setEmail("runner@example.com");
        user.setPasswordHash("hashed-password");
        user.setAge(31);
        user.setSex("mężczyzna");
        user.setWeight(new BigDecimal("76.50"));
        user.setHeight(new BigDecimal("182.00"));
        user.setBodyType("średni");
        user.setActivityHistory("regularnie");
        user.setTrainingDays("MON,WED,SAT");
        user.setGoal("biegać szybciej");
        user.setTargetDistance(new BigDecimal("10.00"));
        user.setTargetTime("50:00");
        user.setFoodIntolerances("laktoza");
        user.setAvailableEquipment("gumy,siłownia");
    }

    @Test
    void returnsUserProfile() {
        given(jwtService.extractUserId("token")).willReturn(7L);
        given(userRepository.findById(7L)).willReturn(Optional.of(user));

        UserProfile profile = service.getProfile("Bearer token");

        assertThat(profile.email()).isEqualTo("runner@example.com");
        assertThat(profile.age()).isEqualTo(31);
        assertThat(profile.trainingDays()).containsExactly("MON", "WED", "SAT");
        assertThat(profile.availableEquipment()).containsExactly("gumy", "siłownia");
        assertThat(profile.foodIntolerances()).isEqualTo("laktoza");
    }

    @Test
    void updatesEditableFields() {
        given(jwtService.extractUserId("token")).willReturn(7L);
        given(userRepository.findById(7L)).willReturn(Optional.of(user));
        given(userRepository.save(any(UserEntity.class))).willAnswer(invocation -> invocation.getArgument(0));

        UserProfile profile = service.updateProfile("Bearer token", new UpdateProfileRequest(
                new BigDecimal("80.00"), List.of("TUE", "THU"), "poprawić kondycję", "gluten", List.of("hantle")
        ));

        assertThat(profile.weight()).isEqualByComparingTo(new BigDecimal("80.00"));
        assertThat(profile.trainingDays()).containsExactly("TUE", "THU");
        assertThat(profile.goal()).isEqualTo("poprawić kondycję");
        assertThat(profile.foodIntolerances()).isEqualTo("gluten");
        assertThat(profile.availableEquipment()).containsExactly("hantle");
        assertThat(profile.age()).isEqualTo(31);
        assertThat(profile.sex()).isEqualTo("mężczyzna");
    }

    @Test
    void changesPasswordSuccessfully() {
        given(jwtService.extractUserId("token")).willReturn(7L);
        given(userRepository.findById(7L)).willReturn(Optional.of(user));
        given(passwordEncoder.matches("oldPass123", "hashed-password")).willReturn(true);
        given(passwordEncoder.encode("newPass123")).willReturn("new-hashed");

        service.changePassword("Bearer token", new ChangePasswordRequest("oldPass123", "newPass123", "newPass123"));

        assertThat(user.getPasswordHash()).isEqualTo("new-hashed");
        verify(userRepository).save(user);
    }

    @Test
    void rejectsWrongCurrentPassword() {
        given(jwtService.extractUserId("token")).willReturn(7L);
        given(userRepository.findById(7L)).willReturn(Optional.of(user));
        given(passwordEncoder.matches("wrong", "hashed-password")).willReturn(false);

        assertThatThrownBy(() -> service.changePassword("Bearer token",
                new ChangePasswordRequest("wrong", "newPass123", "newPass123")))
                .isInstanceOf(ValidationException.class)
                .hasMessage("Nieprawidłowe aktualne hasło.");
    }

    @Test
    void rejectsMismatchedNewPasswords() {
        given(jwtService.extractUserId("token")).willReturn(7L);
        given(userRepository.findById(7L)).willReturn(Optional.of(user));
        given(passwordEncoder.matches("oldPass123", "hashed-password")).willReturn(true);

        assertThatThrownBy(() -> service.changePassword("Bearer token",
                new ChangePasswordRequest("oldPass123", "newPass123", "different")))
                .isInstanceOf(ValidationException.class)
                .hasMessage("Nowe hasła muszą być identyczne.");
    }

    @Test
    void rejectsMissingBearerToken() {
        assertThatThrownBy(() -> service.getProfile(null))
                .isInstanceOf(UnauthorizedException.class)
                .hasMessage("Missing or invalid Authorization header");
    }
}
