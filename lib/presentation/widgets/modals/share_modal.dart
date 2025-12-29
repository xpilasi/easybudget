import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/services/deep_link_service.dart';
import '../../../domain/entities/shopping_list.dart';
import '../common/buttons/create_button.dart';
import '../common/buttons/cancel_button.dart';

/// Modal para compartir una lista de compras
/// Permite compartir como texto o copiar al portapapeles
class ShareModal extends StatelessWidget {
  final ShoppingList shoppingList;
  final String categoryName;

  const ShareModal({
    super.key,
    required this.shoppingList,
    required this.categoryName,
  });

  /// Mostrar el modal
  static Future<void> show({
    required ShoppingList shoppingList,
    required String categoryName,
  }) async {
    await Get.to(
      () => ShareModal(
        shoppingList: shoppingList,
        categoryName: categoryName,
      ),
      fullscreenDialog: true,
      transition: Transition.downToUp,
    );
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
          'Compartir Lista',
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
            // Previsualización
            Text(
              'Previsualización',
              style: AppTextStyles.bodyLarge(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            _buildPreview(),
            SizedBox(height: AppSpacing.xl),

            // Opciones de compartir
            Text(
              'Opciones',
              style: AppTextStyles.bodyLarge(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            _buildShareOptions(),
          ],
        ),
      ),
    );
  }

  /// Previsualización del contenido a compartir
  Widget _buildPreview() {
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
          // Nombre de la lista y categoría
          Text(
            shoppingList.name,
            style: AppTextStyles.bodyLarge(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            'Categoría: $categoryName',
            style: AppTextStyles.bodySmall(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Divider(color: AppColors.border),
          SizedBox(height: AppSpacing.sm),

          // Productos
          if (shoppingList.products.isEmpty)
            Text(
              'Sin productos',
              style: AppTextStyles.bodyMedium(
                color: AppColors.textSecondary,
              ),
            )
          else
            ...shoppingList.products.asMap().entries.map((entry) {
              final index = entry.key;
              final product = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.xs),
                child: Text(
                  '${index + 1}. ${product.name} - ${product.quantity}x ${shoppingList.currency}${product.price.toStringAsFixed(2)} = ${shoppingList.currency}${product.subtotal.toStringAsFixed(2)}',
                  style: AppTextStyles.bodySmall(
                    color: AppColors.textPrimary,
                  ),
                ),
              );
            }),

          SizedBox(height: AppSpacing.sm),
          Divider(color: AppColors.border),
          SizedBox(height: AppSpacing.sm),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL:',
                style: AppTextStyles.bodyLarge(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${shoppingList.currency}${shoppingList.total.toStringAsFixed(2)}',
                style: AppTextStyles.bodyLarge(
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

  /// Opciones de compartir
  Widget _buildShareOptions() {
    return Column(
      children: [
        // Compartir por WhatsApp
        CreateButton(
          buttonText: 'Compartir por WhatsApp',
          icon: FontAwesomeIcons.whatsapp,
          iconSize: 20,
          onPressed: _shareViaWhatsApp,
        ),
        SizedBox(height: AppSpacing.md),

        // Compartir como texto
        CreateButton(
          buttonText: 'Compartir como Texto',
          icon: Icons.share,
          iconSize: 20,
          onPressed: _shareAsText,
        ),
        SizedBox(height: AppSpacing.md),

        // Copiar al portapapeles
        CancelButton(
          buttonText: 'Copiar al Portapapeles',
          icon: Icons.copy,
          iconSize: 20,
          onPressed: _copyToClipboard,
        ),
      ],
    );
  }

  // ==================== ACTIONS ====================

  /// Generar texto formateado de la lista
  String _generateShareText() {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('🛒 ${shoppingList.name}');
    buffer.writeln('📁 Categoría: $categoryName');
    buffer.writeln('');

    // Productos
    if (shoppingList.products.isEmpty) {
      buffer.writeln('Sin productos');
    } else {
      buffer.writeln('Productos:');
      for (var i = 0; i < shoppingList.products.length; i++) {
        final product = shoppingList.products[i];
        buffer.writeln(
          '${i + 1}. ${product.name}',
        );
        buffer.writeln(
          '   ${product.quantity} × ${shoppingList.currency}${product.price.toStringAsFixed(2)} = ${shoppingList.currency}${product.subtotal.toStringAsFixed(2)}',
        );
      }
    }

    buffer.writeln('');
    buffer.writeln('─────────────────────');
    buffer.writeln(
      'TOTAL: ${shoppingList.currency}${shoppingList.total.toStringAsFixed(2)}',
    );
    buffer.writeln('');

    // Stats
    buffer.writeln('📊 Resumen:');
    buffer.writeln('• ${shoppingList.totalProducts} productos');
    buffer.writeln('• ${shoppingList.totalItems} items totales');

    return buffer.toString();
  }

  /// Compartir por WhatsApp con deep link
  Future<void> _shareViaWhatsApp() async {
    try {
      final deepLinkService = Get.find<DeepLinkService>();
      final whatsappUrl = deepLinkService.generateWhatsAppUrl(
        shoppingList,
        categoryName,
      );

      // Validar longitud de URL (límite seguro: 2000 caracteres)
      if (whatsappUrl.length > 2000) {
        Get.dialog(
          AlertDialog(
            title: Text(
              'Lista muy grande',
              style: AppTextStyles.h4(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Esta lista tiene demasiados productos para compartir por WhatsApp.\n\nUsa "Compartir como Texto" en su lugar.',
              style: AppTextStyles.bodyMedium(
                color: AppColors.textSecondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Entendido'),
              ),
            ],
          ),
        );
        return;
      }

      final uri = Uri.parse(whatsappUrl);

      // Agregar timeout a canLaunchUrl para evitar congelamientos
      final canLaunch = await canLaunchUrl(uri).timeout(
        const Duration(seconds: 3),
        onTimeout: () => false,
      );

      if (canLaunch) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'No se pudo abrir WhatsApp. Verifica que esté instalado.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error.withValues(alpha: 0.1),
          colorText: AppColors.error,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo compartir por WhatsApp. Usa "Compartir como Texto".',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error.withValues(alpha: 0.1),
        colorText: AppColors.error,
      );
    }
  }

  /// Compartir como texto usando share_plus
  void _shareAsText() {
    final text = _generateShareText();
    Share.share(
      text,
      subject: shoppingList.name,
    );
  }

  /// Copiar al portapapeles
  void _copyToClipboard() {
    final text = _generateShareText();
    Clipboard.setData(ClipboardData(text: text));

    Get.back();
    Get.snackbar(
      'Copiado',
      'Lista copiada al portapapeles',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      icon: Icon(
        Icons.check_circle_outline,
        color: AppColors.success,
      ),
    );
  }
}
