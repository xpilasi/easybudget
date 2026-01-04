import 'dart:async';
import 'dart:convert';
import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../domain/entities/shopping_list.dart';

/// Servicio para manejar deep links
/// Genera y procesa enlaces para compartir listas
class DeepLinkService extends GetxService {
  final _appLinks = AppLinks();
  final _dio = Dio();
  StreamSubscription<Uri>? _linkSubscription;
  late FirebaseDatabase _database;

  // Callback cuando se recibe un deep link con datos de lista
  Function(SharedListData)? onListReceived;

  // Configuración
  static const String apiBaseUrl = 'https://easybudget.xpilasi.com';
  static const String firebaseDatabaseUrl = 'https://easybudget-b4109-default-rtdb.europe-west1.firebasedatabase.app/';
  static const bool useFirebase = true;

  // Esquema de deep link (fallback)
  static const String scheme = 'easybudget';
  static const String host = 'share';

  @override
  void onInit() {
    super.onInit();
    _initDeepLinks();
    _initFirebase();
  }

  void _initFirebase() {
    _database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: firebaseDatabaseUrl,
    );
    print('🔥 Firebase Database inicializado');
  }

  @override
  void onClose() {
    _linkSubscription?.cancel();
    super.onClose();
  }

  /// Inicializar listeners de deep links
  void _initDeepLinks() {
    // Listener para cuando la app está abierta
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        _handleDeepLink(uri);
      },
      onError: (err) {
        print('Error en deep link: $err');
      },
    );

    // Verificar si la app se abrió con un deep link
    _checkInitialLink();
  }

  /// Verificar si hay un deep link inicial
  Future<void> _checkInitialLink() async {
    try {
      print('🔗 DeepLinkService: Verificando deep link inicial...');
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        print('🔗 DeepLinkService: Deep link inicial encontrado: $uri');
        _handleDeepLink(uri);
      } else {
        print('🔗 DeepLinkService: No hay deep link inicial');
      }
    } catch (e) {
      print('❌ Error al obtener deep link inicial: $e');
    }
  }

  /// Manejar deep link
  void _handleDeepLink(Uri uri) {
    print('📱 Deep link recibido: $uri');

    // Verificar si es HTTPS (App Links) o custom scheme (fallback)
    if (uri.scheme == 'https' && uri.host == 'easybudget.xpilasi.com') {
      _handleHttpsDeepLink(uri);
    } else if (uri.scheme == scheme && uri.host == host) {
      _handleCustomSchemeDeepLink(uri);
    } else {
      print('Deep link no reconocido: $uri');
    }
  }

  /// Manejar deep link HTTPS (App Links)
  Future<void> _handleHttpsDeepLink(Uri uri) async {
    print('🌐 _handleHttpsDeepLink: procesando $uri');
    // Extraer ID de la URL: https://easybudget.xpilasi.com/share/abc123
    final pathSegments = uri.pathSegments;
    print('🌐 pathSegments: $pathSegments');

    if (pathSegments.length != 2 || pathSegments[0] != 'share') {
      print('❌ URL mal formada: $uri');
      print('   - length: ${pathSegments.length}, esperado: 2');
      print('   - pathSegments[0]: ${pathSegments.isNotEmpty ? pathSegments[0] : "vacío"}, esperado: share');
      return;
    }

    final shareId = pathSegments[1];
    print('🔍 Obteniendo lista compartida de Firebase: $shareId');

    try {
      SharedListData listData;

      // Si Firebase está configurado, obtener de Firebase
      if (useFirebase) {
        listData = await _fetchFirebaseSharedList(shareId);
      } else {
        // Fallback: obtener desde API de Netlify (si existe)
        listData = await fetchSharedList(shareId);
      }

      // Notificar a través del callback
      print('📦 Datos de lista obtenidos correctamente');
      if (onListReceived != null) {
        print('✅ Llamando callback onListReceived...');
        onListReceived!(listData);
        print('✅ Callback ejecutado correctamente');
      } else {
        print('❌ CRÍTICO: No hay callback registrado para onListReceived!');
      }
    } catch (e) {
      print('❌ Error al obtener lista compartida: $e');
      Get.snackbar(
        'Error',
        'No se pudo importar la lista. Puede que haya expirado.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Manejar deep link custom scheme (fallback)
  Future<void> _handleCustomSchemeDeepLink(Uri uri) async {
    print('🔗 _handleCustomSchemeDeepLink: procesando $uri');
    print('🔗 pathSegments: ${uri.pathSegments}');
    print('🔗 queryParameters: ${uri.queryParameters}');

    // Opción 1: Viene con ID en el path (easybudget://share/ID)
    if (uri.pathSegments.isNotEmpty && uri.pathSegments.length >= 1) {
      final shareId = uri.pathSegments.last;
      if (shareId.isNotEmpty && shareId != 'share') {
        print('🔗 Formato con ID detectado: $shareId');
        // Usar la misma lógica que HTTPS para obtener de Firebase
        await _handleHttpsDeepLink(Uri.parse('https://easybudget.xpilasi.com/share/$shareId'));
        return;
      }
    }

    // Opción 2: Viene con datos codificados (easybudget://share?data=...)
    final listDataParam = uri.queryParameters['data'];
    if (listDataParam == null) {
      print('❌ Deep link sin datos de lista ni ID válido');
      return;
    }

    try {
      print('🔗 Formato con datos codificados detectado');
      // Decodificar datos
      final listData = _decodeListData(listDataParam);

      // Notificar a través del callback
      print('📦 Datos decodificados correctamente');
      if (onListReceived != null) {
        print('✅ Llamando callback onListReceived...');
        onListReceived!(listData);
      } else {
        print('❌ CRÍTICO: No hay callback registrado!');
      }
    } catch (e) {
      print('❌ Error al decodificar datos de lista: $e');
      Get.snackbar(
        'Error',
        'No se pudo importar la lista',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Guardar lista y generar deep link
  Future<String> generateShareLink(ShoppingList list, String categoryName) async {
    final listData = SharedListData(
      name: list.name,
      categoryName: categoryName,
      currency: list.currency,
      products: list.products.map((p) => SharedProductData(
        name: p.name,
        price: p.price,
        quantity: p.quantity,
      )).toList(),
    );

    // Si Firebase está configurado, usar Firebase
    if (useFirebase) {
      return await _generateFirebaseShareLink(listData);
    }

    // Fallback: usar custom scheme
    final encodedData = _encodeListData(listData);
    final customSchemeUrl = '$scheme://$host?data=$encodedData';
    print('📱 Generando deep link con custom scheme');
    print('🔗 URL: $customSchemeUrl');
    return customSchemeUrl;

    /* DESACTIVADO TEMPORALMENTE - API Backend
    try {
      final url = '$apiBaseUrl/.netlify/functions/share';
      final jsonData = listData.toJson();

      print('🌐 POST $url');
      print('📤 Request body: ${jsonEncode(jsonData)}');

      final response = await _dio.post(
        url,
        data: jsonData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        final shareUrl = data['url'] as String;
        print('✅ Share URL generada: $shareUrl');
        return shareUrl;
      } else {
        print('❌ Error del servidor: ${response.statusCode}');
        print('❌ Response data: ${response.data}');
        throw Exception('Error al guardar lista: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en generateShareLink: $e');
      if (e is DioException) {
        print('❌ DioException type: ${e.type}');
        print('❌ DioException message: ${e.message}');
        print('❌ DioException response: ${e.response?.data}');
      }
      // Fallback a custom scheme si falla el API
      final encodedData = _encodeListData(listData);
      final fallbackUrl = '$scheme://$host?data=$encodedData';
      print('🔄 Usando fallback URL: $fallbackUrl');
      return fallbackUrl;
    }
    */
  }

  /// Obtener lista compartida desde el servidor
  Future<SharedListData> fetchSharedList(String shareId) async {
    final response = await _dio.get(
      '$apiBaseUrl/share/$shareId',
      options: Options(
        validateStatus: (status) => status! < 500,
      ),
    );

    if (response.statusCode == 200) {
      return SharedListData.fromJson(response.data);
    } else if (response.statusCode == 404) {
      throw Exception('Lista no encontrada o expirada');
    } else {
      throw Exception('Error al obtener lista: ${response.statusCode}');
    }
  }

  /// Generar texto para compartir por WhatsApp (optimizado)
  Future<String> generateWhatsAppMessage(ShoppingList list, String categoryName) async {
    final deepLink = await generateShareLink(list, categoryName);

    final message = StringBuffer();
    message.write('🛒 *${list.name}* | ');
    message.write('${list.currency}${list.total.toStringAsFixed(2)} | ');
    message.writeln('${list.totalProducts} productos');
    message.writeln('');
    message.write('✨ Abrir en EasyBudget: ');
    message.write(deepLink);

    return message.toString();
  }

  /// Generar URL de WhatsApp con el mensaje
  Future<String> generateWhatsAppUrl(ShoppingList list, String categoryName) async {
    final message = await generateWhatsAppMessage(list, categoryName);
    final encodedMessage = Uri.encodeComponent(message);
    // Usar esquema nativo de WhatsApp para Android
    return 'whatsapp://send?text=$encodedMessage';
  }

  /// Codificar datos de lista a string (para custom scheme fallback)
  String _encodeListData(SharedListData data) {
    final json = data.toCompactJson(); // Usar formato compacto para URLs
    final jsonString = jsonEncode(json);
    final bytes = utf8.encode(jsonString);
    final base64String = base64Url.encode(bytes);
    return base64String;
  }

  /// Decodificar string a datos de lista
  SharedListData _decodeListData(String encoded) {
    final bytes = base64Url.decode(encoded);
    final jsonString = utf8.decode(bytes);
    final json = jsonDecode(jsonString);
    return SharedListData.fromJson(json);
  }

  /// Registrar callback para cuando se recibe una lista
  void setOnListReceivedCallback(Function(SharedListData) callback) {
    onListReceived = callback;
  }

  /* ==================== FIREBASE METHODS ==================== */

  /// Generar share link usando Firebase Realtime Database
  Future<String> _generateFirebaseShareLink(SharedListData listData) async {
    try {
      // Generar ID único
      final id = _generateFirebaseId();

      // Preparar datos para Firebase
      final now = DateTime.now().millisecondsSinceEpoch;
      final expiresAt = DateTime.now().add(Duration(days: 30)).millisecondsSinceEpoch;

      final firebaseData = {
        ...listData.toJson(),
        'createdAt': now,
        'expiresAt': expiresAt,
      };

      print('🔥 Guardando lista en Firebase con ID: $id');

      // Guardar en Firebase
      final ref = _database.ref('shared_lists/$id');
      await ref.set(firebaseData);

      // Generar URL HTTPS
      final shareUrl = '$apiBaseUrl/share/$id';
      print('✅ Lista guardada en Firebase: $shareUrl');

      return shareUrl;
    } catch (e) {
      print('❌ Error al guardar en Firebase: $e');
      // Fallback a custom scheme
      final encodedData = _encodeListData(listData);
      return '$scheme://$host?data=$encodedData';
    }
  }

  /// Obtener lista compartida desde Firebase
  Future<SharedListData> _fetchFirebaseSharedList(String shareId) async {
    try {
      print('🔥 Obteniendo lista de Firebase: $shareId');

      final ref = _database.ref('shared_lists/$shareId');
      final snapshot = await ref.get();

      if (!snapshot.exists) {
        throw Exception('Lista no encontrada o expirada');
      }

      // Firebase devuelve Object?, necesitamos convertirlo correctamente
      final rawData = snapshot.value;
      print('🔥 Tipo de datos recibidos: ${rawData.runtimeType}');

      if (rawData is! Map) {
        throw Exception('Formato de datos inválido');
      }

      // Convertir Map<Object?, Object?> a Map<String, dynamic>
      final data = <String, dynamic>{};
      rawData.forEach((key, value) {
        if (key != null) {
          data[key.toString()] = value;
        }
      });

      print('🔥 Datos convertidos correctamente');

      // Verificar si la lista expiró
      final expiresAt = data['expiresAt'] as int?;
      if (expiresAt != null) {
        final expirationDate = DateTime.fromMillisecondsSinceEpoch(expiresAt);
        if (DateTime.now().isAfter(expirationDate)) {
          // Lista expirada, eliminarla
          await ref.remove();
          throw Exception('Lista expirada');
        }
      }

      print('✅ Lista obtenida de Firebase, parseando...');
      return SharedListData.fromJson(data);
    } catch (e) {
      print('❌ Error al obtener de Firebase: $e');
      rethrow;
    }
  }

  /// Generar ID único para Firebase (8 caracteres)
  String _generateFirebaseId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    var id = '';
    var seed = random;

    for (var i = 0; i < 8; i++) {
      seed = (seed * 1103515245 + 12345) & 0x7fffffff;
      id += chars[seed % chars.length];
    }

    return id;
  }

  /// Limpiar listas expiradas de Firebase (mantenimiento)
  Future<void> cleanExpiredLists() async {
    try {
      final ref = _database.ref('shared_lists');
      final snapshot = await ref.get();

      if (!snapshot.exists) return;

      final rawLists = snapshot.value;
      if (rawLists is! Map) return;

      final now = DateTime.now().millisecondsSinceEpoch;
      var deletedCount = 0;

      for (final entry in rawLists.entries) {
        final key = entry.key?.toString();
        if (key == null) continue;

        final rawListData = entry.value;
        if (rawListData is! Map) continue;

        final listData = <String, dynamic>{};
        rawListData.forEach((k, v) {
          if (k != null) {
            listData[k.toString()] = v;
          }
        });

        final expiresAt = listData['expiresAt'] as int?;

        if (expiresAt != null && now > expiresAt) {
          await ref.child(key).remove();
          deletedCount++;
        }
      }

      print('🧹 Limpiadas $deletedCount listas expiradas de Firebase');
    } catch (e) {
      print('❌ Error al limpiar listas expiradas: $e');
    }
  }
}

/// Datos de lista compartida (versión simplificada para compartir)
class SharedListData {
  final String name;
  final String categoryName;
  final String currency;
  final List<SharedProductData> products;

  SharedListData({
    required this.name,
    required this.categoryName,
    required this.currency,
    required this.products,
  });

  /// Convertir a JSON para API (nombres completos)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'categoryName': categoryName,
      'currency': currency,
      'products': products.map((p) => p.toJson()).toList(),
    };
  }

  /// Convertir a JSON compacto para deep links (nombres abreviados)
  Map<String, dynamic> toCompactJson() {
    return {
      'n': name,
      'c': categoryName,
      'u': currency,
      'p': products.map((p) => p.toCompactJson()).toList(),
    };
  }

  factory SharedListData.fromJson(Map<String, dynamic> json) {
    // Soportar ambos formatos: completo y compacto
    if (json.containsKey('name')) {
      // Formato completo (desde API o Firebase)
      final productsList = json['products'] as List;
      final products = productsList.map((p) {
        // Convertir cada producto a Map<String, dynamic> si es necesario
        if (p is Map<String, dynamic>) {
          return SharedProductData.fromJson(p);
        } else if (p is Map) {
          final productMap = <String, dynamic>{};
          p.forEach((k, v) {
            if (k != null) {
              productMap[k.toString()] = v;
            }
          });
          return SharedProductData.fromJson(productMap);
        } else {
          throw Exception('Formato de producto inválido');
        }
      }).toList();

      return SharedListData(
        name: json['name'] as String,
        categoryName: json['categoryName'] as String,
        currency: json['currency'] as String,
        products: products,
      );
    } else {
      // Formato compacto (desde deep link)
      final productsList = json['p'] as List;
      final products = productsList.map((p) {
        if (p is Map<String, dynamic>) {
          return SharedProductData.fromJson(p);
        } else if (p is Map) {
          final productMap = <String, dynamic>{};
          p.forEach((k, v) {
            if (k != null) {
              productMap[k.toString()] = v;
            }
          });
          return SharedProductData.fromJson(productMap);
        } else {
          throw Exception('Formato de producto inválido');
        }
      }).toList();

      return SharedListData(
        name: json['n'] as String,
        categoryName: json['c'] as String,
        currency: json['u'] as String,
        products: products,
      );
    }
  }

  double get total {
    return products.fold(0.0, (sum, p) => sum + p.subtotal);
  }

  int get totalProducts => products.length;

  int get totalItems {
    return products.fold(0, (sum, p) => sum + p.quantity);
  }
}

/// Datos de producto compartido
class SharedProductData {
  final String name;
  final double price;
  final int quantity;

  SharedProductData({
    required this.name,
    required this.price,
    required this.quantity,
  });

  double get subtotal => price * quantity;

  /// Convertir a JSON para API (nombres completos)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }

  /// Convertir a JSON compacto para deep links (nombres abreviados)
  Map<String, dynamic> toCompactJson() {
    return {
      'n': name,
      'r': price,
      'q': quantity,
    };
  }

  factory SharedProductData.fromJson(Map<String, dynamic> json) {
    // Soportar ambos formatos: completo y compacto
    if (json.containsKey('name')) {
      // Formato completo (desde API)
      return SharedProductData(
        name: json['name'] as String,
        price: (json['price'] as num).toDouble(),
        quantity: json['quantity'] as int,
      );
    } else {
      // Formato compacto (desde deep link)
      return SharedProductData(
        name: json['n'] as String,
        price: (json['r'] as num).toDouble(),
        quantity: json['q'] as int,
      );
    }
  }
}
