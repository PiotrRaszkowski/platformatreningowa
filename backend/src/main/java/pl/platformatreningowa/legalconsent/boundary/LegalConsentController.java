package pl.platformatreningowa.legalconsent.boundary;

import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pl.platformatreningowa.legalconsent.control.LegalConsentService;
import pl.platformatreningowa.legalconsent.entity.LegalConsent;
import pl.platformatreningowa.legalconsent.entity.SaveLegalConsentRequest;

@RestController
@RequestMapping("/api/auth/legal-consents")
public class LegalConsentController {

    private final LegalConsentService legalConsentService;

    public LegalConsentController(LegalConsentService legalConsentService) {
        this.legalConsentService = legalConsentService;
    }

    @GetMapping("/me")
    public ResponseEntity<LegalConsent> getCurrentConsent(@RequestHeader("Authorization") String authorizationHeader) {
        return ResponseEntity.ok(legalConsentService.getCurrentConsent(authorizationHeader));
    }

    @PutMapping("/me")
    public ResponseEntity<LegalConsent> saveConsent(
            @RequestHeader("Authorization") String authorizationHeader,
            @Valid @RequestBody SaveLegalConsentRequest request
    ) {
        return ResponseEntity.ok(legalConsentService.saveConsent(authorizationHeader, request));
    }
}
