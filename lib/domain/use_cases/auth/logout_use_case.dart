import '../../../data/repositories/auth_repository.dart';

/// Caso de uso para cerrar sesión
/// Maneja la lógica de negocio del logout
class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  /// Ejecutar logout
  Future<void> call() async {
    try {
      await _repository.logout();
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }
}
