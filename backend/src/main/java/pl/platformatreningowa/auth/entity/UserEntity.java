package pl.platformatreningowa.auth.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import java.time.Instant;

@Entity
@Table(name = "users")
public class UserEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(name = "password_hash", nullable = false)
    private String passwordHash;

    @Column(nullable = false)
    private boolean onboardingCompleted;

    @Column(nullable = false)
    private boolean termsAccepted;

    @Column(nullable = false)
    private boolean healthStatementAccepted;

    @Column(nullable = false)
    private boolean privacyPolicyAccepted;

    @Column
    private Instant legalAcceptedAt;

    @Column(nullable = false)
    private Instant createdAt;

    @PrePersist
    void prePersist() {
        if (createdAt == null) {
            createdAt = Instant.now();
        }
    }

    public boolean hasAcceptedRequiredConsents() {
        return termsAccepted && healthStatementAccepted && privacyPolicyAccepted && legalAcceptedAt != null;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    public boolean isOnboardingCompleted() { return onboardingCompleted; }
    public void setOnboardingCompleted(boolean onboardingCompleted) { this.onboardingCompleted = onboardingCompleted; }
    public boolean isTermsAccepted() { return termsAccepted; }
    public void setTermsAccepted(boolean termsAccepted) { this.termsAccepted = termsAccepted; }
    public boolean isHealthStatementAccepted() { return healthStatementAccepted; }
    public void setHealthStatementAccepted(boolean healthStatementAccepted) { this.healthStatementAccepted = healthStatementAccepted; }
    public boolean isPrivacyPolicyAccepted() { return privacyPolicyAccepted; }
    public void setPrivacyPolicyAccepted(boolean privacyPolicyAccepted) { this.privacyPolicyAccepted = privacyPolicyAccepted; }
    public Instant getLegalAcceptedAt() { return legalAcceptedAt; }
    public void setLegalAcceptedAt(Instant legalAcceptedAt) { this.legalAcceptedAt = legalAcceptedAt; }
    public Instant getCreatedAt() { return createdAt; }
    public void setCreatedAt(Instant createdAt) { this.createdAt = createdAt; }
}
