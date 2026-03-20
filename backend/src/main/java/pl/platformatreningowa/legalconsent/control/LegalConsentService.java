package pl.platformatreningowa.legalconsent.control;

import java.time.Instant;
import org.springframework.stereotype.Service;
import pl.platformatreningowa.auth.control.JwtService;
import pl.platformatreningowa.auth.control.UserRepository;
import pl.platformatreningowa.auth.entity.UserEntity;
import pl.platformatreningowa.legalconsent.entity.LegalConsent;
import pl.platformatreningowa.legalconsent.entity.SaveLegalConsentRequest;
import pl.platformatreningowa.shared.entity.UnauthorizedException;

@Service
public class LegalConsentService {

    private final UserRepository userRepository;
    private final JwtService jwtService;

    public LegalConsentService(UserRepository userRepository, JwtService jwtService) {
        this.userRepository = userRepository;
        this.jwtService = jwtService;
    }

    public LegalConsent getCurrentConsent(String authorizationHeader) {
        UserEntity user = getUserFromAuthorizationHeader(authorizationHeader);
        return toLegalConsent(user);
    }

    public LegalConsent saveConsent(String authorizationHeader, SaveLegalConsentRequest request) {
        UserEntity user = getUserFromAuthorizationHeader(authorizationHeader);
        user.setTermsAccepted(request.termsAccepted());
        user.setHealthStatementAccepted(request.healthStatementAccepted());
        user.setPrivacyPolicyAccepted(request.privacyPolicyAccepted());
        user.setLegalAcceptedAt(Instant.now());
        UserEntity savedUser = userRepository.save(user);
        return toLegalConsent(savedUser);
    }

    private UserEntity getUserFromAuthorizationHeader(String authorizationHeader) {
        if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
            throw new UnauthorizedException("Missing or invalid Authorization header");
        }

        String token = authorizationHeader.substring(7).trim();
        try {
            Long userId = jwtService.extractUserId(token);
            return userRepository.findById(userId)
                    .orElseThrow(() -> new UnauthorizedException("User for token was not found"));
        } catch (RuntimeException exception) {
            throw new UnauthorizedException("Invalid or expired token");
        }
    }

    private LegalConsent toLegalConsent(UserEntity user) {
        return new LegalConsent(
                user.isTermsAccepted(),
                user.isHealthStatementAccepted(),
                user.isPrivacyPolicyAccepted(),
                user.getLegalAcceptedAt(),
                user.hasAcceptedRequiredConsents()
        );
    }
}
