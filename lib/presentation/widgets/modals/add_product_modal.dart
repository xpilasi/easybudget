import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/config/app_constants.dart';
import '../common/common_widgets.dart';
import '../common/buttons/create_button.dart';
import '../common/buttons/cancel_button.dart';

/// AddProductModal - Modal para agregar un nuevo producto a una lista
class AddProductModal extends StatefulWidget {
  final String currency;
  final Function({
    required String name,
    required double price,
    required int quantity,
  }) onAddProduct;

  const AddProductModal({
    super.key,
    required this.currency,
    required this.onAddProduct,
  });

  /// Mostrar el modal
  static Future<void> show({
    required String currency,
    required Function({
      required String name,
      required double price,
      required int quantity,
    }) onAddProduct,
  }) async {
    await Get.to(
      () => AddProductModal(
        currency: currency,
        onAddProduct: onAddProduct,
      ),
      fullscreenDialog: true,
      transition: Transition.downToUp,
    );
  }

  @override
  State<AddProductModal> createState() => _AddProductModalState();
}

class _AddProductModalState extends State<AddProductModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');

  bool _isAdding = false;
  double _subtotal = 0.0;

  @override
  void initState() {
    super.initState();
    _priceController.addListener(_updateSubtotal);
    _quantityController.addListener(_updateSubtotal);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _updateSubtotal() {
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final quantity = int.tryParse(_quantityController.text) ?? 0;

    setState(() {
      _subtotal = price * quantity;
    });
  }

  Future<void> _handleAdd() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isAdding = true;
    });

    try {
      final price = double.parse(_priceController.text);
      final quantity = int.parse(_quantityController.text);

      widget.onAddProduct(
        name: _nameController.text.trim(),
        price: price,
        quantity: quantity,
      );

      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo agregar el producto',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAdding = false;
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
          'Nuevo producto',
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

            // Nombre del producto
            CustomTextField(
              label: 'Nombre del producto',
              hint: 'Ej: Leche',
              controller: _nameController,
              prefixIcon: Icons.shopping_bag,
              maxLength: AppConstants.maxProductNameLength,
              autofocus: true,
              textInputAction: TextInputAction.next,
              validator: TextFieldValidators.combine([
                TextFieldValidators.required('El nombre'),
                TextFieldValidators.minLength(2, 'El nombre'),
                TextFieldValidators.maxLength(
                  AppConstants.maxProductNameLength,
                  'El nombre',
                ),
              ]),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Precio y Cantidad
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Precio
                Expanded(
                  child: CustomTextField(
                    label: 'Precio (${widget.currency})',
                    hint: '0.00',
                    controller: _priceController,
                    type: TextFieldType.decimal,
                    prefixIcon: Icons.attach_money,
                    textInputAction: TextInputAction.next,
                    validator: TextFieldValidators.combine([
                      TextFieldValidators.required('El precio'),
                      TextFieldValidators.positiveNumber(),
                    ]),
                  ),
                ),

                const SizedBox(width: AppSpacing.md),

                // Cantidad
                Expanded(
                  child: CustomTextField(
                    label: 'Cantidad',
                    hint: '1',
                    controller: _quantityController,
                    type: TextFieldType.number,
                    prefixIcon: Icons.numbers,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleAdd(),
                    validator: TextFieldValidators.combine([
                      TextFieldValidators.required('La cantidad'),
                      TextFieldValidators.integerNumber(),
                      TextFieldValidators.positiveNumber(),
                      TextFieldValidators.maxValue(
                        AppConstants.maxProductQuantity,
                        'La cantidad',
                      ),
                    ]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Preview del subtotal
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: AppDecorations.radiusMD,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal',
                    style: AppTextStyles.bodyLarge(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${widget.currency} ${_subtotal.toStringAsFixed(2)}',
                    style: AppTextStyles.h4(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Botones
            Row(
              children: [
             

               Expanded(
                child:
                CancelButton(buttonText: 'Cancelar', onPressed:()=>Get.back() ) ),

                const SizedBox(width: AppSpacing.md),
                
                Expanded(
                  child: 
                  CreateButton(
                    onPressed:  _handleAdd,
                    buttonText: 'Agregar', 
                    
                    ),)
               
                
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


