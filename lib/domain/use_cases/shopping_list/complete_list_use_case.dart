import '../../entities/completed_purchase.dart';
import '../../../data/repositories/shopping_list_repository.dart';
import '../../../data/repositories/completed_purchase_repository.dart';

/// Caso de uso para completar una lista de compras
/// Crea una compra completada (snapshot) de la lista actual
/// La lista original permanece intacta para reutilización
class CompleteListUseCase {
  final ShoppingListRepository _listRepository;
  final CompletedPurchaseRepository _purchaseRepository;

  CompleteListUseCase(
    this._listRepository,
    this._purchaseRepository,
  );

  /// Ejecutar caso de uso
  /// Retorna la compra completada creada
  Future<CompletedPurchase> execute(String listId) async {
    print('🎯 CompleteListUseCase: Iniciando para listId = $listId');

    // 1. Obtener lista actual
    final list = await _listRepository.getListById(listId);
    if (list == null) {
      print('❌ CompleteListUseCase: Lista no encontrada');
      throw Exception('Lista no encontrada');
    }

    print('🎯 CompleteListUseCase: Lista encontrada: ${list.name}');

    // 2. Validar que tenga productos
    if (list.products.isEmpty) {
      print('❌ CompleteListUseCase: Lista sin productos');
      throw Exception('No se puede completar una lista sin productos');
    }

    // 3. Crear compra completada (CLONA la lista)
    final purchase = await _purchaseRepository.createFromList(list);

    print('✅ CompleteListUseCase: Compra creada exitosamente');
    print('   - Purchase ID: ${purchase.id}');
    print('   - List ID: ${purchase.listId}');
    print('   - Total: ${purchase.total}');
    print('   - Lista original PERMANECE sin cambios');

    // 4. La lista original permanece sin cambios (no se elimina, no se modifica)

    return purchase;
  }
}
