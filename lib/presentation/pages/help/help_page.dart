import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_theme.dart';

/// Help Screen - Pantalla de ayuda y preguntas frecuentes
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        title: Text(
          'Ayuda',
          style: AppTextStyles.h3(
            color: context.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: context.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: context.textPrimary,
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner de ayuda
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.primary,
                    context.primary.withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.help_outline,
                    size: 64,
                    color: Colors.white,
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    '¿En qué podemos ayudarte?',
                    style: AppTextStyles.h3(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'Encuentra respuestas a las preguntas más frecuentes',
                    style: AppTextStyles.bodyMedium(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            // Preguntas frecuentes
            Text(
              'Preguntas Frecuentes',
              style: AppTextStyles.h4(
                color: context.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: AppSpacing.md),

            _buildFAQItem(
              context: context,
              question: '¿Cómo creo una nueva lista?',
              answer: 'Ve a la pestaña "Listas" y presiona el botón "+" en la parte inferior. Ingresa el nombre de la lista, selecciona una categoría y elige la moneda.',
            ),

            _buildFAQItem(
              context: context,
              question: '¿Cómo agrego productos a una lista?',
              answer: 'Abre la lista y presiona el botón "+" flotante. Ingresa el nombre del producto, precio y cantidad. El subtotal se calculará automáticamente.',
            ),

            _buildFAQItem(
              context: context,
              question: '¿Cómo comparto una lista?',
              answer: 'Dentro de una lista, presiona el ícono de compartir en la parte superior. Podrás compartir un enlace que otros pueden usar para importar tu lista.',
            ),

            _buildFAQItem(
              context: context,
              question: '¿Cómo gestiono las categorías?',
              answer: 'Ve a Perfil > Categorías. Desde ahí puedes crear, editar y eliminar categorías con sus respectivos colores.',
            ),

            _buildFAQItem(
              context: context,
              question: '¿Cómo filtro y ordeno mis productos?',
              answer: 'En el detalle de una lista, usa el ícono de filtro en la parte superior para ordenar por nombre, precio o cantidad, y filtrar por productos pendientes.',
            ),

            _buildFAQItem(
              context: context,
              question: '¿Puedo cambiar la moneda de una lista?',
              answer: 'Sí, abre la lista y presiona el menú (⋮), luego "Editar lista". Podrás cambiar el nombre, categoría y moneda.',
            ),

            SizedBox(height: AppSpacing.xxl),

            // Contacto
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                boxShadow: [
                  BoxShadow(
                    color: context.shadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.email_outlined,
                    size: 48,
                    color: context.primary,
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    '¿Necesitas más ayuda?',
                    style: AppTextStyles.bodyLarge(
                      color: context.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'Contáctanos y te ayudaremos',
                    style: AppTextStyles.bodySmall(
                      color: context.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpacing.md),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.snackbar(
                        'Contacto',
                        'Pronto podrás contactarnos directamente',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    icon: const Icon(Icons.send),
                    label: const Text('Enviar mensaje'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({
    required BuildContext context,
    required String question,
    required String answer,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      elevation: 0,
      color: context.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        side: BorderSide(
          color: context.border,
          width: 1,
        ),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        childrenPadding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.md,
        ),
        title: Text(
          question,
          style: AppTextStyles.bodyMedium(
            color: context.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconColor: context.primary,
        collapsedIconColor: context.textSecondary,
        children: [
          Text(
            answer,
            style: AppTextStyles.bodySmall(
              color: context.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
