package pl.platformatreningowa.auth.boundary;

import static org.mockito.BDDMockito.given;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import pl.platformatreningowa.auth.control.AuthService;
import pl.platformatreningowa.auth.entity.AuthResponse;
import pl.platformatreningowa.auth.entity.LoginRequest;
import pl.platformatreningowa.auth.entity.RegisterRequest;
import pl.platformatreningowa.shared.boundary.ApiExceptionHandler;
import pl.platformatreningowa.shared.control.SecurityConfig;

@WebMvcTest(AuthController.class)
@Import({SecurityConfig.class, ApiExceptionHandler.class})
class AuthControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private AuthService authService;

    @Test
    void registerReturnsCreated() throws Exception {
        given(authService.register(new RegisterRequest("runner@example.com", "password123", "password123")))
                .willReturn(new AuthResponse("jwt-token", "runner@example.com", false, false, "/legal-consents"));

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content('{'+"\"email\":\"runner@example.com\",\"password\":\"password123\",\"confirmPassword\":\"password123\""+'}'))
                .andExpect(status().isCreated())
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.token").value("jwt-token"))
                .andExpect(jsonPath("$.legalConsentsAccepted").value(false))
                .andExpect(jsonPath("$.redirectTo").value("/legal-consents"));
    }

    @Test
    void loginValidatesPayload() throws Exception {
        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content('{'+"\"email\":\"\",\"password\":\"\""+'}'))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.message").value("Validation failed"));
    }

    @Test
    void loginReturnsOk() throws Exception {
        given(authService.login(new LoginRequest("runner@example.com", "password123")))
                .willReturn(new AuthResponse("jwt-token", "runner@example.com", true, true, "/dashboard"));

        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content('{'+"\"email\":\"runner@example.com\",\"password\":\"password123\""+'}'))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.redirectTo").value("/dashboard"));
    }
}
