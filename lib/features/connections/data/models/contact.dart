import 'package:clean_architecture/features/connections/domain/entities/contact.dart';

class PhoneModel {
  final int telefonoid;
  final String numero;
  PhoneModel(this.telefonoid, this.numero);

  static List<PhoneModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map(
          (json) =>
              PhoneModel(json['telefonoid'] as int, json['numero'] as String),
        )
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {'telefonoid': telefonoid, 'numero': numero};
  }

  factory PhoneModel.fromJson(Map<String, dynamic> json) {
    return PhoneModel(json['telefonoid'] as int, json['numero'] as String);
  }

  PhoneEntity toEntity() {
    return PhoneEntity(telefonoid, numero);
  }
}

class EmailModel {
  final int correoid;
  final String email;
  EmailModel(this.correoid, this.email);

  static List<EmailModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map(
          (json) =>
              EmailModel(json['correoid'] as int, json['email'] as String),
        )
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {'correoid': correoid, 'email': email};
  }

  factory EmailModel.fromJson(Map<String, dynamic> json) {
    return EmailModel(json['correoid'] as int, json['email'] as String);
  }

  EmailEntity toEntity() {
    return EmailEntity(correoid, email);
  }
}
