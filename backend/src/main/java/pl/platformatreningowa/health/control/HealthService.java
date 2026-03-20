package pl.platformatreningowa.health.control;

import org.springframework.stereotype.Service;
import pl.platformatreningowa.health.entity.HealthStatus;

@Service
public class HealthService {

    public HealthStatus getHealthStatus() {
        return new HealthStatus("UP", "Platforma Treningowa API");
    }
}
