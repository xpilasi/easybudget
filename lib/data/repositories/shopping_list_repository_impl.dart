import 'package:uuid/uuid.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/shopping_list.dart';
import '../models/product_model.dart';
import '../models/shopping_list_model.dart';
import '../providers/local_storage_provider.dart';
import '../providers/mock_data_provider.dart';
import 'shopping_list_repository.dart';

/// Implementación del repositorio de listas de compras
/// Usa LocalStorageProvider para persistencia
class ShoppingListRepositoryImpl implements ShoppingListRepository {
  final LocalStorageProvider _storageProvider;
  final Uuid _uuid = const Uuid();

  ShoppingListRepositoryImpl(this._storageProvider);

  // ==================== LISTAS ====================

  @override
  Future<List<ShoppingList>> getLists() async {
    // Intentar obtener listas guardadas
    final storedLists = _storageProvider.getLists();

    if (storedLists != null) {
      // Si existen datos guardados (aunque sea lista vacía), retornarlos
      return storedLists
          .map((json) => ShoppingListModel.fromJson(json))
          .toList();
    }

    // Si no hay datos guardados, verificar si es la primera vez
    if (_storageProvider.isFirstTimeInit()) {
      // Solo en la primera vez, cargar y guardar datos mock
      final mockLists = MockDataProvider.getMockLists();
      await _saveLists(mockLists);
      await _storageProvider.setFirstTimeInitDone();
      return mockLists;
    }

    // Si no es primera vez y no hay datos, retornar lista vacía
    return [];
  }

  @override
  Future<ShoppingList?> getListById(String id) async {
    final lists = await getLists();
    try {
      return lists.firstWhere((list) => list.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ShoppingList> createList({
    required String name,
    required String categoryId,
    required String currency,
  }) async {
    final lists = await getLists();

    // Crear nueva lista
    final newList = ShoppingListModel(
      id: _uuid.v4(),
      name: name,
      categoryId: categoryId,
      currency: currency,
      products: [],
      createdAt: DateTime.now(),
    );

    // Agregar y guardar
    final updatedLists = [
      ...lists.map((l) => ShoppingListModel.fromEntity(l)),
      newList,
    ];
    await _saveLists(updatedLists);

    return newList;
  }

  @override
  Future<ShoppingList> updateList(ShoppingList list) async {
    final lists = await getLists();

    // Actualizar lista
    final updatedLists = lists.map((l) {
      return l.id == list.id
          ? ShoppingListModel.fromEntity(list)
          : ShoppingListModel.fromEntity(l);
    }).toList();

    await _saveLists(updatedLists);
    return list;
  }

  @override
  Future<void> deleteList(String listId) async {
    final lists = await getLists();

    // Eliminar lista
    final updatedLists = lists
        .where((l) => l.id != listId)
        .map((l) => ShoppingListModel.fromEntity(l))
        .toList();

    await _saveLists(updatedLists);
  }

  // ==================== PRODUCTOS ====================

  @override
  Future<ShoppingList> addProduct({
    required String listId,
    required Product product,
  }) async {
    final list = await getListById(listId);
    if (list == null) {
      throw Exception('Lista no encontrada');
    }

    // Crear producto con ID único si no tiene
    final productWithId = product.id.isEmpty
        ? ProductModel(
            id: _uuid.v4(),
            name: product.name,
            price: product.price,
            quantity: product.quantity,
          )
        : ProductModel.fromEntity(product);

    // Agregar producto a la lista
    final updatedList = list.addProduct(productWithId);
    await updateList(updatedList);

    return updatedList;
  }

  @override
  Future<ShoppingList> updateProduct({
    required String listId,
    required Product product,
  }) async {
    final list = await getListById(listId);
    if (list == null) {
      throw Exception('Lista no encontrada');
    }

    // Actualizar producto
    final updatedList = list.updateProduct(product);
    await updateList(updatedList);

    return updatedList;
  }

  @override
  Future<ShoppingList> deleteProduct({
    required String listId,
    required String productId,
  }) async {
    final list = await getListById(listId);
    if (list == null) {
      throw Exception('Lista no encontrada');
    }

    // Eliminar producto
    final updatedList = list.removeProduct(productId);
    await updateList(updatedList);

    return updatedList;
  }

  // ==================== HELPERS ====================

  Future<void> _saveLists(List<ShoppingListModel> lists) async {
    final listsJson = lists.map((l) => l.toJson()).toList();
    await _storageProvider.saveLists(listsJson);
  }
}
