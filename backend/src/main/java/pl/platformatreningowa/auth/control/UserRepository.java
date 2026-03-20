package pl.platformatreningowa.auth.control;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import pl.platformatreningowa.auth.entity.UserEntity;

public interface UserRepository extends JpaRepository<UserEntity, Long> {
    Optional<UserEntity> findByEmailIgnoreCase(String email);
    boolean existsByEmailIgnoreCase(String email);
}
