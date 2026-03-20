package pl.platformatreningowa.profile.entity;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.util.List;

public record UpdateProfileRequest(
        @NotNull @DecimalMin("30.0") @DecimalMax("300.0") BigDecimal weight,
        @NotEmpty @Size(max = 7) List<@Pattern(regexp = "MON|TUE|WED|THU|FRI|SAT|SUN") String> trainingDays,
        @NotBlank @Pattern(regexp = "schudnąć|poprawić kondycję|biegać szybciej|zacząć się ruszać|przygotowanie do zawodów") String goal,
        @Size(max = 500) String foodIntolerances,
        @NotEmpty @Size(max = 4) List<@Pattern(regexp = "nic|hantle|gumy|siłownia") String> availableEquipment
) {
}
