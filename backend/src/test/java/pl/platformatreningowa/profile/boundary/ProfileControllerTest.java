package pl.platformatreningowa.profile.boundary;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.doThrow;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.math.BigDecimal;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import pl.platformatreningowa.profile.control.ProfileService;
import pl.platformatreningowa.profile.entity.UserProfile;
import pl.platformatreningowa.shared.boundary.ApiExceptionHandler;
import pl.platformatreningowa.shared.control.SecurityConfig;
import pl.platformatreningowa.shared.entity.ValidationException;

@WebMvcTest(ProfileController.class)
@Import({SecurityConfig.class, ApiExceptionHandler.class})
class ProfileControllerTest {

    @Autowired private MockMvc mockMvc;
    @MockitoBean private ProfileService profileService;

    @Test
    void getProfileReturnsUserData() throws Exception {
        given(profileService.getProfile("Bearer test-token")).willReturn(new UserProfile(
                "runner@example.com", 31, "mężczyzna", new BigDecimal("76.50"), new BigDecimal("182.00"),
                "średni", "regularnie", List.of("MON", "WED"), "biegać szybciej",
                new BigDecimal("10.00"), "50:00", "laktoza", List.of("gumy")
        ));

        mockMvc.perform(get("/api/auth/profile/me").header("Authorization", "Bearer test-token"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.email").value("runner@example.com"))
                .andExpect(jsonPath("$.age").value(31))
                .andExpect(jsonPath("$.trainingDays[0]").value("MON"));
    }

    @Test
    void updateProfileReturnsUpdatedData() throws Exception {
        given(profileService.updateProfile(eq("Bearer test-token"), any())).willReturn(new UserProfile(
                "runner@example.com", 31, "mężczyzna", new BigDecimal("80.00"), new BigDecimal("182.00"),
                "średni", "regularnie", List.of("TUE", "THU"), "poprawić kondycję",
                new BigDecimal("10.00"), "50:00", "gluten", List.of("hantle")
        ));

        mockMvc.perform(put("/api/auth/profile/me")
                        .header("Authorization", "Bearer test-token")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"weight":80.0,"trainingDays":["TUE","THU"],"goal":"poprawić kondycję",
                                 "foodIntolerances":"gluten","availableEquipment":["hantle"]}"""))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.weight").value(80.0))
                .andExpect(jsonPath("$.goal").value("poprawić kondycję"));
    }

    @Test
    void changePasswordReturns204() throws Exception {
        doNothing().when(profileService).changePassword(eq("Bearer test-token"), any());

        mockMvc.perform(put("/api/auth/profile/me/password")
                        .header("Authorization", "Bearer test-token")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"currentPassword":"oldPass123","newPassword":"newPass123","confirmNewPassword":"newPass123"}"""))
                .andExpect(status().isNoContent());
    }

    @Test
    void changePasswordReturns400OnWrongCurrentPassword() throws Exception {
        doThrow(new ValidationException("Nieprawidłowe aktualne hasło."))
                .when(profileService).changePassword(eq("Bearer test-token"), any());

        mockMvc.perform(put("/api/auth/profile/me/password")
                        .header("Authorization", "Bearer test-token")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"currentPassword":"wrong","newPassword":"newPass123","confirmNewPassword":"newPass123"}"""))
                .andExpect(status().isBadRequest());
    }
}
