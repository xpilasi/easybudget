import 'package:get_storage/get_storage.dart';
import '../../app/config/app_constants.dart';

/// Provider para almacenamiento local usando GetStorage
/// Maneja la persistencia de datos en el dispositivo
class LocalStorageProvider {
  final GetStorage _storage = GetStorage();

  // ==================== THEME ====================

  /// Guardar preferencia de tema oscuro
  Future<void> saveThemeMode(bool isDark) async {
    await _storage.write(AppConstants.keyThemeMode, isDark);
  }

  /// Obtener preferencia de tema oscuro
  bool? getThemeMode() {
    return _storage.read<bool>(AppConstants.keyThemeMode);
  }

  // ==================== AUTH ====================

  /// Guardar estado de login
  Future<void> saveLoginStatus(bool isLoggedIn) async {
    await _storage.write(AppConstants.keyIsLoggedIn, isLoggedIn);
  }

  /// Obtener estado de login
  bool getLoginStatus() {
    return _storage.read<bool>(AppConstants.keyIsLoggedIn) ?? false;
  }

  /// Guardar datos del usuario
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _storage.write(AppConstants.keyUserData, userData);
  }

  /// Obtener datos del usuario
  Map<String, dynamic>? getUserData() {
    final data = _storage.read(AppConstants.keyUserData);
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  // ==================== CATEGORIES ====================

  /// Guardar categorías
  Future<void> saveCategories(List<Map<String, dynamic>> categories) async {
    await _storage.write(AppConstants.keyCategories, categories);
  }

  /// Obtener categorías
  List<Map<String, dynamic>>? getCategories() {
    final data = _storage.read<List>(AppConstants.keyCategories);
    return data?.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  // ==================== SHOPPING LISTS ====================

  /// Guardar listas de compras
  Future<void> saveLists(List<Map<String, dynamic>> lists) async {
    await _storage.write(AppConstants.keyLists, lists);
  }

  /// Obtener listas de compras
  List<Map<String, dynamic>>? getLists() {
    final data = _storage.read<List>(AppConstants.keyLists);
    return data?.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  // ==================== LIST STATE ====================

  /// Guardar productos seleccionados de una lista
  Future<void> saveListSelectedProducts(String listId, List<String> productIds) async {
    await _storage.write('list_${listId}_selected_products', productIds);
  }

  /// Obtener productos seleccionados de una lista
  List<String> getListSelectedProducts(String listId) {
    final data = _storage.read<List>('list_${listId}_selected_products');
    return data?.map((e) => e.toString()).toList() ?? [];
  }

  /// Guardar ordenamiento de una lista
  Future<void> saveListSortOrder(String listId, String sortOrder) async {
    await _storage.write('list_${listId}_sort_order', sortOrder);
  }

  /// Obtener ordenamiento de una lista
  String getListSortOrder(String listId) {
    return _storage.read<String>('list_${listId}_sort_order') ?? 'none';
  }

  /// Guardar filtro de cantidad > 0 de una lista
  Future<void> saveListFilterQuantity(String listId, bool enabled) async {
    await _storage.write('list_${listId}_filter_quantity', enabled);
  }

  /// Obtener filtro de cantidad > 0 de una lista
  bool getListFilterQuantity(String listId) {
    return _storage.read<bool>('list_${listId}_filter_quantity') ?? false;
  }

  /// Guardar filtro de pendientes de una lista
  Future<void> saveListFilterPending(String listId, bool enabled) async {
    await _storage.write('list_${listId}_filter_pending', enabled);
  }

  /// Obtener filtro de pendientes de una lista
  bool getListFilterPending(String listId) {
    return _storage.read<bool>('list_${listId}_filter_pending') ?? false;
  }

  // ==================== FIRST TIME INIT ====================

  /// Verificar si es la primera vez que se inicia la app
  bool isFirstTimeInit() {
    return _storage.read<bool>(AppConstants.keyFirstTimeInit) ?? true;
  }

  /// Marcar que ya se inicializó la app
  Future<void> setFirstTimeInitDone() async {
    await _storage.write(AppConstants.keyFirstTimeInit, false);
  }

  // ==================== UTILITIES ====================

  /// Limpiar todos los datos
  Future<void> clearAll() async {
    await _storage.erase();
  }

  /// Verificar si existe una key
  bool hasData(String key) {
    return _storage.hasData(key);
  }

  /// Eliminar una key específica
  Future<void> remove(String key) async {
    await _storage.remove(key);
  }
}
