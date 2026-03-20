package pl.platformatreningowa.profile.entity;

import java.math.BigDecimal;
import java.util.List;

public record UserProfile(
        String email,
        Integer age,
        String sex,
        BigDecimal weight,
        BigDecimal height,
        String bodyType,
        String activityHistory,
        List<String> trainingDays,
        String goal,
        BigDecimal targetDistance,
        String targetTime,
        String foodIntolerances,
        List<String> availableEquipment
) {
}
