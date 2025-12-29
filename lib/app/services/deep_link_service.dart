import 'dart:async';
import 'dart:convert';
import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import '../../domain/entities/shopping_list.dart';

/// Servicio para manejar deep links
/// Genera y procesa enlaces para compartir listas
class DeepLinkService extends GetxService {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  // Callback cuando se recibe un deep link con datos de lista
  Function(SharedListData)? onListReceived;

  // Esquema de deep link
  static const String scheme = 'easybudget';
  static const String host = 'share';

  @override
  void onInit() {
    super.onInit();
    _initDeepLinks();
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
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        _handleDeepLink(uri);
      }
    } catch (e) {
      print('Error al obtener deep link inicial: $e');
    }
  }

  /// Manejar deep link
  void _handleDeepLink(Uri uri) {
    if (uri.scheme != scheme || uri.host != host) {
      print('Deep link no reconocido: $uri');
      return;
    }

    // Obtener datos de la lista del query parameter
    final listDataParam = uri.queryParameters['data'];
    if (listDataParam == null) {
      print('Deep link sin datos de lista');
      return;
    }

    try {
      // Decodificar datos
      final listData = _decodeListData(listDataParam);

      // Notificar a través del callback
      if (onListReceived != null) {
        onListReceived!(listData);
      }
    } catch (e) {
      print('Error al decodificar datos de lista: $e');
      Get.snackbar(
        'Error',
        'No se pudo importar la lista',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Generar deep link para compartir una lista
  String generateShareLink(ShoppingList list, String categoryName) {
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

    final encodedData = _encodeListData(listData);
    return '$scheme://$host?data=$encodedData';
  }

  /// Generar texto para compartir por WhatsApp (optimizado)
  String generateWhatsAppMessage(ShoppingList list, String categoryName) {
    final deepLink = generateShareLink(list, categoryName);

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
  String generateWhatsAppUrl(ShoppingList list, String categoryName) {
    final message = generateWhatsAppMessage(list, categoryName);
    final encodedMessage = Uri.encodeComponent(message);
    return 'https://wa.me/?text=$encodedMessage';
  }

  /// Codificar datos de lista a string
  String _encodeListData(SharedListData data) {
    final json = data.toJson();
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

  Map<String, dynamic> toJson() {
    return {
      'n': name,
      'c': categoryName,
      'u': currency,
      'p': products.map((p) => p.toJson()).toList(),
    };
  }

  factory SharedListData.fromJson(Map<String, dynamic> json) {
    return SharedListData(
      name: json['n'] as String,
      categoryName: json['c'] as String,
      currency: json['u'] as String,
      products: (json['p'] as List)
          .map((p) => SharedProductData.fromJson(p))
          .toList(),
    );
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

  Map<String, dynamic> toJson() {
    return {
      'n': name,
      'r': price,
      'q': quantity,
    };
  }

  factory SharedProductData.fromJson(Map<String, dynamic> json) {
    return SharedProductData(
      name: json['n'] as String,
      price: (json['r'] as num).toDouble(),
      quantity: json['q'] as int,
    );
  }
}
