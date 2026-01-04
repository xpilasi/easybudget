import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_theme.dart';
import '../../controllers/history_controller.dart';

/// History Screen - Pantalla de historial completo de compras
class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({super.key});

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
              SliverPadding(
                padding: EdgeInsets.all(AppSpacing.lg),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Header de bienvenida
                    _buildWelcomeHeader(context),

                    SizedBox(height: AppSpacing.lg),

                    // Tarjetas de estadísticas
                    _buildStatsCards(context),

                    SizedBox(height: AppSpacing.xl),

                    // Título de sección
                    _buildSectionTitle(context),

                    SizedBox(height: AppSpacing.md),

                    // Lista de compras completadas
                    _buildPurchasesList(context),
                  ]),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Historial de Compras',
        style: AppTextStyles.h3(
          color: context.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: context.surface,
      elevation: 0,
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

  /// Header de bienvenida
  Widget _buildWelcomeHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tus Compras',
          style: AppTextStyles.h2(
            color: context.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          'Revisa el historial completo de tus compras',
          style: AppTextStyles.bodyMedium(
            color: context.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Tarjetas de estadísticas
  Widget _buildStatsCards(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // Total de compras
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.shopping_bag,
                iconColor: context.primary,
                title: '${controller.totalPurchases}',
                subtitle: 'Compras',
                backgroundColor: context.primary.withValues(alpha: 0.1),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            // Total gastado
            // Expanded(
            //   child: _buildStatCard(
            //     context,
            //     icon: Icons.attach_money,
            //     iconColor: context.success,
            //     title: _formatCurrency(controller.totalSpent),
            //     subtitle: 'Total',
            //     backgroundColor: context.success.withValues(alpha: 0.1),
            //   ),
            // ),
            _buildStatCard(
          context,
          icon: Icons.trending_up,
          iconColor: context.info,
          title: _formatCurrency(controller.averageSpent),
          subtitle: 'Promedio por compra',
          backgroundColor: context.info.withValues(alpha: 0.1),
        ),
          ],
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
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
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
          // Ícono
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          SizedBox(height: AppSpacing.md),
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
          'Todas las Compras',
          style: AppTextStyles.h3(
            color: context.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Obx(() => Text(
              '${controller.totalPurchases} total',
              style: AppTextStyles.bodyMedium(
                color: context.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            )),
      ],
    );
  }

  /// Lista de compras
  Widget _buildPurchasesList(BuildContext context) {
    if (controller.purchases.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: controller.purchases.map((purchase) {
        return Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.md),
          child: _buildPurchaseCard(context, purchase),
        );
      }).toList(),
    );
  }

  /// Tarjeta de compra completada
  Widget _buildPurchaseCard(BuildContext context, dynamic purchase) {
    final category = controller.getCategoryById(purchase.categoryId);

    return Card(
      elevation: 2,
      shadowColor: context.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
      ),
      child: InkWell(
        onTap: () => controller.navigateToPurchaseDetail(purchase.id),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              // Indicador de categoría
              Container(
                width: 4,
                height: 64,
                decoration: BoxDecoration(
                  color: category?.color ?? context.success,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              // Icono de completado
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: context.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: context.success,
                  size: 24,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              // Información de la compra
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      purchase.listName,
                      style: AppTextStyles.bodyLarge(
                        color: context.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 14,
                          color: context.textSecondary,
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Flexible(
                          child: Text(
                            category?.name ?? 'Sin categoría',
                            style: AppTextStyles.bodySmall(
                              color: context.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Icon(
                          Icons.event,
                          size: 14,
                          color: context.textSecondary,
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Text(
                          _formatDate(purchase.completedAt),
                          style: AppTextStyles.bodySmall(
                            color: context.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Total e items
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${purchase.currency}${_formatCurrency(purchase.total)}',
                    style: AppTextStyles.bodyLarge(
                      color: context.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
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
                      '${purchase.totalProducts} items',
                      style: AppTextStyles.bodySmall(
                        color: context.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
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
    return Container(
      padding: EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: context.textSecondary.withValues(alpha: 0.5),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'No hay compras completadas',
            style: AppTextStyles.bodyLarge(
              color: context.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Completa una lista para verla aquí',
            style: AppTextStyles.bodyMedium(
              color: context.textSecondary,
            ),
            textAlign: TextAlign.center,
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

  /// Formatear fecha
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoy ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays == 1) {
      return 'Ayer ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Hace $weeks ${weeks == 1 ? 'semana' : 'semanas'}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'Hace $months ${months == 1 ? 'mes' : 'meses'}';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
}
