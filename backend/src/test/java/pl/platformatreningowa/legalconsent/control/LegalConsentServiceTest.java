package pl.platformatreningowa.legalconsent.control;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;

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
import pl.platformatreningowa.legalconsent.entity.LegalConsent;
import pl.platformatreningowa.legalconsent.entity.SaveLegalConsentRequest;
import pl.platformatreningowa.shared.entity.UnauthorizedException;

@ExtendWith(MockitoExtension.class)
class LegalConsentServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private JwtService jwtService;

    @InjectMocks
    private LegalConsentService legalConsentService;

    private UserEntity user;

    @BeforeEach
    void setUp() {
        user = new UserEntity();
        user.setId(7L);
        user.setEmail("runner@example.com");
    }

    @Test
    void returnsCurrentConsentState() {
        given(jwtService.extractUserId("token")).willReturn(7L);
        given(userRepository.findById(7L)).willReturn(Optional.of(user));

        LegalConsent consent = legalConsentService.getCurrentConsent("Bearer token");

        assertThat(consent.completed()).isFalse();
        assertThat(consent.acceptedAt()).isNull();
    }

    @Test
    void savesAcceptedConsentsWithTimestamp() {
        given(jwtService.extractUserId("token")).willReturn(7L);
        given(userRepository.findById(7L)).willReturn(Optional.of(user));
        given(userRepository.save(any(UserEntity.class))).willAnswer(invocation -> invocation.getArgument(0));

        LegalConsent consent = legalConsentService.saveConsent("Bearer token", new SaveLegalConsentRequest(true, true, true));

        assertThat(consent.completed()).isTrue();
        assertThat(consent.acceptedAt()).isNotNull();
        assertThat(user.isTermsAccepted()).isTrue();
    }

    @Test
    void rejectsMissingBearerToken() {
        assertThatThrownBy(() -> legalConsentService.getCurrentConsent(null))
                .isInstanceOf(UnauthorizedException.class)
                .hasMessage("Missing or invalid Authorization header");
    }
}
