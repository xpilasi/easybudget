import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_theme.dart';
import '../../controllers/lists_controller.dart';
import '../../widgets/modals/create_list_modal.dart';
import '../../widgets/modals/manage_categories_modal.dart';
import '../../widgets/modals/filter_categories_modal.dart';
import '../../widgets/common/buttons/fab.dart';

/// Lists Screen - Pantalla de listas de compras
/// Muestra todas las listas organizadas por categorías con filtros
class ListsPage extends GetView<ListsController> {
  
  const ListsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: _buildAppBar(context),
      body: Obx(() {
        if (controller.isLoading) {
          return _buildLoading(context);
        }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          color: context.primary,
          child: CustomScrollView(
            slivers: [
              // Listas
              SliverPadding(
                padding: EdgeInsets.all(AppSpacing.lg),
                sliver: _buildListsContent(context),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FABButton(context),
    );
  }

  /// AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Mis Listas',
        style: AppTextStyles.h3(
          color: context.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: context.surface,
      elevation: 0,
      actions: [
        // Botón de filtro
        Obx(() {
          final hasFilter = controller.selectedCategoryFilters.isNotEmpty;
          return Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                color: hasFilter ? context.primary : context.textSecondary,
                onPressed: _showFilterModal,
              ),
              if (hasFilter)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: context.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${controller.selectedCategoryFilters.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
        IconButton(
          icon: const Icon(Icons.category_outlined),
          color: context.textSecondary,
          onPressed: _showManageCategoriesModal,
        ),
      ],
    );
  }

  /// Loading indicator
  Widget _buildLoading(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: context.primary,
      ),
    );
  }

  /// Contenido de listas
  Widget _buildListsContent(BuildContext context) {
    return Obx(() {
      final lists = controller.filteredLists;

      if (lists.isEmpty) {
        return SliverFillRemaining(
          child: _buildEmptyState(context),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (builderContext, index) {
            final list = lists[index];
            return Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md),
              child: _buildDismissibleListCard(builderContext, list),
            );
          },
          childCount: lists.length,
        ),
      );
    });
  }

  /// Dismissible wrapper para tarjeta de lista con swipe-to-delete
  Widget _buildDismissibleListCard(BuildContext context, dynamic list) {
    return Dismissible(
      key: ValueKey(list.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmation(
          context,
          title: '¿Eliminar lista?',
          message:
              '¿Estás seguro de que deseas eliminar "${list.name}"?\nEsta acción no se puede deshacer.',
        );
      },
      onDismissed: (direction) {
        controller.deleteList(list.id);
        Get.snackbar(
          'Lista eliminada',
          '"${list.name}" ha sido eliminada',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: context.error,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 32,
        ),
      ),
      child: _buildListCard(context, list),
    );
  }

  /// Tarjeta de lista
  Widget _buildListCard(BuildContext context, dynamic list) {
    final category = controller.getCategoryById(list.categoryId);

    return Card(
      elevation: 2,
      shadowColor: context.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
      ),
      child: InkWell(
        onTap: () => controller.navigateToListDetail(list.id),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: nombre y categoría
              Row(
                children: [
                  // Indicador de color
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: category?.color ?? context.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  // Nombre
                  Expanded(
                    child: Text(
                      list.name,
                      style: AppTextStyles.bodyLarge(
                        color: context.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Categoría badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: category?.color.withValues(alpha: 0.15) ??
                          context.primary.withValues(alpha: 0.15),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSM),
                    ),
                    child: Text(
                      category?.name ?? 'Sin categoría',
                      style: AppTextStyles.bodySmall(
                        color: category?.color ?? context.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.md),

              // Stats
              Row(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 18,
                    color: context.textSecondary,
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Text(
                    '${list.totalProducts} productos',
                    style: AppTextStyles.bodySmall(
                      color: context.textSecondary,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 18,
                    color: context.textSecondary,
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Text(
                    '${list.totalItems} items',
                    style: AppTextStyles.bodySmall(
                      color: context.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  // Total
                  Text(
                    '${list.currency}${list.total.toStringAsFixed(2)}',
                    style: AppTextStyles.h4(
                      color: context.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Estado vacío
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 100,
              color: context.textSecondary.withValues(alpha: 0.5),
            ),
            SizedBox(height: AppSpacing.xl),
            Text(
              'No hay listas',
              style: AppTextStyles.h3(
                color: context.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              controller.selectedCategoryFilters.isEmpty
                  ? 'Crea tu primera lista de compras'
                  : 'No hay listas en las categorías seleccionadas',
              style: AppTextStyles.bodyMedium(
                color: context.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: _showCreateListModal,
              icon: const Icon(Icons.add),
              label: const Text('Crear Lista'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// FAB para crear lista
  Widget FABButton(BuildContext context) {
    return FabButton(
      onPressed: () => _showCreateListModal(),
      backgroundColor: context.primary,
    foregroundColor: Colors.white,
    elevation: 10,
    iconSize: 32,
    icon: Icons.add,
    child: const Icon(Icons.add, size: 32),
  );
}


  /// Mostrar modal de filtro
  void _showFilterModal() {
    FilterCategoriesModal.show(
      categories: controller.categories,
      selectedCategoryIds: controller.selectedCategoryFilters,
      onFilterChanged: (categoryIds) {
        controller.setSelectedCategoryFilters(categoryIds);
      },
    );
  }

  /// Mostrar modal de crear lista
  void _showCreateListModal() {
    CreateListModal.show(
      categories: controller.categories,
      onCreateList: ({
        required String name,
        required String categoryId,
        required String currency,
      }) {
        controller.createList(
          name: name,
          categoryId: categoryId,
          currency: currency,
        );
      },
    );
  }

  /// Mostrar modal de gestionar categorías
  void _showManageCategoriesModal() {
    ManageCategoriesModal.show(
      categories: controller.categories,
      onCreateCategory: ({
        required String name,
        required Color color,
      }) {
        controller.createCategory(
          name: name,
          color: color,
        );
      },
      onUpdateCategory: ({
        required String categoryId,
        required String name,
        required Color color,
      }) {
        controller.updateCategory(
          id: categoryId,
          name: name,
          color: color,
        );
      },
      onDeleteCategory: (String categoryId) {
        controller.deleteCategory(categoryId);
      },
    );
  }

  /// Mostrar confirmación de eliminación
  Future<bool?> _showDeleteConfirmation(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    return Get.dialog<bool>(
      AlertDialog(
        title: Text(
          title,
          style: AppTextStyles.h4(
            color: context.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: AppTextStyles.bodyMedium(
            color: context.textSecondary,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppDecorations.radiusMD,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              'Cancelar',
              style: AppTextStyles.button(
                color: context.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: AppDecorations.radiusMD,
              ),
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
