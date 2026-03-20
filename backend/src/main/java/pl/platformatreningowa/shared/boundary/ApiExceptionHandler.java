package pl.platformatreningowa.shared.boundary;

import jakarta.validation.ConstraintViolationException;
import java.util.List;
import org.springframework.context.support.DefaultMessageSourceResolvable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import pl.platformatreningowa.shared.entity.ApiError;
import pl.platformatreningowa.shared.entity.ConflictException;
import pl.platformatreningowa.shared.entity.UnauthorizedException;
import pl.platformatreningowa.shared.entity.ValidationException;

@RestControllerAdvice
public class ApiExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiError> handleValidation(MethodArgumentNotValidException exception) {
        List<String> details = exception.getBindingResult().getAllErrors().stream()
                .map(error -> error instanceof FieldError fieldError
                        ? fieldError.getField() + ": " + fieldError.getDefaultMessage()
                        : error.getDefaultMessage())
                .toList();
        return ResponseEntity.badRequest().body(new ApiError("Validation failed", details));
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public ResponseEntity<ApiError> handleConstraintViolation(ConstraintViolationException exception) {
        return ResponseEntity.badRequest().body(new ApiError("Validation failed", List.of(exception.getMessage())));
    }

    @ExceptionHandler(ValidationException.class)
    public ResponseEntity<ApiError> handleCustomValidation(ValidationException exception) {
        return ResponseEntity.badRequest().body(new ApiError(exception.getMessage(), List.of()));
    }

    @ExceptionHandler(ConflictException.class)
    public ResponseEntity<ApiError> handleConflict(ConflictException exception) {
        return ResponseEntity.status(HttpStatus.CONFLICT).body(new ApiError(exception.getMessage(), List.of()));
    }

    @ExceptionHandler(UnauthorizedException.class)
    public ResponseEntity<ApiError> handleUnauthorized(UnauthorizedException exception) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(new ApiError(exception.getMessage(), List.of()));
    }
}
