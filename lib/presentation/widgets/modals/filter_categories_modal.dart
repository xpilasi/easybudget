import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_theme.dart';
import '../../../domain/entities/category.dart';
import '../common/buttons/create_button.dart';

/// Modal para filtrar por categorías
class FilterCategoriesModal extends StatefulWidget {
  final List<Category> categories;
  final List<String> selectedCategoryIds;
  final Function(List<String> categoryIds) onFilterChanged;

  const FilterCategoriesModal({
    super.key,
    required this.categories,
    required this.selectedCategoryIds,
    required this.onFilterChanged,
  });

  /// Mostrar el modal
  static Future<void> show({
    required List<Category> categories,
    required List<String> selectedCategoryIds,
    required Function(List<String> categoryIds) onFilterChanged,
  }) async {
    await Get.bottomSheet(
      FilterCategoriesModal(
        categories: categories,
        selectedCategoryIds: selectedCategoryIds,
        onFilterChanged: onFilterChanged,
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
  State<FilterCategoriesModal> createState() => _FilterCategoriesModalState();
}

class _FilterCategoriesModalState extends State<FilterCategoriesModal> {
  late List<String> _selectedCategoryIds;

  @override
  void initState() {
    super.initState();
    _selectedCategoryIds = List.from(widget.selectedCategoryIds);
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
                  'Categoría',
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

          // Chips de categorías
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              // Opción "Todas"
              _buildCategoryChip(
                label: 'Todas',
                color: AppColors.primary,
                isSelected: _selectedCategoryIds.isEmpty,
                onTap: () {
                  setState(() {
                    _selectedCategoryIds.clear();
                  });
                },
              ),
              // Categorías
              ...widget.categories.map((category) {
                return _buildCategoryChip(
                  label: category.name,
                  color: category.color,
                  isSelected: _selectedCategoryIds.contains(category.id),
                  onTap: () {
                    setState(() {
                      if (_selectedCategoryIds.contains(category.id)) {
                        _selectedCategoryIds.remove(category.id);
                      } else {
                        _selectedCategoryIds.add(category.id);
                      }
                    });
                  },
                );
              }),
            ],
          ),

          const SizedBox(height: 24),

          // Botón aplicar
          CreateButton(
            buttonText: 'Aplicar filtro',
            onPressed: () {
              widget.onFilterChanged(_selectedCategoryIds);
              Get.back();
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  /// Chip de categoría con círculo de selección
  Widget _buildCategoryChip({
    required String label,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : AppColors.background,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Círculo de selección
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? color : AppColors.border,
                  width: 2,
                ),
                color: isSelected ? color : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            // Texto
            Text(
              label,
              style: AppTextStyles.bodyMedium(
                color: isSelected ? color : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
