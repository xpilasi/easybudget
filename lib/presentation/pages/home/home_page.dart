import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/config/app_strings.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/main_controller.dart';
import '../../widgets/modals/create_list_modal.dart';

/// Home Screen - Pantalla principal con estadísticas y listas recientes
class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: _buildAppBar(context),
      // floatingActionButton: _buildFAB(context),
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

                    // Título de listas recientes
                    _buildSectionTitle(context, 'Listas Recientes'),

                    SizedBox(height: AppSpacing.md),

                    // Listas recientes
                    _buildRecentLists(context),
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
        AppStrings.appName,
        style: AppTextStyles.h3(
          color: context.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: context.surface,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          color: context.textSecondary,
          onPressed: () {
            Get.snackbar(
              'Notificaciones',
              'Función en desarrollo',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
      ],
    );
  }

  /// Mostrar modal para crear lista
  

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
          '¡Hola! 👋',
          style: AppTextStyles.h2(
            color: context.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          'Aquí está el resumen de tus listas',
          style: AppTextStyles.bodyMedium(
            color: context.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Tarjetas de estadísticas
  Widget _buildStatsCards(BuildContext context) {
    return Row(
      children: [
        // Total de listas
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.list_alt,
            iconColor: context.primary,
            title: '${controller.totalLists}',
            subtitle: 'Listas',
            backgroundColor: context.primary.withValues(alpha: 0.1),
          ),
        ),
        SizedBox(width: AppSpacing.md),
        // Total gastado
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.attach_money,
            iconColor: context.success,
            title: _formatCurrency(controller.totalSpent),
            subtitle: 'Total',
            backgroundColor: context.success.withValues(alpha: 0.1),
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
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.h3(
            color: context.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            // Navegar a la pestaña de Listas
            final mainController = Get.find<MainController>();
            mainController.changeTab(1);
          },
          child: Text(
            'Ver todas',
            style: AppTextStyles.bodyMedium(
              color: context.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  /// Listas recientes
  Widget _buildRecentLists(BuildContext context) {
    if (controller.recentLists.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: controller.recentLists.map((list) {
        return Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.md),
          child: _buildListCard(context, list),
        );
      }).toList(),
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
          child: Row(
            children: [
              // Indicador de categoría
              Container(
                width: 4,
                height: 48,
                decoration: BoxDecoration(
                  color: category?.color ?? context.primary,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              // Información de la lista
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list.name,
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
                          size: 16,
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
                        SizedBox(width: AppSpacing.md),
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 16,
                          color: context.textSecondary,
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Text(
                          '${list.totalProducts}',
                          style: AppTextStyles.bodySmall(
                            color: context.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Total
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${list.currency}${_formatCurrency(list.total)}',
                    style: AppTextStyles.bodyLarge(
                      color: context.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    _formatDate(list.createdAt),
                    style: AppTextStyles.bodySmall(
                      color: context.textSecondary,
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
            Icons.inbox_outlined,
            size: 80,
            color: context.textSecondary.withValues(alpha: 0.5),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'No tienes listas aún',
            style: AppTextStyles.bodyLarge(
              color: context.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Crea tu primera lista para comenzar',
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
    final formatter = NumberFormat('#,##0.00', 'es_ES');
    return formatter.format(amount);
  }

  /// Formatear fecha
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoy';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} días';
    } else {
      return DateFormat('dd/MM/yy').format(date);
    }
  }
}
