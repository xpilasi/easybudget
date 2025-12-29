import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_theme.dart';
import '../common/buttons/create_button.dart';

/// Modal para filtrar y ordenar productos
class FilterProductsModal extends StatefulWidget {
  final String currentSortOrder;
  final bool currentFilterQuantityGreaterThanZero;
  final bool currentFilterPendingOnly;
  final Function(String sortOrder) onSortChanged;
  final Function(bool filterQuantity) onFilterQuantityChanged;
  final Function(bool filterPending) onFilterPendingChanged;

  const FilterProductsModal({
    super.key,
    required this.currentSortOrder,
    required this.currentFilterQuantityGreaterThanZero,
    required this.currentFilterPendingOnly,
    required this.onSortChanged,
    required this.onFilterQuantityChanged,
    required this.onFilterPendingChanged,
  });

  /// Mostrar el modal
  static Future<void> show({
    required String currentSortOrder,
    required bool currentFilterQuantityGreaterThanZero,
    required bool currentFilterPendingOnly,
    required Function(String sortOrder) onSortChanged,
    required Function(bool filterQuantity) onFilterQuantityChanged,
    required Function(bool filterPending) onFilterPendingChanged,
  }) async {
    await Get.bottomSheet(
      FilterProductsModal(
        currentSortOrder: currentSortOrder,
        currentFilterQuantityGreaterThanZero: currentFilterQuantityGreaterThanZero,
        currentFilterPendingOnly: currentFilterPendingOnly,
        onSortChanged: onSortChanged,
        onFilterQuantityChanged: onFilterQuantityChanged,
        onFilterPendingChanged: onFilterPendingChanged,
      ),
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  State<FilterProductsModal> createState() => _FilterProductsModalState();
}

class _FilterProductsModalState extends State<FilterProductsModal> {
  late String _selectedSortOrder;
  late bool _filterQuantityGreaterThanZero;
  late bool _filterPendingOnly;

  @override
  void initState() {
    super.initState();
    _selectedSortOrder = widget.currentSortOrder;
    _filterQuantityGreaterThanZero = widget.currentFilterQuantityGreaterThanZero;
    _filterPendingOnly = widget.currentFilterPendingOnly;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  'Ordenar productos',
                  style: AppTextStyles.h4(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Get.back(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Sección de Filtros
          Text(
            'Filtros',
            style: AppTextStyles.bodyMedium(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildFilterQuantityOption(),
          const SizedBox(height: 12),
          _buildFilterPendingOption(),
          const SizedBox(height: 24),

          // Sección de Ordenamiento
          Text(
            'Ordenar por',
            style: AppTextStyles.bodyMedium(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildSortOption(
            label: 'Sin ordenar',
            value: 'none',
            icon: Icons.clear,
          ),
          const SizedBox(height: 12),
          _buildSortOption(
            label: 'Mayor a menor',
            value: 'price_desc',
            icon: Icons.arrow_downward,
          ),
          const SizedBox(height: 12),
          _buildSortOption(
            label: 'ABC',
            value: 'name_asc',
            icon: Icons.sort_by_alpha,
          ),

          const SizedBox(height: 24),

          // Botón aplicar
          CreateButton(
            buttonText: 'Aplicar',
            onPressed: () {
              widget.onSortChanged(_selectedSortOrder);
              widget.onFilterQuantityChanged(_filterQuantityGreaterThanZero);
              widget.onFilterPendingChanged(_filterPendingOnly);
              Get.back();
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  /// Opción de filtro de cantidad
  Widget _buildFilterQuantityOption() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _filterQuantityGreaterThanZero = !_filterQuantityGreaterThanZero;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _filterQuantityGreaterThanZero
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _filterQuantityGreaterThanZero ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Ícono
            Icon(
              Icons.filter_alt,
              color: _filterQuantityGreaterThanZero ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(width: 16),
            // Texto
            Expanded(
              child: Text(
                'Mayores a 0',
                style: AppTextStyles.bodyLarge(
                  color: _filterQuantityGreaterThanZero
                      ? AppColors.primary
                      : AppColors.textPrimary,
                  fontWeight:
                      _filterQuantityGreaterThanZero ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            // Switch/Check
            Switch(
              value: _filterQuantityGreaterThanZero,
              onChanged: (value) {
                setState(() {
                  _filterQuantityGreaterThanZero = value;
                });
              },
              activeTrackColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  /// Opción de filtro de pendientes
  Widget _buildFilterPendingOption() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _filterPendingOnly = !_filterPendingOnly;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _filterPendingOnly
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _filterPendingOnly ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Ícono
            Icon(
              Icons.pending_actions,
              color: _filterPendingOnly ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(width: 16),
            // Texto
            Expanded(
              child: Text(
                'Pendientes de comprar',
                style: AppTextStyles.bodyLarge(
                  color: _filterPendingOnly
                      ? AppColors.primary
                      : AppColors.textPrimary,
                  fontWeight:
                      _filterPendingOnly ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            // Switch/Check
            Switch(
              value: _filterPendingOnly,
              onChanged: (value) {
                setState(() {
                  _filterPendingOnly = value;
                });
              },
              activeTrackColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  /// Opción de ordenamiento
  Widget _buildSortOption({
    required String label,
    required String value,
    required IconData icon,
  }) {
    final isSelected = _selectedSortOrder == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSortOrder = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Ícono
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(width: 16),
            // Texto
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyLarge(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textPrimary,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            // Check
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
