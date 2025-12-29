import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/config/app_constants.dart';
import '../../../domain/entities/category.dart';
import '../common/buttons/create_button.dart';
import '../common/buttons/cancel_button.dart';
import '../common/custom_text_field.dart';
import '../common/custom_dropdown.dart';

/// EditListModal - Modal para editar una lista existente
class EditListModal extends StatefulWidget {
  final String listId;
  final String currentName;
  final String currentCategoryId;
  final String currentCurrency;
  final List<Category> categories;
  final Function({
    required String listId,
    required String name,
    required String categoryId,
    required String currency,
  }) onUpdateList;

  const EditListModal({
    super.key,
    required this.listId,
    required this.currentName,
    required this.currentCategoryId,
    required this.currentCurrency,
    required this.categories,
    required this.onUpdateList,
  });

  /// Mostrar el modal
  static Future<void> show({
    required String listId,
    required String currentName,
    required String currentCategoryId,
    required String currentCurrency,
    required List<Category> categories,
    required Function({
      required String listId,
      required String name,
      required String categoryId,
      required String currency,
    }) onUpdateList,
  }) async {
    await Get.to(
      () => EditListModal(
        listId: listId,
        currentName: currentName,
        currentCategoryId: currentCategoryId,
        currentCurrency: currentCurrency,
        categories: categories,
        onUpdateList: onUpdateList,
      ),
      fullscreenDialog: true,
      transition: Transition.downToUp,
    );
  }

  @override
  State<EditListModal> createState() => _EditListModalState();
}

class _EditListModalState extends State<EditListModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  late String _selectedCategoryId;
  late String _selectedCurrency;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _selectedCategoryId = widget.currentCategoryId;
    _selectedCurrency = widget.currentCurrency;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      widget.onUpdateList(
        listId: widget.listId,
        name: _nameController.text.trim(),
        categoryId: _selectedCategoryId,
        currency: _selectedCurrency,
      );

      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo actualizar la lista',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
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
          'Editar lista',
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
                onSubmitted: (_) => _handleUpdate(),
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
                    _selectedCategoryId = value!;
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
                      onPressed: _isUpdating ? null : () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: CreateButton(
                      buttonText: 'Guardar',
                      onPressed: _isUpdating ? null : _handleUpdate,
                      isLoading: _isUpdating,
                      icon: Icons.save,
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
