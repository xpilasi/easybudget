import 'package:equatable/equatable.dart';

/// Entidad User del dominio
/// Representa un usuario de la aplicación
class User extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String photoUrl;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.photoUrl,
  });

  /// Nombre completo del usuario
  String get fullName => '$firstName $lastName';

  /// Iniciales del usuario (para avatares)
  String get initials {
    final first = firstName.isNotEmpty ? firstName[0] : '';
    final last = lastName.isNotEmpty ? lastName[0] : '';
    return '$first$last'.toUpperCase();
  }

  @override
  List<Object?> get props => [id, email, firstName, lastName, photoUrl];

  @override
  String toString() => 'User(id: $id, email: $email, name: $fullName)';
}
