import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

/// Modelo UserModel para serialización JSON
/// Extiende de la entidad User del dominio
@JsonSerializable()
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.photoUrl,
  });

  /// Crear desde JSON
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Convertir a JSON
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Crear modelo desde entidad
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      photoUrl: user.photoUrl,
    );
  }

  /// Convertir modelo a entidad
  User toEntity() {
    return User(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      photoUrl: photoUrl,
    );
  }
}
