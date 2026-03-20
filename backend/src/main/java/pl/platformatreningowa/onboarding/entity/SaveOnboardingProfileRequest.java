package pl.platformatreningowa.onboarding.entity;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.util.List;

public record SaveOnboardingProfileRequest(
        @NotNull @Min(12) @Max(100) Integer age,
        @NotBlank @Pattern(regexp = "kobieta|mężczyzna|inna|wolę nie podawać") String sex,
        @NotNull @DecimalMin("30.0") @DecimalMax("300.0") BigDecimal weight,
        @NotNull @DecimalMin("120.0") @DecimalMax("250.0") BigDecimal height,
        @NotBlank @Pattern(regexp = "szczupły|średni|nadwaga|masywny") String bodyType,
        @NotBlank @Pattern(regexp = "nigdy|okazjonalnie|regularnie|zaawansowany") String activityHistory,
        @NotEmpty @Size(max = 7) List<@Pattern(regexp = "MON|TUE|WED|THU|FRI|SAT|SUN") String> trainingDays,
        @NotBlank @Pattern(regexp = "schudnąć|poprawić kondycję|biegać szybciej|zacząć się ruszać|przygotowanie do zawodów") String goal,
        @DecimalMin("0.1") @DecimalMax("1000.0") BigDecimal targetDistance,
        @Size(max = 20) String targetTime,
        @Size(max = 500) String foodIntolerances,
        @NotEmpty @Size(max = 4) List<@Pattern(regexp = "nic|hantle|gumy|siłownia") String> availableEquipment
) {
}
