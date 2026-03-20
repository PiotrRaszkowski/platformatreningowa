package pl.platformatreningowa.health.control;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class HealthServiceTest {

    @Test
    void shouldReturnUpStatus() {
        HealthService service = new HealthService();

        assertThat(service.getHealthStatus().status()).isEqualTo("UP");
        assertThat(service.getHealthStatus().name()).isEqualTo("Platforma Treningowa API");
    }
}
