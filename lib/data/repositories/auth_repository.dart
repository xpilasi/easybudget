import '../../domain/entities/user.dart';

/// Interfaz del repositorio de autenticación
/// Define el contrato para operaciones de autenticación
abstract class AuthRepository {
  /// Iniciar sesión (mock)
  Future<User> login();

  /// Cerrar sesión
  Future<void> logout();

  /// Obtener usuario actual
  Future<User?> getCurrentUser();

  /// Verificar si está logueado
  Future<bool> isLoggedIn();

  /// Actualizar foto de perfil del usuario
  Future<User> updateUserPhoto(String photoPath);
}
