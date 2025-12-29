/// Textos localizados de la aplicación (Español)
class AppStrings {
  AppStrings._(); // Constructor privado

  // ==================== GENERAL ====================

  static const String appName = 'ListShare';
  static const String ok = 'OK';
  static const String cancel = 'Cancelar';
  static const String save = 'Guardar';
  static const String delete = 'Eliminar';
  static const String edit = 'Editar';
  static const String create = 'Crear';
  static const String add = 'Agregar';
  static const String share = 'Compartir';
  static const String close = 'Cerrar';
  static const String done = 'Listo';
  static const String search = 'Buscar';

  // ==================== LOGIN ====================

  static const String welcome = 'Bienvenido';
  static const String loginTitle = 'Inicia sesión para continuar';
  static const String continueWithGoogle = 'Continuar con Google';
  static const String devModeNote =
      'Modo desarrollo - El login te llevará directamente a la app';
  static const String termsAcceptance =
      'Al continuar, aceptas nuestros términos y condiciones';

  // ==================== HOME ====================

  static const String helloAgain = 'Hola de nuevo,';
  static const String quickActions = 'Acciones rápidas';
  static const String createNewList = 'Crear nueva lista';
  static const String recentLists = 'Listas recientes';
  static const String activeLists = 'Listas activas';
  static const String totalSpent = 'Total gastado';

  // ==================== LISTS ====================

  static const String myLists = 'Mis Listas';
  static const String all = 'Todas';
  static const String noLists = 'No hay listas aquí';
  static const String createFirstList = 'Crea tu primera lista para comenzar';
  static const String products = 'productos';

  // ==================== LIST DETAIL ====================

  static const String noProducts = 'No hay productos en esta lista';
  static const String addFirstProduct = 'Agrega tu primer producto';
  static const String addProduct = 'Agregar producto';
  static const String total = 'Total';
  static const String deleteListConfirm =
      '¿Estás seguro de que deseas eliminar esta lista?';

  // ==================== CREATE LIST ====================

  static const String newList = 'Nueva lista';
  static const String listName = 'Nombre de la lista';
  static const String listNameHint = 'Ej: Compras semanales';
  static const String category = 'Categoría';
  static const String currency = 'Moneda';

  // ==================== ADD PRODUCT ====================

  static const String newProduct = 'Nuevo producto';
  static const String productName = 'Nombre del producto';
  static const String productNameHint = 'Ej: Leche';
  static const String price = 'Precio';
  static const String quantity = 'Cantidad';
  static const String subtotal = 'Subtotal';

  // ==================== CATEGORIES ====================

  static const String manageCategories = 'Gestionar categorías';
  static const String newCategory = 'Nueva categoría';
  static const String categoryName = 'Nombre de la categoría';
  static const String saveChanges = 'Guardar cambios';
  static const String deleteCategoryConfirm =
      '¿Estás seguro de que deseas eliminar esta categoría?';
  static const String minCategoriesWarning =
      'Debes tener al menos una categoría';

  // ==================== SHARE ====================

  static const String shareList = 'Compartir lista';
  static const String shareWith = 'Comparte con otros usuarios';
  static const String copyLink = 'Copiar enlace';
  static const String copyToClipboard = 'Copiar al portapapeles';
  static const String linkCopied = '¡Enlace copiado al portapapeles!';
  static const String shareNote =
      'Los usuarios con el enlace podrán ver y guardar la lista';

  // ==================== PROFILE ====================

  static const String profile = 'Perfil';
  static const String fullName = 'Nombre completo';
  static const String email = 'Correo electrónico';
  static const String settings = 'Configuración';
  static const String darkMode = 'Modo oscuro';
  static const String lightMode = 'Modo claro';
  static const String appTheme = 'Tema de la aplicación';
  static const String about = 'Acerca de';
  static const String appVersion = 'Versión de la app';
  static const String termsAndConditions = 'Términos y condiciones';
  static const String privacyPolicy = 'Política de privacidad';
  static const String logout = 'Cerrar sesión';

  // ==================== NAVIGATION ====================

  static const String navHome = 'Inicio';
  static const String navLists = 'Listas';
  static const String navProfile = 'Perfil';

  // ==================== ERRORS ====================

  static const String errorGeneric = 'Ocurrió un error inesperado';
  static const String errorNetwork = 'Error de conexión';
  static const String errorLoadingData = 'No se pudieron cargar los datos';
  static const String errorSavingData = 'No se pudo guardar la información';
}
