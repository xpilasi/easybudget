import '../../domain/entities/user.dart';
import '../models/user_model.dart';
import '../providers/local_storage_provider.dart';
import '../providers/mock_data_provider.dart';
import 'auth_repository.dart';

/// Implementación del repositorio de autenticación
/// Usa LocalStorageProvider para persistencia
class AuthRepositoryImpl implements AuthRepository {
  final LocalStorageProvider _storageProvider;

  AuthRepositoryImpl(this._storageProvider);

  @override
  Future<User> login() async {
    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));

    // Verificar si ya existe un usuario guardado
    final existingUserData = _storageProvider.getUserData();
    User user;

    if (existingUserData != null) {
      // Si ya existe un usuario, usar ese en lugar de sobrescribir con mock
      user = UserModel.fromJson(existingUserData);
    } else {
      // Solo crear usuario mock si no existe ninguno (primera vez)
      final mockUser = MockDataProvider.getMockUser();
      await _storageProvider.saveUserData(mockUser.toJson());
      user = mockUser;
    }

    // Actualizar estado de login
    await _storageProvider.saveLoginStatus(true);

    return user;
  }

  @override
  Future<void> logout() async {
    // Solo cambiar el estado de login a false
    // NO borrar datos del usuario ni de la app (listas, categorías, etc.)
    await _storageProvider.saveLoginStatus(false);
  }

  @override
  Future<User?> getCurrentUser() async {
    final userData = _storageProvider.getUserData();
    if (userData == null) return null;

    try {
      return UserModel.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return _storageProvider.getLoginStatus();
  }

  @override
  Future<User> updateUserPhoto(String photoPath) async {
    // Obtener usuario actual
    final currentUser = await getCurrentUser();
    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    // Crear usuario actualizado con nueva foto
    final updatedUser = UserModel(
      id: currentUser.id,
      email: currentUser.email,
      firstName: currentUser.firstName,
      lastName: currentUser.lastName,
      photoUrl: photoPath,
    );

    // Guardar usuario actualizado
    await _storageProvider.saveUserData(updatedUser.toJson());

    return updatedUser;
  }
}
