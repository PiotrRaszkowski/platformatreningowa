package pl.platformatreningowa.legalconsent.boundary;

import static org.mockito.BDDMockito.given;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.time.Instant;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import pl.platformatreningowa.legalconsent.control.LegalConsentService;
import pl.platformatreningowa.legalconsent.entity.LegalConsent;
import pl.platformatreningowa.shared.boundary.ApiExceptionHandler;
import pl.platformatreningowa.shared.control.SecurityConfig;

@WebMvcTest(LegalConsentController.class)
@Import({SecurityConfig.class, ApiExceptionHandler.class})
class LegalConsentControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private LegalConsentService legalConsentService;

    @Test
    void getCurrentConsentReturnsCurrentState() throws Exception {
        given(legalConsentService.getCurrentConsent("Bearer token"))
                .willReturn(new LegalConsent(false, false, false, null, false));

        mockMvc.perform(get("/api/auth/legal-consents/me").header("Authorization", "Bearer token"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.completed").value(false));
    }

    @Test
    void saveConsentValidatesAllCheckboxes() throws Exception {
        mockMvc.perform(put("/api/auth/legal-consents/me")
                        .header("Authorization", "Bearer token")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content('{'+"\"termsAccepted\":true,\"healthStatementAccepted\":false,\"privacyPolicyAccepted\":true"+'}'))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.message").value("Validation failed"));
    }

    @Test
    void saveConsentReturnsAcceptedState() throws Exception {
        given(legalConsentService.saveConsent(org.mockito.ArgumentMatchers.eq("Bearer token"), org.mockito.ArgumentMatchers.any()))
                .willReturn(new LegalConsent(true, true, true, Instant.parse("2026-03-20T12:00:00Z"), true));

        mockMvc.perform(put("/api/auth/legal-consents/me")
                        .header("Authorization", "Bearer token")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content('{'+"\"termsAccepted\":true,\"healthStatementAccepted\":true,\"privacyPolicyAccepted\":true"+'}'))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.completed").value(true))
                .andExpect(jsonPath("$.acceptedAt").value("2026-03-20T12:00:00Z"));
    }
}
