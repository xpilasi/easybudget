import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_theme.dart';
import '../../controllers/list_detail_controller.dart';
import '../../widgets/modals/add_product_modal.dart';
import '../../widgets/modals/edit_product_modal.dart';
import '../../widgets/modals/edit_list_modal.dart';
import '../../widgets/modals/share_modal.dart';
import '../../widgets/modals/filter_products_modal.dart';
import '../../widgets/common/buttons/fab.dart';
import '../../widgets/common/buttons/cancel_button.dart';
import '../../widgets/common/buttons/create_button.dart';

/// List Detail Screen - Pantalla de detalle de lista
/// Muestra productos y permite editar la lista
class ListDetailPage extends GetView<ListDetailController> {
  const ListDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: _buildAppBar(context),
      body: Obx(() {
        if (controller.isLoading) {
          return _buildLoading(context);
        }

        final list = controller.shoppingList;
        if (list == null) {
          return _buildError(context);
        }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          color: context.primary,
          child: CustomScrollView(
            slivers: [
              // Header con información de la lista (fijo)
              SliverPersistentHeader(
                pinned: true,
                delegate: _ListHeaderDelegate(
                  child: _buildListHeader(context),
                  minHeight: 195,
                  maxHeight: 195,
                ),
              ),

              // Productos
              SliverPadding(
                padding: EdgeInsets.all(AppSpacing.md),
                sliver: _buildProductsList(context),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: _buildFABButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /// AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Obx(() {
        return Text(
          controller.shoppingList?.name ?? 'Lista',
          style: AppTextStyles.h4(
            color: context.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        );
      }),
      backgroundColor: context.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: context.textPrimary,
        onPressed: () => Get.back(),
      ),
      actions: [
        // Botón de filtro
        Obx(() {
          final hasFilter = controller.sortOrder != 'none' ||
                           controller.filterQuantityGreaterThanZero ||
                           controller.filterPendingOnly;
          final activeFiltersCount = controller.activeFiltersCount;

          return Badge(
            isLabelVisible: activeFiltersCount > 0,
            label: Text('$activeFiltersCount'),
            backgroundColor: context.primary,
            child: IconButton(
              icon: const Icon(Icons.filter_list),
              color: hasFilter ? context.primary : context.textSecondary,
              onPressed: _showFilterModal,
            ),
          );
        }),
        // Botón de items seleccionados
        Obx(() {
          final selectedCount = controller.selectedProductsCount;

          return Badge(
            isLabelVisible: selectedCount > 0,
            label: Text('$selectedCount'),
            backgroundColor: context.primary,
            child: IconButton(
              icon: const Icon(Icons.shopping_bag_rounded),
              color: selectedCount > 0 ? context.primary : context.textSecondary,
              onPressed: selectedCount > 0 ? () => _showClearSelectionConfirmation(context) : null,
            ),
          );
        }),
        IconButton(
          icon: const Icon(Icons.share_outlined),
          color: context.textSecondary,
          onPressed: _showShareModal,
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          color: context.textSecondary,
          onPressed: () => _showOptionsMenu(context),
        ),
      ],
    );
  }

  /// FAB para agregar producto
  Widget _buildFABButton(BuildContext context) {
    return FabButton(
      onPressed: () => _showAddProductModal(),
      backgroundColor: context.primary,
      foregroundColor: Colors.white,
      elevation: 10,
      iconSize: 32,
      icon: Icons.add,
      child: const Icon(Icons.add, size: 32),
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

  /// Error state
  Widget _buildError(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: context.error,
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'Error al cargar la lista',
            style: AppTextStyles.h4(
              color: context.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Header con información de la lista
  Widget _buildListHeader(BuildContext context) {
    return Obx(() {
      return Container(
        color: context.background,
        padding: EdgeInsets.all(AppSpacing.md),
        child: Container(
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF8E24AA), // Púrpura
                Color.fromARGB(255, 31, 36, 87), // Azul oscuro
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row principal: Columna izquierda (Productos e Items) y Columna derecha (Total)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Columna izquierda: Total de items
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ITEMS',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shopping_bag_rounded,
                            color: Color(0xFF4DB6AC), // Verde turquesa
                            size: 26,
                          ),
                          SizedBox(width: AppSpacing.xs),
                          Text(
                            '${controller.shoppingList?.products.length ?? 0}',
                            style: const TextStyle(
                              color: Color(0xFF4DB6AC), // Verde turquesa
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Columna derecha: Total
                Container(
                  //height: 40,
                  //color: Colors.amberAccent,
                  child: 
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'TOTAL',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      '${controller.currencySymbol}${controller.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF4DB6AC), // Verde turquesa
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),)
              ],
            ),

            SizedBox(height: AppSpacing.md),

            // Buscador
            Container(
              //height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E), // Fondo oscuro
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: TextField(
                onChanged: controller.updateSearchQuery,
                style: const TextStyle(color: Colors.white),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: 'Buscar productos',
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 20,
                  ),
                  suffixIcon: controller.hasActiveSearch
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                          onPressed: controller.clearSearch,
                        )
                      : null,
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
        ),
      );
    });
  }

  /// Lista de productos
  Widget _buildProductsList(BuildContext context) {
    return Obx(() {
      final list = controller.shoppingList;
      if (list == null || list.products.isEmpty) {
        return SliverFillRemaining(
          child: _buildEmptyProducts(context),
        );
      }

      final filteredProducts = controller.filteredProducts;

      // Si hay búsqueda activa pero no hay resultados
      if (controller.hasActiveSearch && filteredProducts.isEmpty) {
        return SliverFillRemaining(
          child: _buildNoSearchResults(context),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = filteredProducts[index];
            return Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md),
              child: _buildDismissibleProductCard(context, product),
            );
          },
          childCount: filteredProducts.length,
        ),
      );
    });
  }

  /// Dismissible wrapper para tarjeta de producto con swipe-to-delete
  Widget _buildDismissibleProductCard(BuildContext context, dynamic product) {
    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmation(
          context,
          title: '¿Eliminar producto?',
          message:
              '¿Estás seguro de que deseas eliminar "${product.name}"?\nEsta acción no se puede deshacer.',
        );
      },
      onDismissed: (direction) {
        controller.deleteProduct(product.id);
        Get.snackbar(
          'Producto eliminado',
          '"${product.name}" ha sido eliminado',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: context.error,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
      child: _buildProductCard(context, product),
    );
  }

  /// Tarjeta de producto
  Widget _buildProductCard(BuildContext context, dynamic product) {
    return Obx(() {
      final isSelected = controller.isProductSelected(product.id);

      return SizedBox(
        height: 110,
        child: GestureDetector(
          onTap: () {
            if (product.quantity == 0) {
              Get.snackbar(
                'No se puede seleccionar',
                'El producto debe tener cantidad mayor a 0',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 2),
                backgroundColor: context.error.withValues(alpha: 0.9),
                colorText: Colors.white,
              );
            } else {
              controller.toggleProductSelection(product.id);
            }
          },
          child: Card(
            elevation: 1,
            color: isSelected
                ? context.primary.withValues(alpha: 0.1)
                : context.surface,
            shadowColor: context.shadow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),
              child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Columna izquierda: Nombre y Controles
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nombre del producto
                  Text(
                    product.name,
                    style: AppTextStyles.bodyLarge(
                      color: context.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),

                  SizedBox(height: 0),

                  // Controles de cantidad
                  Container(
                    width: 130,
                    height: 32,
                    decoration: BoxDecoration(
                      color: context.background,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          iconSize: 16,
                          padding: EdgeInsets.zero,
                          color: context.textSecondary,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          onPressed: () =>
                              controller.decrementProductQuantity(product),
                        ),
                        SizedBox(
                          width: 32,
                          child: Center(
                            child: Text(
                              '${product.quantity}',
                              style: AppTextStyles.bodyLarge(
                                color: context.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          iconSize: 16,
                          padding: EdgeInsets.zero,
                          color: context.primary,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          onPressed: () =>
                              controller.incrementProductQuantity(product),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: AppSpacing.sm),

            // Columna derecha: Total, Desglose y Menú
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Subtotal
                Text(
                  '${controller.currencySymbol}${product.subtotal.toStringAsFixed(2)}',
                  style: AppTextStyles.h3(
                    color: context.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),

                SizedBox(height: 0),

                // Precio unitario × cantidad
                Text(
                  '${controller.currencySymbol}${product.price.toStringAsFixed(2)} × ${product.quantity}',
                  style: AppTextStyles.bodySmall(
                    color: context.textSecondary,
                  ),
                  maxLines: 1,
                ),

                SizedBox(height: 0),

                // Menú de opciones
                Container(
                  //color: Colors.lightGreen,
                  height: 30,
                  child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                    IconButton(
                      alignment: Alignment.centerRight,
                  icon: const Icon(Icons.more_horiz),
                  iconSize: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  color: context.textSecondary,
                  onPressed: () => _showProductOptions(context, product),
                ),
                  ],)
                  )
                
              ],
            ),
          ],
        ),
      ),
    ),
        ),
      );
    });
  }

  /// Estado vacío de productos
  Widget _buildEmptyProducts(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_shopping_cart_outlined,
              size: 100,
              color: context.textSecondary.withValues(alpha: 0.5),
            ),
            SizedBox(height: AppSpacing.xl),
            Text(
              'No hay productos',
              style: AppTextStyles.h3(
                color: context.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Agrega productos a tu lista',
              style: AppTextStyles.bodyMedium(
                color: context.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: _showAddProductModal,
              icon: const Icon(Icons.add),
              label: const Text('Agregar Producto'),
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

  /// Estado de no se encontraron resultados en búsqueda
  Widget _buildNoSearchResults(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: context.textSecondary.withValues(alpha: 0.5),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'No se encontraron productos',
              style: AppTextStyles.h4(
                color: context.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Intenta con otro término de búsqueda',
              style: AppTextStyles.bodyMedium(
                color: context.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.lg),
            TextButton.icon(
              onPressed: controller.clearSearch,
              icon: const Icon(Icons.clear),
              label: const Text('Limpiar búsqueda'),
              style: TextButton.styleFrom(
                foregroundColor: context.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Mostrar modal de agregar producto
  void _showAddProductModal() {
    AddProductModal.show(
      currency: controller.currencySymbol,
      onAddProduct: ({
        required String name,
        required double price,
        required int quantity,
      }) {
        controller.addProduct(
          productName: name,
          price: price,
          quantity: quantity,
        );
      },
    );
  }

  /// Mostrar modal de filtro
  void _showFilterModal() {
    FilterProductsModal.show(
      currentSortOrder: controller.sortOrder,
      currentFilterQuantityGreaterThanZero: controller.filterQuantityGreaterThanZero,
      currentFilterPendingOnly: controller.filterPendingOnly,
      onSortChanged: (sortOrder) {
        if (sortOrder == 'none') {
          controller.clearSort();
        } else {
          controller.setSortOrder(sortOrder);
        }
      },
      onFilterQuantityChanged: (filterQuantity) {
        controller.setFilterQuantityGreaterThanZero(filterQuantity);
      },
      onFilterPendingChanged: (filterPending) {
        controller.setFilterPendingOnly(filterPending);
      },
    );
  }

  /// Mostrar modal de editar producto
  void _showEditProductModal(dynamic product) {
    EditProductModal.show(
      product: product,
      currency: controller.currencySymbol,
      onUpdateProduct: ({
        required String productId,
        required String name,
        required double price,
        required int quantity,
      }) {
        controller.updateProduct(
          productId: productId,
          name: name,
          price: price,
          quantity: quantity,
        );
      },
    );
  }

  /// Mostrar opciones de producto
  void _showProductOptions(BuildContext context, dynamic product) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXL),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: AppSpacing.md),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.border,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Editar'),
                onTap: () {
                  Get.back();
                  _showEditProductModal(product);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_outline, color: context.error),
                title: Text(
                  'Eliminar',
                  style: TextStyle(color: context.error),
                ),
                onTap: () {
                  Get.back();
                  controller.deleteProduct(product.id);
                },
              ),
              SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  /// Mostrar modal de compartir
  void _showShareModal() {
    final list = controller.shoppingList;
    final category = controller.category;

    if (list == null) return;

    ShareModal.show(
      shoppingList: list,
      categoryName: category?.name ?? 'Sin categoría',
    );
  }

  /// Mostrar menú de opciones
  void _showOptionsMenu(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXL),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: AppSpacing.md),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.border,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Editar lista'),
                onTap: () {
                  Get.back();
                  _showEditListModal();
                },
              ),
              ListTile(
                leading: Icon(Icons.check_circle_outline, color: context.success),
                title: Text(
                  'Completar compra',
                  style: TextStyle(color: context.success),
                ),
                onTap: () {
                  Get.back();
                  controller.completeList();
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_outline, color: context.error),
                title: Text(
                  'Eliminar lista',
                  style: TextStyle(color: context.error),
                ),
                onTap: () {
                  Get.back();
                  controller.deleteList();
                },
              ),
              SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  /// Mostrar confirmación de reseteo de selección
  void _showClearSelectionConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text(
          '¿Resetear selección?',
          style: AppTextStyles.h4(
            color: context.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '¿Estás seguro de que deseas resetear todos los productos seleccionados?',
          style: AppTextStyles.bodyMedium(
            color: context.textSecondary,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppDecorations.radiusMD,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: EdgeInsets.all(AppSpacing.md),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              CancelButton(
                buttonText: 'Cancelar',
                onPressed: () => Get.back(),
              ),
              SizedBox(height: AppSpacing.sm),
              CreateButton(
                buttonText: 'Resetear',
                onPressed: () {
                  controller.clearSelection();
                  Get.back();
                  Get.snackbar(
                    'Selección reseteada',
                    'Se han reseteado todos los productos seleccionados',
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2),
                  );
                },
              ),
            ],
          ),
        ],
      ),
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

  /// Mostrar modal para editar lista
  void _showEditListModal() {
    final list = controller.shoppingList;
    if (list == null) return;

    EditListModal.show(
      listId: list.id,
      currentName: list.name,
      currentCategoryId: list.categoryId,
      currentCurrency: list.currency,
      categories: controller.categories,
      onUpdateList: ({
        required String listId,
        required String name,
        required String categoryId,
        required String currency,
      }) {
        controller.updateList(
          name: name,
          categoryId: categoryId,
          currency: currency,
        );
      },
    );
  }
}

/// Delegate para el header fijo
class _ListHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;

  _ListHeaderDelegate({
    required this.child,
    required this.minHeight,
    required this.maxHeight,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_ListHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight;
  }
}
