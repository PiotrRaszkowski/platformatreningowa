package pl.platformatreningowa.onboarding.boundary;

import static org.mockito.BDDMockito.given;
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
import pl.platformatreningowa.onboarding.control.OnboardingProfileService;
import pl.platformatreningowa.onboarding.entity.OnboardingProfile;
import pl.platformatreningowa.shared.boundary.ApiExceptionHandler;
import pl.platformatreningowa.shared.control.SecurityConfig;

@WebMvcTest(OnboardingProfileController.class)
@Import({SecurityConfig.class, ApiExceptionHandler.class})
class OnboardingProfileControllerTest {

    @Autowired private MockMvc mockMvc;
    @MockitoBean private OnboardingProfileService onboardingProfileService;

    @Test
    void getProfileReturnsCurrentProfile() throws Exception {
        given(onboardingProfileService.getCurrentProfile("Bearer token"))
                .willReturn(new OnboardingProfile(31, "mężczyzna", new BigDecimal("76.5"), new BigDecimal("182"), "średni",
                        "regularnie", List.of("MON", "WED"), "poprawić kondycję", null, null, null, List.of("nic"), false));

        mockMvc.perform(get("/api/auth/onboarding/me").header("Authorization", "Bearer token"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.trainingDays[0]").value("MON"));
    }

    @Test
    void saveProfileValidatesRequiredFields() throws Exception {
        mockMvc.perform(put("/api/auth/onboarding/me")
                        .header("Authorization", "Bearer token")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"age":11,"sex":"","weight":20,"height":100,"bodyType":"x","activityHistory":"x","trainingDays":[],"goal":"x","availableEquipment":[]}
                                """))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.message").value("Validation failed"));
    }

    @Test
    void saveProfileReturnsCompletedProfile() throws Exception {
        given(onboardingProfileService.saveProfile(org.mockito.ArgumentMatchers.eq("Bearer token"), org.mockito.ArgumentMatchers.any()))
                .willReturn(new OnboardingProfile(31, "mężczyzna", new BigDecimal("76.5"), new BigDecimal("182"), "średni",
                        "regularnie", List.of("MON", "WED"), "biegać szybciej", new BigDecimal("10"), "50:00", "laktoza", List.of("gumy"), true));

        mockMvc.perform(put("/api/auth/onboarding/me")
                        .header("Authorization", "Bearer token")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"age":31,"sex":"mężczyzna","weight":76.5,"height":182,"bodyType":"średni","activityHistory":"regularnie","trainingDays":["MON","WED"],"goal":"biegać szybciej","targetDistance":10,"targetTime":"50:00","foodIntolerances":"laktoza","availableEquipment":["gumy"]}
                                """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.onboardingCompleted").value(true))
                .andExpect(jsonPath("$.availableEquipment[0]").value("gumy"));
    }
}
