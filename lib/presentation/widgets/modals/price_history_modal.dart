import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../app/theme/app_theme.dart';
import '../../../data/providers/local_storage_provider.dart';
import '../../../data/models/price_history_entry_model.dart';
import '../../../domain/entities/price_history_entry.dart';

/// Modal para mostrar el historial de precios de un producto
class PriceHistoryModal extends StatelessWidget {
  final String? productId; // Nullable para datos antiguos
  final String productName;
  final String currency;

  const PriceHistoryModal({
    super.key,
    this.productId, // Opcional para compatibilidad
    required this.productName,
    required this.currency,
  });

  /// Mostrar el modal
  static Future<void> show({
    String? productId, // Opcional
    required String productName,
    required String currency,
  }) async {
    return Get.bottomSheet(
      PriceHistoryModal(
        productId: productId,
        productName: productName,
        currency: currency,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.75,
      decoration: BoxDecoration(
        color: context.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.radiusXL),
          topRight: Radius.circular(AppSpacing.radiusXL),
        ),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(context),

          // Contenido
          Expanded(
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }

  /// Header del modal
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.radiusXL),
          topRight: Radius.circular(AppSpacing.radiusXL),
        ),
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
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: context.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Título
          Row(
            children: [
              Icon(
                Icons.show_chart,
                color: context.primary,
                size: 28,
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Histórico de Precios',
                      style: AppTextStyles.h3(
                        color: context.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      productName,
                      style: AppTextStyles.bodyMedium(
                        color: context.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Get.back(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Contenido del modal
  Widget _buildContent(BuildContext context) {
    // Obtener historial de precios
    final storageProvider = Get.find<LocalStorageProvider>();
    final allHistory = storageProvider.getPriceHistory() ?? [];

    // Filtrar por ID de producto (mismo producto, diferentes compras)
    // Si productId es null (datos antiguos), usar nombre como fallback
    final productHistory = allHistory
        .map((json) => PriceHistoryEntryModel.fromJson(json))
        .where((entry) {
          // Datos nuevos: comparar por productId
          if (entry.productId != null && productId != null) {
            return entry.productId == productId;
          }
          // Datos antiguos: comparar por nombre (fallback)
          return entry.productName.toLowerCase() == productName.toLowerCase();
        })
        .toList();

    // Ordenar por fecha (más reciente primero)
    productHistory.sort((a, b) => b.date.compareTo(a.date));

    if (productHistory.isEmpty) {
      return _buildEmptyState(context);
    }

    // Calcular estadísticas
    final prices = productHistory.map((e) => e.price).toList();
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final avgPrice = prices.reduce((a, b) => a + b) / prices.length;
    final lastPrice = prices.first;
    final priceChange = productHistory.length > 1
        ? ((lastPrice - productHistory.last.price) / productHistory.last.price * 100)
        : 0.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tarjetas de estadísticas
          _buildStatsCards(context, minPrice, maxPrice, avgPrice, priceChange),

          SizedBox(height: AppSpacing.xl),

          // Gráfico de evolución de precios
          if (productHistory.length > 1)
            _buildPriceChart(context, productHistory),

          if (productHistory.length > 1)
            SizedBox(height: AppSpacing.xl),

          // Título
          Text(
            'Historial de Compras',
            style: AppTextStyles.h3(
              color: context.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            '${productHistory.length} ${productHistory.length == 1 ? 'registro' : 'registros'}',
            style: AppTextStyles.bodySmall(
              color: context.textSecondary,
            ),
          ),

          SizedBox(height: AppSpacing.md),

          // Lista de entradas
          ...productHistory.map((entry) => _buildHistoryEntry(context, entry)),
        ],
      ),
    );
  }

  /// Tarjetas de estadísticas
  Widget _buildStatsCards(
    BuildContext context,
    double minPrice,
    double maxPrice,
    double avgPrice,
    double priceChange,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.arrow_downward,
                iconColor: context.success,
                title: '$currency${_formatCurrency(minPrice)}',
                subtitle: 'Precio Mínimo',
                backgroundColor: context.success.withValues(alpha: 0.1),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.arrow_upward,
                iconColor: context.error,
                title: '$currency${_formatCurrency(maxPrice)}',
                subtitle: 'Precio Máximo',
                backgroundColor: context.error.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.analytics_outlined,
                iconColor: context.info,
                title: '$currency${_formatCurrency(avgPrice)}',
                subtitle: 'Precio Promedio',
                backgroundColor: context.info.withValues(alpha: 0.1),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildStatCard(
                context,
                icon: priceChange >= 0 ? Icons.trending_up : Icons.trending_down,
                iconColor: priceChange >= 0 ? context.error : context.success,
                title: '${priceChange >= 0 ? '+' : ''}${priceChange.toStringAsFixed(1)}%',
                subtitle: 'Variación',
                backgroundColor: (priceChange >= 0 ? context.error : context.success).withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Tarjeta de estadística
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
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 18,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: AppTextStyles.bodyLarge(
              color: context.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
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

  /// Entrada del historial
  Widget _buildHistoryEntry(BuildContext context, PriceHistoryEntry entry) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        boxShadow: [
          BoxShadow(
            color: context.shadow,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ícono
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
            ),
            child: Icon(
              Icons.receipt_long,
              color: context.primary,
              size: 20,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          // Información
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.listName,
                  style: AppTextStyles.bodyMedium(
                    color: context.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  _formatDate(entry.date),
                  style: AppTextStyles.bodySmall(
                    color: context.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Precio
          Text(
            '$currency${_formatCurrency(entry.price)}',
            style: AppTextStyles.bodyLarge(
              color: context.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
              Icons.show_chart,
              size: 80,
              color: context.textSecondary.withValues(alpha: 0.5),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'Sin Historial',
              style: AppTextStyles.h3(
                color: context.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Este producto aún no tiene historial de precios registrado',
              style: AppTextStyles.bodyMedium(
                color: context.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Gráfico de evolución de precios
  Widget _buildPriceChart(BuildContext context, List<PriceHistoryEntry> history) {
    // Ordenar por fecha ascendente (más antiguo primero)
    final sortedHistory = List<PriceHistoryEntry>.from(history)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Crear spots para el gráfico
    final spots = sortedHistory.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.price);
    }).toList();

    // Calcular min y max para los ejes
    final prices = sortedHistory.map((e) => e.price).toList();
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final priceRange = maxPrice - minPrice;
    final minY = minPrice - (priceRange * 0.1);
    final maxY = maxPrice + (priceRange * 0.1);

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
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
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: context.primary,
                size: 20,
              ),
              SizedBox(width: AppSpacing.xs),
              Text(
                'Evolución de Precio',
                style: AppTextStyles.bodyLarge(
                  color: context.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: priceRange > 0 ? priceRange / 4 : 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: context.textSecondary.withValues(alpha: 0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < sortedHistory.length) {
                          final date = sortedHistory[value.toInt()].date;
                          return Padding(
                            padding: EdgeInsets.only(top: AppSpacing.xs),
                            child: Text(
                              DateFormat('dd/MM').format(date),
                              style: AppTextStyles.bodySmall(
                                color: context.textSecondary,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      interval: priceRange > 0 ? priceRange / 4 : 1,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '$currency${value.toStringAsFixed(0)}',
                          style: AppTextStyles.bodySmall(
                            color: context.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(
                      color: context.textSecondary.withValues(alpha: 0.2),
                      width: 1,
                    ),
                    left: BorderSide(
                      color: context.textSecondary.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                minX: 0,
                maxX: (sortedHistory.length - 1).toDouble(),
                minY: minY,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: context.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: context.surface,
                          strokeWidth: 2,
                          strokeColor: context.primary,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: context.primary.withValues(alpha: 0.1),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final date = sortedHistory[spot.spotIndex].date;
                        return LineTooltipItem(
                          '$currency${spot.y.toStringAsFixed(2)}\n${DateFormat('dd/MM/yy').format(date)}',
                          AppTextStyles.bodySmall(
                            color: context.surface,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
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

  /// Formatear fecha
  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
}
