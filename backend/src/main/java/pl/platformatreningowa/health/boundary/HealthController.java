package pl.platformatreningowa.health.boundary;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pl.platformatreningowa.health.control.HealthService;
import pl.platformatreningowa.health.entity.HealthStatus;

@RestController
@RequestMapping("/api/health")
public class HealthController {

    private final HealthService healthService;

    public HealthController(HealthService healthService) {
        this.healthService = healthService;
    }

    @GetMapping
    public ResponseEntity<HealthStatus> health() {
        return ResponseEntity.ok(healthService.getHealthStatus());
    }
}
