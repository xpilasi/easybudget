import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/services/deep_link_service.dart';
import '../../../domain/entities/category.dart';
import '../common/buttons/create_button.dart';
import '../common/buttons/cancel_button.dart';
import '../common/custom_dropdown.dart';

/// Modal para importar una lista compartida
/// Se muestra cuando el usuario abre un deep link
class ImportListModal extends StatefulWidget {
  final SharedListData sharedList;
  final List<Category> categories;
  final Function({
    required String name,
    required String categoryId,
    required SharedListData sharedData,
  }) onImport;

  const ImportListModal({
    super.key,
    required this.sharedList,
    required this.categories,
    required this.onImport,
  });

  /// Mostrar el modal
  static Future<void> show({
    required SharedListData sharedList,
    required List<Category> categories,
    required Function({
      required String name,
      required String categoryId,
      required SharedListData sharedData,
    }) onImport,
  }) async {
    await Get.to(
      () => ImportListModal(
        sharedList: sharedList,
        categories: categories,
        onImport: onImport,
      ),
      fullscreenDialog: true,
      transition: Transition.downToUp,
    );
  }

  @override
  State<ImportListModal> createState() => _ImportListModalState();
}

class _ImportListModalState extends State<ImportListModal> {
  late String _listName;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _listName = widget.sharedList.name;

    // Intentar encontrar la categoría por nombre
    final matchingCategory = widget.categories.firstWhereOrNull(
      (cat) => cat.name.toLowerCase() == widget.sharedList.categoryName.toLowerCase(),
    );

    if (matchingCategory != null) {
      _selectedCategoryId = matchingCategory.id;
    } else if (widget.categories.isNotEmpty) {
      _selectedCategoryId = widget.categories.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Lista Compartida',
          style: AppTextStyles.h4(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mensaje de bienvenida
            _buildWelcomeMessage(),
            SizedBox(height: AppSpacing.lg),

            // Información de la lista
            _buildListInfo(),
            SizedBox(height: AppSpacing.lg),

            // Selector de categoría
            Text(
              'Selecciona una categoría',
              style: AppTextStyles.bodyMedium(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            _buildCategorySelector(),
            SizedBox(height: AppSpacing.xl),

            // Botones de acción
            _buildActions(),
          ],
        ),
      ),
    );
  }

  /// Mensaje de bienvenida
  Widget _buildWelcomeMessage() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.primary,
            size: 20,
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Han compartido una lista contigo. ¿Deseas agregarla a tus listas?',
              style: AppTextStyles.bodySmall(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Información de la lista
  Widget _buildListInfo() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre
          Row(
            children: [
              Icon(
                Icons.list_alt,
                size: 20,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  widget.sharedList.name,
                  style: AppTextStyles.bodyLarge(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),

          // Categoría original
          Row(
            children: [
              Icon(
                Icons.category_outlined,
                size: 18,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                'Categoría: ${widget.sharedList.categoryName}',
                style: AppTextStyles.bodySmall(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),

          Divider(color: AppColors.border),
          SizedBox(height: AppSpacing.sm),

          // Estadísticas
          Row(
            children: [
              _buildStat(
                icon: Icons.shopping_bag_outlined,
                label: '${widget.sharedList.totalProducts} productos',
              ),
              SizedBox(width: AppSpacing.lg),
              _buildStat(
                icon: Icons.inventory_2_outlined,
                label: '${widget.sharedList.totalItems} items',
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: AppTextStyles.bodyMedium(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${widget.sharedList.currency}${widget.sharedList.total.toStringAsFixed(2)}',
                style: AppTextStyles.h4(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Stat item
  Widget _buildStat({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTextStyles.bodySmall(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Selector de categoría
  Widget _buildCategorySelector() {
    if (widget.categories.isEmpty) {
      return Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
        ),
        child: Text(
          'No hay categorías disponibles',
          style: AppTextStyles.bodyMedium(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return CustomDropdown(
      value: _selectedCategoryId,
      items: widget.categories.map((category) {
        return DropdownMenuItem<String>(
          value: category.id,
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: category.color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Text(category.name),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategoryId = value;
        });
      },
      hint: 'Selecciona una categoría',
    );
  }

  /// Botones de acción
  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: CancelButton(
            buttonText: 'Cancelar',
            onPressed: () => Get.back(),
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          flex: 2,
          child: CreateButton(
            buttonText: 'Importar Lista',
            icon: Icons.download,
            iconSize: 20,
            onPressed: _selectedCategoryId != null ? _handleImport : null,
          ),
        ),
      ],
    );
  }

  /// Manejar importación
  void _handleImport() {
    if (_selectedCategoryId == null) return;

    widget.onImport(
      name: _listName,
      categoryId: _selectedCategoryId!,
      sharedData: widget.sharedList,
    );

    Get.back();
  }
}
