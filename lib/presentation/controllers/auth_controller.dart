import 'package:get/get.dart';
import '../../domain/entities/user.dart';
import '../../domain/use_cases/auth/login_use_case.dart';
import '../../domain/use_cases/auth/logout_use_case.dart';
import '../../data/repositories/auth_repository.dart';

/// Controller de autenticación usando GetX
/// Gestiona el estado de login/logout y usuario actual
class AuthController extends GetxController {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final AuthRepository _authRepository;

  AuthController(
    this._loginUseCase,
    this._logoutUseCase,
    this._authRepository,
  );

  // ==================== STATE ====================

  final Rx<User?> _currentUser = Rx<User?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _isLoggedIn = false.obs;

  User? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;
  bool get isLoggedIn => _isLoggedIn.value;

  // ==================== LIFECYCLE ====================

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  // ==================== METHODS ====================

  /// Verificar estado de login al iniciar
  Future<void> _checkLoginStatus() async {
    _isLoading.value = true;
    try {
      final loggedIn = await _authRepository.isLoggedIn();
      _isLoggedIn.value = loggedIn;

      if (loggedIn) {
        final user = await _authRepository.getCurrentUser();
        _currentUser.value = user;
      }
    } catch (e) {
      _isLoggedIn.value = false;
      _currentUser.value = null;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Iniciar sesión
  Future<void> login() async {
    _isLoading.value = true;
    try {
      final user = await _loginUseCase();
      _currentUser.value = user;
      _isLoggedIn.value = true;

      // Navegar al main screen
      Get.offAllNamed('/main');
      Get.snackbar(
        'Bienvenido',
        '¡Hola ${user.firstName}!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo iniciar sesión: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Cerrar sesión
  Future<void> logout() async {
    _isLoading.value = true;
    try {
      await _logoutUseCase();
      _currentUser.value = null;
      _isLoggedIn.value = false;

      // Navegar al login
      Get.offAllNamed('/login');
      Get.snackbar(
        'Adiós',
        'Sesión cerrada exitosamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo cerrar sesión: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Actualizar foto de perfil del usuario
  Future<void> updateProfilePhoto(String photoPath) async {
    try {
      final updatedUser = await _authRepository.updateUserPhoto(photoPath);
      _currentUser.value = updatedUser;
    } catch (e) {
      rethrow;
    }
  }
}
