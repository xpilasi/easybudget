import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/config/app_constants.dart';
import '../../../domain/entities/category.dart';
import '../common/buttons/create_button.dart';
import '../common/buttons/cancel_button.dart';
import '../common/custom_text_field.dart';
import '../common/custom_dropdown.dart';

/// CreateListModal - Modal para crear una nueva lista de compras
class CreateListModal extends StatefulWidget {
  final List<Category> categories;
  final Function({
    required String name,
    required String categoryId,
    required String currency,
  }) onCreateList;

  const CreateListModal({
    super.key,
    required this.categories,
    required this.onCreateList,
  });

  /// Mostrar el modal
  static Future<void> show({
    required List<Category> categories,
    required Function({
      required String name,
      required String categoryId,
      required String currency,
    }) onCreateList,
  }) async {
    await Get.to(
      () => CreateListModal(
        categories: categories,
        onCreateList: onCreateList,
      ),
      fullscreenDialog: true,
      transition: Transition.downToUp,
    );
  }

  @override
  State<CreateListModal> createState() => _CreateListModalState();
}

class _CreateListModalState extends State<CreateListModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  String? _selectedCategoryId;
  String _selectedCurrency = 'USD';
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    // Seleccionar la primera categoría por defecto
    if (widget.categories.isNotEmpty) {
      _selectedCategoryId = widget.categories.first.id;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) return;

    setState(() {
      _isCreating = true;
    });

    try {
      widget.onCreateList(
        name: _nameController.text.trim(),
        categoryId: _selectedCategoryId!,
        currency: _selectedCurrency,
      );

      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo crear la lista',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
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
          'Nueva lista',
          style: AppTextStyles.h4(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

            // Nombre de la lista
            CustomTextField(
              label: 'Nombre de la lista',
              hint: 'Ej: Compras semanales',
              controller: _nameController,
              prefixIcon: Icons.shopping_cart,
              maxLength: AppConstants.maxListNameLength,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _handleCreate(),
              validator: TextFieldValidators.combine([
                TextFieldValidators.required('El nombre'),
                TextFieldValidators.minLength(3, 'El nombre'),
                TextFieldValidators.maxLength(
                  AppConstants.maxListNameLength,
                  'El nombre',
                ),
              ]),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Categoría
            CustomDropdown<String>(
              label: 'Categoría',
              hint: 'Selecciona una categoría',
              value: _selectedCategoryId,
              prefixIcon: Icons.category,
              items: widget.categories
                  .map(
                    (category) => DropdownMenuItem(
                      value: category.id,
                      child: Row(
                        children: [
                          // Color indicator
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: category.color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            category.name,
                            style: AppTextStyles.bodyLarge(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategoryId = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Selecciona una categoría';
                }
                return null;
              },
            ),

            const SizedBox(height: AppSpacing.lg),

            // Moneda
            CustomDropdown<String>(
              label: 'Moneda',
              hint: 'Selecciona la moneda',
              value: _selectedCurrency,
              prefixIcon: Icons.attach_money,
              items: AppConstants.currencies
                  .map(
                    (currency) => DropdownMenuItem(
                      value: currency['code'],
                      child: Text(
                        '${currency['code']} - ${currency['name']}',
                        style: AppTextStyles.bodyLarge(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value ?? 'USD';
                });
              },
            ),

            const SizedBox(height: AppSpacing.xl),

            // Botones
            Row(
              children: [
                Expanded(
                  child: CancelButton(
                    buttonText: 'Cancelar',
                    onPressed: _isCreating ? null : () => Get.back(),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: CreateButton(
                    buttonText: 'Crear lista',
                    onPressed: _isCreating ? null : _handleCreate,
                    isLoading: _isCreating,
                    icon: Icons.add,
                    iconSize: 20,
                  ),
                ),
              ],
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
