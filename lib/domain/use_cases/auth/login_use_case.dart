import '../../../data/repositories/auth_repository.dart';
import '../../entities/user.dart';

/// Caso de uso para iniciar sesión
/// Maneja la lógica de negocio del login
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  /// Ejecutar login
  Future<User> call() async {
    try {
      final user = await _repository.login();
      return user;
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }
}
