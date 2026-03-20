package pl.platformatreningowa.shared.entity;

public class UnauthorizedException extends RuntimeException {
    public UnauthorizedException(String message) { super(message); }
}
