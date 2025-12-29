import 'dart:async';

/// Helper para reintentar operaciones fallidas
class RetryHelper {
  RetryHelper._();

  /// Ejecuta una operación con retry logic
  ///
  /// [operation] - La función a ejecutar
  /// [maxAttempts] - Número máximo de intentos (default: 3)
  /// [delayFactor] - Multiplicador de delay entre intentos (default: 2)
  /// [initialDelay] - Delay inicial en segundos (default: 1)
  /// [onRetry] - Callback ejecutado antes de cada retry
  static Future<T> execute<T>({
    required Future<T> Function() operation,
    int maxAttempts = 3,
    int delayFactor = 2,
    int initialDelay = 1,
    void Function(int attempt, Exception error)? onRetry,
  }) async {
    int attempt = 0;
    int delay = initialDelay;
    Exception? lastError;

    while (attempt < maxAttempts) {
      attempt++;

      try {
        return await operation();
      } catch (e) {
        lastError = e is Exception ? e : Exception(e.toString());

        // Si es el último intento, lanzar el error
        if (attempt >= maxAttempts) {
          throw lastError;
        }

        // Callback antes de reintentar
        onRetry?.call(attempt, lastError);

        // Esperar antes de reintentar
        await Future.delayed(Duration(seconds: delay));

        // Incrementar el delay para el siguiente intento
        delay *= delayFactor;
      }
    }

    // Este código nunca debería ejecutarse, pero por seguridad
    throw lastError ?? Exception('Unknown error');
  }

  /// Ejecuta una operación con retry exponencial
  /// Similar a execute() pero con backoff exponencial más agresivo
  static Future<T> executeWithExponentialBackoff<T>({
    required Future<T> Function() operation,
    int maxAttempts = 3,
    Duration initialDelay = const Duration(milliseconds: 500),
    void Function(int attempt, Exception error)? onRetry,
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;
    Exception? lastError;

    while (attempt < maxAttempts) {
      attempt++;

      try {
        return await operation();
      } catch (e) {
        lastError = e is Exception ? e : Exception(e.toString());

        if (attempt >= maxAttempts) {
          throw lastError;
        }

        onRetry?.call(attempt, lastError);

        await Future.delayed(delay);

        // Backoff exponencial: duplicar el delay cada vez
        delay = Duration(milliseconds: delay.inMilliseconds * 2);
      }
    }

    throw lastError ?? Exception('Unknown error');
  }

  /// Ejecuta una operación con timeout y retry
  static Future<T> executeWithTimeout<T>({
    required Future<T> Function() operation,
    Duration timeout = const Duration(seconds: 30),
    int maxAttempts = 3,
    void Function(int attempt, Exception error)? onRetry,
  }) async {
    return execute<T>(
      operation: () => operation().timeout(
        timeout,
        onTimeout: () => throw TimeoutException('Operation timed out'),
      ),
      maxAttempts: maxAttempts,
      onRetry: onRetry,
    );
  }
}

/// Excepción personalizada para timeout
class TimeoutException implements Exception {
  final String message;

  TimeoutException(this.message);

  @override
  String toString() => 'TimeoutException: $message';
}
