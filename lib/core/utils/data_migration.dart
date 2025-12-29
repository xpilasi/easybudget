import 'package:uuid/uuid.dart';
import '../../data/models/completed_purchase_model.dart';
import '../../data/providers/local_storage_provider.dart';

/// Utilidad para migración de datos
/// Migra listas con isCompleted:true al nuevo modelo CompletedPurchase
class DataMigration {
  final LocalStorageProvider _storageProvider;
  final Uuid _uuid = const Uuid();

  DataMigration(this._storageProvider);

  /// Migrar listas completadas a compras completadas
  /// Este método se ejecuta una sola vez durante la primera carga después de actualizar
  Future<void> migrateCompletedListsToPurchases() async {
    print('🔄 Iniciando migración de datos...');

    try {
      // 1. Leer listas actuales del storage
      final listsData = _storageProvider.getLists();
      if (listsData == null || listsData.isEmpty) {
        print('✅ No hay listas para migrar');
        return;
      }

      print('📋 Total de listas en storage: ${listsData.length}');

      // 2. Separar listas activas y completadas
      final activeLists = <Map<String, dynamic>>[];
      final completedListsData = <Map<String, dynamic>>[];

      for (final listData in listsData) {
        final isCompleted = listData['isCompleted'] as bool? ?? false;

        if (isCompleted) {
          completedListsData.add(listData);
        } else {
          // Limpiar campos de completed de listas activas
          final cleanedList = Map<String, dynamic>.from(listData);
          cleanedList.remove('isCompleted');
          cleanedList.remove('completedAt');
          cleanedList.remove('completedTotal');
          activeLists.add(cleanedList);
        }
      }

      print('📊 Listas activas: ${activeLists.length}');
      print('📊 Listas completadas: ${completedListsData.length}');

      // 3. Convertir listas completadas a CompletedPurchase
      final purchases = <Map<String, dynamic>>[];

      for (final listData in completedListsData) {
        try {
          // Extraer datos de la lista completada
          final listId = listData['id'] as String;
          final listName = listData['name'] as String;
          final categoryId = listData['categoryId'] as String;
          final currency = listData['currency'] as String;
          final products = listData['products'] as List<dynamic>? ?? [];
          final createdAtStr = listData['createdAt'] as String;
          final completedAtStr = listData['completedAt'] as String?;
          final completedTotal = listData['completedTotal'] as double?;

          // Parsear fechas
          final createdAt = DateTime.parse(createdAtStr);
          final completedAt = completedAtStr != null
              ? DateTime.parse(completedAtStr)
              : createdAt;

          // Calcular total si no está disponible
          double total = completedTotal ?? 0.0;
          if (total == 0.0 && products.isNotEmpty) {
            for (final product in products) {
              final price = (product['price'] as num?)?.toDouble() ?? 0.0;
              final quantity = (product['quantity'] as int?) ?? 0;
              total += price * quantity;
            }
          }

          // Crear CompletedPurchase
          final purchase = {
            'id': _uuid.v4(), // Nuevo ID único para la compra
            'listId': listId, // ID de la lista original
            'listName': listName,
            'categoryId': categoryId,
            'currency': currency,
            'products': products,
            'createdAt': createdAt.toIso8601String(),
            'completedAt': completedAt.toIso8601String(),
            'total': total,
          };

          purchases.add(purchase);
          print('✅ Migrada: $listName → CompletedPurchase');
        } catch (e) {
          print('❌ Error migrando lista: $e');
          // Continuar con las demás listas
        }
      }

      // 4. Guardar en storages separados

      // Guardar listas activas (sin campos de completed)
      await _storageProvider.saveLists(activeLists);
      print('💾 Guardadas ${activeLists.length} listas activas');

      // Guardar compras completadas
      if (purchases.isNotEmpty) {
        await _storageProvider.saveCompletedPurchases(purchases);
        print('💾 Guardadas ${purchases.length} compras completadas');
      }

      print('✅ Migración completada exitosamente');
      print('   - Listas activas: ${activeLists.length}');
      print('   - Compras completadas: ${purchases.length}');

    } catch (e) {
      print('❌ Error durante la migración: $e');
      rethrow;
    }
  }

  /// Verificar si la migración ya se ejecutó
  /// Retorna true si ya se migró (no hay listas con isCompleted en el storage)
  Future<bool> isMigrationNeeded() async {
    final listsData = _storageProvider.getLists();
    if (listsData == null || listsData.isEmpty) {
      return false; // No hay datos, no necesita migración
    }

    // Verificar si alguna lista tiene el campo isCompleted
    for (final listData in listsData) {
      if (listData.containsKey('isCompleted')) {
        return true; // Hay listas con formato antiguo, necesita migración
      }
    }

    return false; // Todas las listas ya están en nuevo formato
  }
}
