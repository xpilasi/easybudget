import '../../app/theme/app_colors.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/shopping_list_model.dart';
import '../models/user_model.dart';

/// Provider de datos mock para desarrollo y testing
/// Proporciona datos iniciales de ejemplo
class MockDataProvider {
  MockDataProvider._(); // Constructor privado

  // ==================== USER MOCK ====================

  static UserModel getMockUser() {
    return const UserModel(
      id: '1',
      email: 'usuario@ejemplo.com',
      firstName: 'Juan',
      lastName: 'Pérez',
      photoUrl:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop',
    );
  }

  // ==================== CATEGORIES MOCK ====================

  static List<CategoryModel> getMockCategories() {
    final colors = AppColors.categoryColors;
    return [
      CategoryModel(
        id: '1',
        name: 'Supermercado',
        colorHex: _colorToHex(colors[0]),
      ),
      CategoryModel(
        id: '2',
        name: 'Navidad',
        colorHex: _colorToHex(colors[1]),
      ),
      CategoryModel(
        id: '3',
        name: 'Cumpleaños',
        colorHex: _colorToHex(colors[2]),
      ),
      CategoryModel(
        id: '4',
        name: 'Viajes',
        colorHex: _colorToHex(colors[3]),
      ),
    ];
  }

  // ==================== SHOPPING LISTS MOCK ====================

  static List<ShoppingListModel> getMockLists() {
    return [
      ShoppingListModel(
        id: '1',
        name: 'Compras semanales',
        categoryId: '1',
        currency: 'USD',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        products: [
          const ProductModel(
            id: '1',
            name: 'Leche',
            price: 3.5,
            quantity: 2,
          ),
          const ProductModel(
            id: '2',
            name: 'Pan',
            price: 2.0,
            quantity: 3,
          ),
          const ProductModel(
            id: '3',
            name: 'Huevos',
            price: 4.5,
            quantity: 1,
          ),
        ],
      ),
      ShoppingListModel(
        id: '2',
        name: 'Regalos familia',
        categoryId: '2',
        currency: 'EUR',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        products: [
          const ProductModel(
            id: '4',
            name: 'Juguete para niños',
            price: 25.0,
            quantity: 2,
          ),
          const ProductModel(
            id: '5',
            name: 'Libro',
            price: 15.0,
            quantity: 1,
          ),
        ],
      ),
      ShoppingListModel(
        id: '3',
        name: 'Fiesta María',
        categoryId: '3',
        currency: 'USD',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        products: [
          const ProductModel(
            id: '6',
            name: 'Decoraciones',
            price: 30.0,
            quantity: 1,
          ),
          const ProductModel(
            id: '7',
            name: 'Pastel',
            price: 45.0,
            quantity: 1,
          ),
        ],
      ),
    ];
  }

  // ==================== HELPERS ====================

  /// Convertir Color a formato hexadecimal
  static String _colorToHex(dynamic color) {
    final argb = color.toARGB32();
    final hexValue = argb.toRadixString(16).padLeft(8, '0');
    return '#${hexValue.substring(2)}';
  }
}
