import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_theme.dart';
import '../../../domain/entities/completed_purchase.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/product.dart';
import '../../widgets/modals/price_history_modal.dart';

/// Purchase Detail Screen - Pantalla de detalle de compra completada
class PurchaseDetailPage extends StatelessWidget {
  final CompletedPurchase purchase;
  final Category? category;

  const PurchaseDetailPage({
    super.key,
    required this.purchase,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con información de la compra
            _buildHeader(context),

            SizedBox(height: AppSpacing.lg),

            // Tarjetas de estadísticas
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: _buildStatsCards(context),
            ),

            SizedBox(height: AppSpacing.xl),

            // Título de productos
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: _buildSectionTitle(context),
            ),

            SizedBox(height: AppSpacing.md),

            // Lista de productos
            _buildProductsList(context),

            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  /// AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Detalle de Compra',
        style: AppTextStyles.h3(
          color: context.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: context.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
    );
  }

  /// Header con información principal
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.surface,
        boxShadow: [
          BoxShadow(
            color: context.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono de completado + Nombre
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: context.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: context.success,
                  size: 28,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  purchase.listName,
                  style: AppTextStyles.h2(
                    color: context.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.md),

          // Categoría
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: category?.color ?? context.primary,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Icon(
                Icons.category_outlined,
                size: 18,
                color: context.textSecondary,
              ),
              SizedBox(width: AppSpacing.xs),
              Text(
                category?.name ?? 'Sin categoría',
                style: AppTextStyles.bodyMedium(
                  color: context.textSecondary,
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.sm),

          // Fecha de compra
          Row(
            children: [
              Icon(
                Icons.event,
                size: 18,
                color: context.textSecondary,
              ),
              SizedBox(width: AppSpacing.xs),
              Text(
                'Completada: ${_formatFullDate(purchase.completedAt)}',
                style: AppTextStyles.bodyMedium(
                  color: context.textSecondary,
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.lg),

          // Total
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
              border: Border.all(
                color: context.success.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Gastado',
                  style: AppTextStyles.bodySmall(
                    color: context.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  '${purchase.currency}${_formatCurrency(purchase.total)}',
                  style: AppTextStyles.h1(
                    color: context.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Tarjetas de estadísticas
  Widget _buildStatsCards(BuildContext context) {
    return Row(
      children: [
        // Total de productos
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.shopping_basket_outlined,
            iconColor: context.primary,
            title: '${purchase.totalProducts}',
            subtitle: 'Productos',
            backgroundColor: context.primary.withValues(alpha: 0.1),
          ),
        ),
        SizedBox(width: AppSpacing.md),
        // Total de items
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.inventory_2_outlined,
            iconColor: context.info,
            title: '${purchase.totalItems}',
            subtitle: 'Items',
            backgroundColor: context.info.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }

  /// Tarjeta de estadística individual
  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Color backgroundColor,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        boxShadow: [
          BoxShadow(
            color: context.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ícono
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          // Título
          Text(
            title,
            style: AppTextStyles.h2(
              color: context.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          // Subtítulo
          Text(
            subtitle,
            style: AppTextStyles.bodySmall(
              color: context.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Título de sección
  Widget _buildSectionTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Productos Comprados',
          style: AppTextStyles.h3(
            color: context.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: context.textSecondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
          ),
          child: Text(
            '${purchase.totalProducts}',
            style: AppTextStyles.bodySmall(
              color: context.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// Lista de productos
  Widget _buildProductsList(BuildContext context) {
    if (purchase.products.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: purchase.products.length,
      separatorBuilder: (context, index) => SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final product = purchase.products[index];
        return _buildProductCard(context, product);
      },
    );
  }

  /// Tarjeta de producto
  Widget _buildProductCard(BuildContext context, Product product) {
    final subtotal = product.price * product.quantity;

    return Card(
      elevation: 2,
      shadowColor: context.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Información del producto
                Expanded(
                  child: Text(
                    product.name,
                    style: AppTextStyles.bodyLarge(
                      color: context.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                // Botón de histórico de precios
                IconButton(
                  icon: Icon(
                    Icons.show_chart,
                    color: context.primary,
                  ),
                  onPressed: () {
                    PriceHistoryModal.show(
                      productId: product.id,
                      productName: product.name,
                      currency: purchase.currency,
                    );
                  },
                  tooltip: 'Ver histórico de precios',
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            // Fila de detalles
            Row(
              children: [
                // Cantidad
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: context.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 14,
                        color: context.primary,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        '${product.quantity}',
                        style: AppTextStyles.bodySmall(
                          color: context.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                // Precio unitario
                Text(
                  '${purchase.currency}${_formatCurrency(product.price)} c/u',
                  style: AppTextStyles.bodySmall(
                    color: context.textSecondary,
                  ),
                ),
                const Spacer(),
                // Subtotal
                Text(
                  '${purchase.currency}${_formatCurrency(subtotal)}',
                  style: AppTextStyles.bodyLarge(
                    color: context.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Estado vacío (no debería pasar)
  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 60,
            color: context.textSecondary.withValues(alpha: 0.5),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'No hay productos en esta compra',
            style: AppTextStyles.bodyMedium(
              color: context.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Formatear moneda
  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(amount);
  }

  /// Formatear fecha completa
  String _formatFullDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
}
