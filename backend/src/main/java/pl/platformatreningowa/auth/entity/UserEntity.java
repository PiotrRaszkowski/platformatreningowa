package pl.platformatreningowa.auth.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import java.math.BigDecimal;
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

    @Column
    private Integer age;

    @Column(length = 20)
    private String sex;

    @Column(precision = 5, scale = 2)
    private BigDecimal weight;

    @Column(precision = 5, scale = 2)
    private BigDecimal height;

    @Column(length = 30)
    private String bodyType;

    @Column(length = 30)
    private String activityHistory;

    @Column(length = 100)
    private String trainingDays;

    @Column(length = 40)
    private String goal;

    @Column(precision = 5, scale = 2)
    private BigDecimal targetDistance;

    @Column(length = 20)
    private String targetTime;

    @Column(length = 500)
    private String foodIntolerances;

    @Column(length = 100)
    private String availableEquipment;

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
    public Integer getAge() { return age; }
    public void setAge(Integer age) { this.age = age; }
    public String getSex() { return sex; }
    public void setSex(String sex) { this.sex = sex; }
    public BigDecimal getWeight() { return weight; }
    public void setWeight(BigDecimal weight) { this.weight = weight; }
    public BigDecimal getHeight() { return height; }
    public void setHeight(BigDecimal height) { this.height = height; }
    public String getBodyType() { return bodyType; }
    public void setBodyType(String bodyType) { this.bodyType = bodyType; }
    public String getActivityHistory() { return activityHistory; }
    public void setActivityHistory(String activityHistory) { this.activityHistory = activityHistory; }
    public String getTrainingDays() { return trainingDays; }
    public void setTrainingDays(String trainingDays) { this.trainingDays = trainingDays; }
    public String getGoal() { return goal; }
    public void setGoal(String goal) { this.goal = goal; }
    public BigDecimal getTargetDistance() { return targetDistance; }
    public void setTargetDistance(BigDecimal targetDistance) { this.targetDistance = targetDistance; }
    public String getTargetTime() { return targetTime; }
    public void setTargetTime(String targetTime) { this.targetTime = targetTime; }
    public String getFoodIntolerances() { return foodIntolerances; }
    public void setFoodIntolerances(String foodIntolerances) { this.foodIntolerances = foodIntolerances; }
    public String getAvailableEquipment() { return availableEquipment; }
    public void setAvailableEquipment(String availableEquipment) { this.availableEquipment = availableEquipment; }
    public Instant getCreatedAt() { return createdAt; }
    public void setCreatedAt(Instant createdAt) { this.createdAt = createdAt; }
}
