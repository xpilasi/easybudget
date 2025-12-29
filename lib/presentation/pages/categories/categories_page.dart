import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_theme.dart';
import '../../controllers/lists_controller.dart';
import '../../widgets/modals/manage_categories_modal.dart';

/// Categories Screen - Pantalla de gestión de categorías
class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  bool _modalShown = false;

  @override
  Widget build(BuildContext context) {
    if (!_modalShown) {
      _modalShown = true;
      // Mostrar directamente el modal de gestión de categorías
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final controller = Get.find<ListsController>();

        ManageCategoriesModal.show(
          categories: controller.categories,
          onCreateCategory: ({required name, required color}) {
            controller.createCategory(name: name, color: color);
          },
          onUpdateCategory: ({required categoryId, required name, required color}) {
            controller.updateCategory(id: categoryId, name: name, color: color);
          },
          onDeleteCategory: (categoryId) {
            controller.deleteCategory(categoryId);
          },
        ).then((_) {
          // Cuando se cierra el modal, volver atrás
          if (mounted) {
            Get.back();
          }
        });
      });
    }

    return Scaffold(
      backgroundColor: context.background,
      body: Center(
        child: CircularProgressIndicator(color: context.primary),
      ),
    );
  }
}
