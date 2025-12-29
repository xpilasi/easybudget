import '../../entities/completed_purchase.dart';
import '../../../data/repositories/completed_purchase_repository.dart';

/// Caso de uso para obtener el historial de compras completadas
/// Retorna todas las compras ordenadas por fecha (más reciente primero)
class GetPurchaseHistoryUseCase {
  final CompletedPurchaseRepository _repository;

  GetPurchaseHistoryUseCase(this._repository);

  /// Ejecutar caso de uso
  /// Retorna todas las compras completadas ordenadas por fecha descendente
  Future<List<CompletedPurchase>> call() async {
    return await _repository.getCompletedPurchases();
  }
}
