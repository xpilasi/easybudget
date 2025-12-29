import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_theme.dart';
import '../../../domain/entities/category.dart';
import '../common/buttons/create_button.dart';
import '../common/buttons/cancel_button.dart';
import '../common/custom_text_field.dart';

/// Modal para gestionar categorías (crear, editar, eliminar)
class ManageCategoriesModal extends StatefulWidget {
  final List<Category> categories;
  final Function({
    required String name,
    required Color color,
  }) onCreateCategory;
  final Function({
    required String categoryId,
    required String name,
    required Color color,
  }) onUpdateCategory;
  final Function(String categoryId) onDeleteCategory;

  const ManageCategoriesModal({
    super.key,
    required this.categories,
    required this.onCreateCategory,
    required this.onUpdateCategory,
    required this.onDeleteCategory,
  });

  /// Mostrar el modal
  static Future<void> show({
    required List<Category> categories,
    required Function({
      required String name,
      required Color color,
    }) onCreateCategory,
    required Function({
      required String categoryId,
      required String name,
      required Color color,
    }) onUpdateCategory,
    required Function(String categoryId) onDeleteCategory,
  }) async {
    await Get.to(
      () => ManageCategoriesModal(
        categories: categories,
        onCreateCategory: onCreateCategory,
        onUpdateCategory: onUpdateCategory,
        onDeleteCategory: onDeleteCategory,
      ),
      fullscreenDialog: true,
      transition: Transition.downToUp,
    );
  }

  @override
  State<ManageCategoriesModal> createState() => _ManageCategoriesModalState();
}

class _ManageCategoriesModalState extends State<ManageCategoriesModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  bool _isAddingNew = false;
  String? _editingCategoryId;
  Color _selectedColor = AppColors.primary;

  // Colores predefinidos para selección
  final List<Color> _predefinedColors = [
    const Color(0xFF6366F1), // Indigo
    const Color(0xFFEC4899), // Pink
    const Color(0xFF10B981), // Green
    const Color(0xFFF59E0B), // Amber
    const Color(0xFFEF4444), // Red
    const Color(0xFF8B5CF6), // Purple
    const Color(0xFF3B82F6), // Blue
    const Color(0xFF14B8A6), // Teal
    const Color(0xFFF97316), // Orange
    const Color(0xFF06B6D4), // Cyan
    const Color(0xFFA855F7), // Violet
    const Color(0xFF84CC16), // Lime
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
          'Gestionar categorías',
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
            // Lista de categorías existentes
            if (widget.categories.isNotEmpty) ...[
              Text(
                'Categorías',
                style: AppTextStyles.bodyLarge(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSpacing.md),
              _buildCategoriesList(),
              SizedBox(height: AppSpacing.lg),
            ],

            // Formulario para agregar/editar
            if (_isAddingNew || _editingCategoryId != null) ...[
              _buildForm(),
            ] else ...[
              // Botón para agregar nueva categoría
              _buildAddButton(),
            ],
          ],
        ),
      ),
    );
  }

  /// Lista de categorías
  Widget _buildCategoriesList() {
    return Column(
      children: widget.categories.map((category) {
        final isEditing = _editingCategoryId == category.id;

        if (isEditing) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.sm),
          child: _buildCategoryCard(category),
        );
      }).toList(),
    );
  }

  /// Tarjeta de categoría
  Widget _buildCategoryCard(Category category) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Color indicator
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: category.color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          // Name
          Expanded(
            child: Text(
              category.name,
              style: AppTextStyles.bodyMedium(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Actions
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            color: AppColors.textSecondary,
            onPressed: () => _startEditing(category),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          SizedBox(width: AppSpacing.xs),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            color: AppColors.error,
            onPressed: () => _confirmDelete(category),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  /// Formulario para agregar/editar categoría
  Widget _buildForm() {
    final isEditing = _editingCategoryId != null;

    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título del formulario
            Text(
              isEditing ? 'Editar Categoría' : 'Nueva Categoría',
              style: AppTextStyles.bodyLarge(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSpacing.md),

            // Campo de nombre
            CustomTextField(
              label: 'Nombre',
              controller: _nameController,
              validator: TextFieldValidators.required('Nombre'),
            ),
            SizedBox(height: AppSpacing.md),

            // Selector de color
            Text(
              'Color',
              style: AppTextStyles.bodyMedium(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            _buildColorPicker(),
            SizedBox(height: AppSpacing.lg),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: CancelButton(
                    buttonText: 'Cancelar',
                    onPressed: _cancelForm,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: CreateButton(
                    buttonText: isEditing ? 'Actualizar' : 'Agregar',
                    onPressed: _submitForm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Selector de color
  Widget _buildColorPicker() {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: _predefinedColors.map((color) {
        final isSelected = _selectedColor == color;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedColor = color;
            });
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.textPrimary : Colors.transparent,
                width: 3,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 24,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }

  /// Botón para agregar nueva categoría
  Widget _buildAddButton() {
    return CreateButton(
      buttonText: 'Agregar Nueva Categoría',
      onPressed: _startAdding,
      icon: Icons.add,
      iconSize: 20,
    );
  }

  // ==================== ACTIONS ====================

  /// Iniciar modo de agregar
  void _startAdding() {
    setState(() {
      _isAddingNew = true;
      _editingCategoryId = null;
      _nameController.clear();
      _selectedColor = _predefinedColors.first;
    });
  }

  /// Iniciar modo de edición
  void _startEditing(Category category) {
    setState(() {
      _isAddingNew = false;
      _editingCategoryId = category.id;
      _nameController.text = category.name;
      _selectedColor = category.color;
    });
  }

  /// Cancelar formulario
  void _cancelForm() {
    setState(() {
      _isAddingNew = false;
      _editingCategoryId = null;
      _nameController.clear();
      _selectedColor = _predefinedColors.first;
    });
  }

  /// Enviar formulario
  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();

    if (_editingCategoryId != null) {
      // Actualizar categoría existente (nombre y color)
      widget.onUpdateCategory(
        categoryId: _editingCategoryId!,
        name: name,
        color: _selectedColor,
      );
    } else {
      // Crear nueva categoría (nombre y color)
      widget.onCreateCategory(
        name: name,
        color: _selectedColor,
      );
    }

    _cancelForm();
  }

  /// Confirmar eliminación
  void _confirmDelete(Category category) {
    Get.dialog(
      AlertDialog(
        title: const Text('Eliminar Categoría'),
        content: Text(
          '¿Estás seguro de que quieres eliminar la categoría "${category.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              widget.onDeleteCategory(category.id);
            },
            child: Text(
              'Eliminar',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
